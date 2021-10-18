#!/usr/bin/env python3

import os
import math
import argparse

from migen import *

from litex_boards.platforms import artix_dc_scm #, ecp5_dc_scm
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.soc_sdram import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

from litedram.modules import MT41K128M16
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
    def __init__(self, *, device, with_pcie, with_etherbone, with_ethernet, with_sdram, eth_dynamic_ip,
            eth_reset_time, toolchain="vivado", sys_clk_freq=int(100e6), eth_ip="192.168.1.120", **kwargs):
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
            self.add_sdram("sdram",
                phy                     = self.ddrphy,
                module                  = MT41K128M16(sys_clk_freq, "1:4"),
                origin                  = self.mem_map["main_ram"],
                l2_cache_size           = kwargs.get("l2_size", 8192)
            )

        # Ethernet / Etherbone ---------------------------------------------------------------------
        if with_ethernet or with_etherbone:
            self.submodules.ethphy = LiteEthS7PHYRGMII(
                clock_pads = self.platform.request("eth_clocks"),
                pads       = self.platform.request("eth"),
                hw_reset_cycles = math.ceil(float(eth_reset_time) * self.sys_clk_freq))
            self.add_ethernet(phy=self.ethphy, dynamic_ip=eth_dynamic_ip)
            platform.add_platform_command("set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets main_ethphy_eth_rx_clk_ibuf]")
            if with_etherbone:
                self.add_etherbone(phy=self.ethphy, ip_address=eth_ip)

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
    group.add_argument("--with-etherbone",   action="store_true",  help="Add Etherbone")
    group.add_argument("--eth-ip",           default="192.168.1.120", type=str, help="Ethernet/Etherbone IP address")
    group.add_argument("--eth-dynamic-ip",   action="store_true",  help="Enable dynamic Ethernet IP addresses setting")
    group.add_argument("--with-sdram",       action="store_true",  help="Add SDRAM")
    group.add_argument("--with-emmc",        action="store_true",  help="Add eMMC")
    group.add_argument("--eth-reset-time",   default="10e-3",      help="Duration of Ethernet PHY reset")
    builder_args(parser)
    soc_core_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    soc = BaseSoC(
        device         = args.device,
        toolchain      = args.toolchain,
        sys_clk_freq   = int(float(args.sys_clk_freq)),
        with_pcie      = args.with_pcie,
        with_ethernet  = args.with_ethernet,
        with_etherbone = args.with_etherbone,
        eth_ip         = args.eth_ip,
        eth_dynamic_ip = args.eth_dynamic_ip,
        with_sdram     = args.with_sdram,
        eth_reset_time = args.eth_reset_time,
        **soc_core_argdict(args)
    )

    if args.with_emmc:
        soc.add_sdcard(software_debug=False)

    builder = Builder(soc, **builder_argdict(args))
    builder_kwargs = vivado_build_argdict(args) if args.toolchain == "vivado" else {}
    builder.build(**builder_kwargs, run=args.build)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

if __name__ == "__main__":
    main()

