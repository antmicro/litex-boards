#!/usr/bin/env python3

# This file is Copyright (c) 2020 Antmicro <www.antmicro.com>
# This file is Copyright (c) 2019 David Shah <dave@ds0.me>
# License: BSD

import os
import argparse

from migen import *

from litex_boards.platforms import zcu104

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.soc_sdram import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser
from litex.soc.cores.bitbang import I2CMaster

from litedram import modules as litedram_modules
from litedram.modules import SDRAMModule, parse_spd_hexdump
from litedram.phy import usddrphy

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq):
        self.clock_domains.cd_sys    = ClockDomain()
        self.clock_domains.cd_sys4x  = ClockDomain(reset_less=True)
        self.clock_domains.cd_pll4x  = ClockDomain(reset_less=True)
        self.clock_domains.cd_clk500 = ClockDomain()

        # # #

        self.submodules.pll = pll = USMMCM(speedgrade=-2)
        pll.register_clkin(platform.request("clk125"), 125e6)
        pll.create_clkout(self.cd_pll4x, sys_clk_freq*4, buf=None, with_reset=False)
        pll.create_clkout(self.cd_clk500, 500e6, with_reset=False)

        self.specials += [
            Instance("BUFGCE_DIV", name="main_bufgce_div",
                p_BUFGCE_DIVIDE=4,
                i_CE=1, i_I=self.cd_pll4x.clk, o_O=self.cd_sys.clk),
            Instance("BUFGCE", name="main_bufgce",
                i_CE=1, i_I=self.cd_pll4x.clk, o_O=self.cd_sys4x.clk),
            AsyncResetSynchronizer(self.cd_clk500, ~pll.locked),
        ]

        self.submodules.idelayctrl = USIDELAYCTRL(cd_ref=self.cd_clk500, cd_sys=self.cd_sys)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=int(125e6), sdram_module_cls="MTA4ATF51264HZ", spd_data=None,
                 **kwargs):
        platform = zcu104.Platform()

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, clk_freq=sys_clk_freq, **kwargs)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform, sys_clk_freq)

        # DDR4 SDRAM -------------------------------------------------------------------------------
        if not self.integrated_main_ram_size:
            self.submodules.ddrphy = usddrphy.USPDDRPHY(platform.request("ddram"),
                memtype          = "DDR4",
                sys_clk_freq     = sys_clk_freq,
                iodelay_clk_freq = 500e6,
                cmd_latency      = 1)
            self.add_csr("ddrphy")
            if spd_data:
                module = SDRAMModule.from_spd_data(spd_data, sys_clk_freq)
            else:
                module = getattr(litedram_modules, sdram_module_cls)(sys_clk_freq, "1:4")
            self.add_sdram("sdram",
                phy                     = self.ddrphy,
                module                  = module,
                origin                  = self.mem_map["main_ram"],
                size                    = kwargs.get("max_sdram_size", 0x40000000),
                l2_cache_size           = kwargs.get("l2_size", 8192),
                l2_cache_min_data_width = kwargs.get("min_l2_data_width", 128),
                l2_cache_reverse        = True
            )

            self.submodules.i2c = I2CMaster(platform.request("i2c"))
            self.add_csr("i2c")

        # Leds -------------------------------------------------------------------------------------
        self.submodules.leds = LedChaser(
            pads         = Cat(*[platform.request("user_led", i) for i in range(4)]),
            sys_clk_freq = sys_clk_freq)
        self.add_csr("leds")

# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="LiteX SoC on ZCU104")
    parser.add_argument("--build", action="store_true", help="Build bitstream")
    parser.add_argument("--load",  action="store_true", help="Load bitstream")
    parser.add_argument("--sdram-spd-dump", help="Generate SDRAMModule parameters from SPD dump")
    parser.add_argument("--sdram-module", choices=["MTA4ATF51264HZ", "KVR21SE15S84"],
                        help="Use given SDRAM module")
    builder_args(parser)
    soc_sdram_args(parser)
    args = parser.parse_args()

    kwargs = soc_sdram_argdict(args)
    if args.sdram_spd_dump:
        kwargs["spd_data"] = parse_spd_hexdump(args.sdram_spd_dump)
    if args.sdram_module:
        kwargs["sdram_module_cls"] = args.sdram_module
    soc = BaseSoC(**kwargs)
    builder = Builder(soc, **builder_argdict(args))
    builder.build(run=args.build)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

if __name__ == "__main__":
    main()
