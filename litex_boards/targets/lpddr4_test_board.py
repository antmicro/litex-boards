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

from litedram.modules import MT41K128M16
from litedram.phy import s7ddrphy

from liteeth.phy.mii import LiteEthPHYMII

from litehyperbus.core.hyperbus import HyperRAM

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq):
        self.clock_domains.cd_sys       = ClockDomain()
        self.clock_domains.cd_sys4x     = ClockDomain(reset_less=True)
        self.clock_domains.cd_sys4x_dqs = ClockDomain(reset_less=True)
        self.clock_domains.cd_idelay    = ClockDomain()
        self.clock_domains.cd_eth       = ClockDomain()

        # # #

        self.submodules.pll = pll = S7PLL(speedgrade=-1)
        # self.comb += pll.reset.eq(~platform.request("cpu_reset"))
        pll.register_clkin(platform.request("clk100"), 100e6)
        pll.create_clkout(self.cd_sys,       sys_clk_freq)
        pll.create_clkout(self.cd_sys4x,     4*sys_clk_freq)
        pll.create_clkout(self.cd_sys4x_dqs, 4*sys_clk_freq, phase=90)
        pll.create_clkout(self.cd_idelay,    200e6)
        pll.create_clkout(self.cd_eth,       25e6)

        self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)

        self.comb += platform.request("eth_ref_clk").eq(self.cd_eth.clk)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=int(100e6), **kwargs):
        platform = lpddr4_test_board.Platform()

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq,
            ident          = "LiteX SoC",
            ident_version  = True,
            integrated_main_ram_size=0x10000,
            **kwargs)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform, sys_clk_freq)

        # # DDR3 SDRAM -------------------------------------------------------------------------------
        # self.submodules.ddrphy = s7ddrphy.A7DDRPHY(platform.request("ddram"),
        #     memtype        = "DDR3",
        #     nphases        = 4,
        #     sys_clk_freq   = sys_clk_freq)
        # self.add_csr("ddrphy")
        # self.add_sdram("sdram",
        #     phy                     = self.ddrphy,
        #     module                  = MT41K128M16(sys_clk_freq, "1:4"),
        #     origin                  = self.mem_map["main_ram"],
        #     size                    = kwargs.get("max_sdram_size", 0x40000000),
        #     l2_cache_size           = kwargs.get("l2_size", 8192),
        #     l2_cache_min_data_width = kwargs.get("min_l2_data_width", 128),
        #     l2_cache_reverse        = True
        # )

        # Ethernet / Etherbone ---------------------------------------------------------------------
        self.submodules.ethphy = LiteEthPHYMII(
            clock_pads = self.platform.request("eth_clocks"),
            pads       = self.platform.request("eth"))
        self.add_csr("ethphy")
        self.add_ethernet(phy=self.ethphy)

        # HyperRAM ---------------------------------------------------------------------------------
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
    parser.add_argument("--build", action="store_true", help="Build bitstream")
    parser.add_argument("--load",  action="store_true", help="Load bitstream")
    builder_args(parser)
    soc_sdram_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    soc = BaseSoC(**soc_sdram_argdict(args))
    builder = Builder(soc, **builder_argdict(args))
    builder.build(**vivado_build_argdict(args), run=args.build)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

if __name__ == "__main__":
    main()

