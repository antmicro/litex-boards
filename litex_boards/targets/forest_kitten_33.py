#!/usr/bin/env python3

# This file is Copyright (c) 2020 Florent Kermarrec <florent@enjoy-digital.fr>
# License: BSD

import os
import argparse

from migen import *

from litex_boards.platforms import forest_kitten_33

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.integration.soc import *
from litex.soc.cores.led import LedChaser
from litex.soc.interconnect import wishbone, axi

from litex_boards.targets.hbm.hbm import HBMIP
from litex_boards.targets.hbm import wb2axi

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq):
        self.clock_domains.cd_sys     = ClockDomain()
        self.clock_domains.cd_hbm_ref = ClockDomain()
        self.clock_domains.cd_apb     = ClockDomain()

        # # #

        self.submodules.pll = pll = USMMCM(speedgrade=-2)
        pll.register_clkin(platform.request("clk200"), 200e6)
        pll.create_clkout(self.cd_sys, sys_clk_freq)
        pll.create_clkout(self.cd_hbm_ref, 100e6)
        pll.create_clkout(self.cd_apb, 100e6)
        assert 225e6 <= sys_clk_freq <= 450e6

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=int(450e6), **kwargs):
        platform = forest_kitten_33.Platform()

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, clk_freq=sys_clk_freq, **kwargs)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform, sys_clk_freq)

        # Leds -------------------------------------------------------------------------------------
        self.submodules.leds = LedChaser(
            pads         = Cat(*[platform.request("user_led", i) for i in range(7)]),
            sys_clk_freq = sys_clk_freq)
        self.add_csr("leds")

        # HBM --------------------------------------------------------------------------------------
        hbm = HBMIP(platform)
        self.submodules.hbm = ClockDomainsRenamer({"axi": "sys"})(hbm)
        self.add_csr("hbm")
        hbm_axi = hbm.axi[0]

        # Add main ram wishbone
        wb_hbm = wishbone.Interface()
        self.bus.add_region("main_ram", SoCRegion(
            origin=self.mem_map["main_ram"],
            size=kwargs.get("max_sdram_size", 0x40000000)  # 1GB; could be 8GB with wider address
        ))
        self.bus.add_slave("main_ram", wb_hbm)

        # Convertion: cpu.wishbone(32) <-> ... <-> hbm.axi(256)
        wb_pipe = wb2axi.WishbonePipelined()
        self.submodules.wbc2wbp = wb2axi.WishboneClassic2Pipeline(wb_hbm, wb_pipe)
        self.wbc2wbp.add_sources(platform)

        # AXI with address_width expected by wb2axi
        conv_axi = axi.AXIInterface(data_width=hbm_axi.data_width, address_width=32,
                                id_width=hbm_axi.id_width)
        for channel in ["aw", "w", "b", "ar", "r"]:
            self.comb += getattr(conv_axi, channel).connect(getattr(hbm_axi, channel))

        self.submodules.wb2axi = wb2axi.WishbonePipelined2AXI(
            wb_pipe, conv_axi, base_address=self.bus.regions["main_ram"].origin)
        self.wb2axi.add_sources(platform)


# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="LiteX SoC on Forest Kitten 33")
    parser.add_argument("--build", action="store_true", help="Build bitstream")
    parser.add_argument("--load",  action="store_true", help="Load bitstream")
    builder_args(parser)
    soc_core_args(parser)
    args = parser.parse_args()

    soc = BaseSoC(**soc_core_argdict(args))
    builder = Builder(soc, **builder_argdict(args))
    builder.build(run=args.build)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

if __name__ == "__main__":
    main()
