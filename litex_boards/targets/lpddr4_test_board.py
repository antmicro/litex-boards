#!/usr/bin/env python3

import os
import argparse

from migen import *

from litex_boards.platforms import lpddr4_test_board
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.soc_sdram import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

from litedram.modules import MT53E256M16D1
from litedram.phy.lpddr4 import S7LPDDR4PHY

from liteeth.phy import LiteEthS7PHYRGMII

from litehyperbus.core.hyperbus import HyperRAM

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq, with_sdram, with_ethernet):
        self.clock_domains.cd_sys       = ClockDomain()
        if with_sdram:
            self.clock_domains.cd_sys2x     = ClockDomain(reset_less=True)
            self.clock_domains.cd_sys8x     = ClockDomain(reset_less=True)
            self.clock_domains.cd_idelay    = ClockDomain()
        if with_ethernet:
            self.clock_domains.cd_eth       = ClockDomain()

        # # #

        self.submodules.pll = pll = S7PLL(speedgrade=-1)
        # self.comb += pll.reset.eq(~platform.request("cpu_reset"))
        pll.register_clkin(platform.request("clk100"), 100e6)
        pll.create_clkout(self.cd_sys,       sys_clk_freq)
        if with_sdram:
            pll.create_clkout(self.cd_sys2x,     2*sys_clk_freq)
            pll.create_clkout(self.cd_sys8x,     8*sys_clk_freq)
            # pll.create_clkout(self.cd_sys8x_dqs, 4*sys_clk_freq, phase=90)
            pll.create_clkout(self.cd_idelay,    200e6)
        if with_ethernet:
            pll.create_clkout(self.cd_eth,       25e6)

        if with_sdram:
            self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)

        if with_ethernet:
            self.comb += platform.request("eth_ref_clk").eq(self.cd_eth.clk)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq, with_sdram, with_ethernet, with_hyperram, **kwargs):
        platform = lpddr4_test_board.Platform()

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq,
            ident          = "LiteX SoC",
            ident_version  = True,
            **kwargs)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform,
            sys_clk_freq=sys_clk_freq, with_sdram=with_sdram, with_ethernet=with_ethernet)

        # LDDR4 SDRAM ------------------------------------------------------------------------------
        if with_sdram:
            self.submodules.ddrphy = S7LPDDR4PHY(platform.request("lpddr4"),
                iodelay_clk_freq = 200e6,
                sys_clk_freq     = sys_clk_freq)
            self.add_csr("ddrphy")
            self.add_sdram("sdram",
                phy                     = self.ddrphy,
                module                  = MT53E256M16D1(sys_clk_freq, "1:8"),
                origin                  = self.mem_map["main_ram"],
                size                    = kwargs.get("max_sdram_size", 0x40000000),
                l2_cache_size           = kwargs.get("l2_size", 8192),
                l2_cache_min_data_width = kwargs.get("min_l2_data_width", 128),
                l2_cache_reverse        = True
            )

        # Ethernet / Etherbone ---------------------------------------------------------------------
        if with_ethernet:
            self.submodules.ethphy = LiteEthS7PHYRGMII(
                clock_pads = self.platform.request("eth_clocks"),
                pads       = self.platform.request("eth"))
            self.add_csr("ethphy")
            self.add_ethernet(phy=self.ethphy)

        # HyperRAM ---------------------------------------------------------------------------------
        if with_hyperram:
            hyperram_base = 0x30000000
            self.submodules.hyperram = HyperRAM(platform.request("hyperram"))
            self.add_wb_slave(hyperram_base, self.hyperram.bus)
            self.add_memory_region("hyperram", hyperram_base, 8*1024*1024)  # TODO: size?

        # Leds -------------------------------------------------------------------------------------
        self.submodules.leds = LedChaser(
            pads         = platform.request_all("user_led"),
            sys_clk_freq = sys_clk_freq)
        self.add_csr("leds")

# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="LiteX SoC")
    target = parser.add_argument_group(title="Target options")
    target.add_argument("--build", action="store_true", help="Build bitstream")
    target.add_argument("--load",  action="store_true", help="Load bitstream")
    target.add_argument("--sys-clk-freq", default="100e6", help="System clock frequency")
    target.add_argument("--with-sdram", action="store_true", help="Add LPDDR4 PHY")
    target.add_argument("--with-ethernet", action="store_true", help="Add Ethernet PHY")
    target.add_argument("--with-hyperram", action="store_true", help="Add HyperRAM")
    builder_args(parser)
    soc_sdram_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    soc_kwargs = soc_sdram_argdict(args)
    soc_kwargs['integrated_rom_size'] = 0x10000
    if not args.with_sdram and args.with_ethernet:
        # 1 MB just to satisfy BIOS requireing MAIN_RAM_BASE
        soc_kwargs["integrated_main_ram_size"] = 0x100000

    soc = BaseSoC(
        sys_clk_freq  = int(float(args.sys_clk_freq)),
        with_sdram    = args.with_sdram,
        with_ethernet = args.with_ethernet,
        with_hyperram = args.with_hyperram,
        **soc_kwargs)
    builder = Builder(soc, **builder_argdict(args))
    builder.build(**vivado_build_argdict(args), run=args.build)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

if __name__ == "__main__":
    main()

