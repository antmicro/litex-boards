#!/usr/bin/env python3

import os
import argparse

from migen import *

from litex_boards.platforms import artix_dc_scm #, ecp5_dc_scm
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.soc_sdram import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

from litedram.modules import AS4C256M16D3A
from litedram.phy import s7ddrphy

from liteeth.phy import LiteEthS7PHYRGMII

from litepcie.phy.s7pciephy import S7PCIEPHY

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq):
        self.rst = Signal()
        self.clock_domains.cd_sys       = ClockDomain()
        self.clock_domains.cd_sys4x     = ClockDomain(reset_less=True)
        self.clock_domains.cd_sys4x_dqs = ClockDomain(reset_less=True)
        self.clock_domains.cd_idelay    = ClockDomain()

        self.clock_domains.cd_ulpi0     = ClockDomain()
        self.clock_domains.cd_ulpi1     = ClockDomain()

        # ulpi0 clock domain (60MHz from ulpi0)
        self.comb += self.cd_ulpi0.clk.eq(platform.request("ulpi_clock", 0))
        # ulpi1 clock domain (60MHz from ulpi1)
        self.comb += self.cd_ulpi1.clk.eq(platform.request("ulpi_clock", 1))

        # # #

        self.submodules.pll = pll = S7PLL(speedgrade=-1)
        # self.comb += pll.reset.eq(~platform.request("cpu_reset") | self.rst)
        self.comb += pll.reset.eq(self.rst)
        pll.register_clkin(platform.request("clk100"), 100e6)
        pll.create_clkout(self.cd_sys,       sys_clk_freq)
        pll.create_clkout(self.cd_sys4x,     4*sys_clk_freq)
        pll.create_clkout(self.cd_sys4x_dqs, 4*sys_clk_freq, phase=90)
        pll.create_clkout(self.cd_idelay,    200e6)

        self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, *, device, with_pcie, with_ethernet, with_sdram, toolchain="vivado",
            sys_clk_freq=int(100e6), **kwargs):
        platform = artix_dc_scm.Platform(device=device, toolchain=toolchain)

        # SoCCore ----------------------------------------------------------------------------------
        kwargs['integrated_rom_size'] = 0x10000
        SoCCore.__init__(self, platform, sys_clk_freq,
            ident          = "LiteX SoC",
            ident_version  = False,
            **kwargs)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform, sys_clk_freq)

        # DDR3 SDRAM -------------------------------------------------------------------------------
        if with_sdram:
            self.submodules.ddrphy = s7ddrphy.A7DDRPHY(platform.request("ddram"),
                memtype        = "DDR3",
                nphases        = 4,
                sys_clk_freq   = sys_clk_freq)
            self.add_csr("ddrphy")
            self.add_sdram("sdram",
                phy                     = self.ddrphy,
                module                  = AS4C256M16D3A(sys_clk_freq, "1:4"),
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
            # self.add_etherbone(phy=self.ethphy)

        # PCIe -------------------------------------------------------------------------------------
        if with_pcie:
            self.submodules.pcie_phy = S7PCIEPHY(platform, platform.request("pcie_x1"),
                data_width = 128,
                bar0_size  = 0x20000)
            self.add_csr("pcie_phy")
            self.add_pcie(phy=self.pcie_phy, ndmas=1)

        # Leds -------------------------------------------------------------------------------------
        self.submodules.leds = LedChaser(
            pads         = platform.request_all("user_led"),
            sys_clk_freq = sys_clk_freq)
        self.add_csr("leds")

# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="Artix DC-SCM LiteX SoC")
    group = parser.add_argument_group(title="Artix DC-SCM")
    group.add_argument("--toolchain",        default="vivado",     help="Toolchain use to build (default: vivado)")
    group.add_argument("--build",            action="store_true",  help="Build bitstream")
    group.add_argument("--load",             action="store_true",  help="Load bitstream")
    group.add_argument("--sys-clk-freq",     default=100e6,        help="System clock frequency (default: 100MHz)")
    group.add_argument("--device",           choices=["xc7a100tfgg484-1", "xc7a15tfgg484-1"], required=True)
    group.add_argument("--with-pcie",        action="store_true",  help="Add PCIe")
    group.add_argument("--with-ethernet",    action="store_true",  help="Add Ethernet")
    group.add_argument("--with-sdram",    action="store_true",  help="Add SDRAM")
    builder_args(parser)
    soc_sdram_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    soc = BaseSoC(
        device         = args.device,
        toolchain      = args.toolchain,
        sys_clk_freq   = int(float(args.sys_clk_freq)),
        with_pcie      = args.with_pcie,
        with_ethernet  = args.with_ethernet,
        with_sdram     = args.with_sdram,
        **soc_sdram_argdict(args)
    )
    builder = Builder(soc, **builder_argdict(args))
    builder_kwargs = vivado_build_argdict(args) if args.toolchain == "vivado" else {}
    builder.build(**builder_kwargs, run=args.build)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

if __name__ == "__main__":
    main()

