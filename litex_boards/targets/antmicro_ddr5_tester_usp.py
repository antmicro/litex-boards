#!/usr/bin/env python3
#
# This file is part of LiteX-Boards.
#
# Copyright (c) 2022 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: BSD-2-Clause

import os
import math
import json

from migen import *

from litex_boards.platforms import antmicro_ddr5_tester_usp
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.soc import SoCRegion
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser
from litex.soc.cores.bitbang import I2CMaster

#from litedram.modules import M329R8GA0BB0
#from litedram.phy.ddr5 import K7DDR5PHY
from litedram.init import get_sdram_phy_py_header
from litedram.core.controller import ControllerSettings
from litedram.common import PhySettings, GeomSettings, TimingSettings

from liteeth.phy import LiteEthUSPHYRGMII
from litex.soc.cores.hyperbus import HyperRAM

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq, iodelay_clk_freq):
        self.clock_domains.cd_sys       = ClockDomain()
        self.clock_domains.cd_sys2x     = ClockDomain()
        self.clock_domains.cd_idelay    = ClockDomain()
        self.clock_domains.cd_sys8x     = ClockDomain()

        # # #

        # Clk
        clk100 = platform.request("clk100")

        self.submodules.pll = pll = USPMMCM(speedgrade=-1)
        pll.register_clkin(clk100, 100e6)
        pll.create_clkout(self.cd_sys,       sys_clk_freq, with_reset=False)
        pll.create_clkout(self.cd_sys2x,     2 * sys_clk_freq)
        pll.create_clkout(self.cd_sys8x,     8 * sys_clk_freq)
        pll.create_clkout(self.cd_idelay,    iodelay_clk_freq)

        self.submodules.idelayctrl = USPIDELAYCTRL(self.cd_idelay, self.cd_sys)


# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, *, sys_clk_freq=int(100e6), iodelay_clk_freq=200e6,
            with_ethernet=False, with_etherbone=False, eth_ip="192.168.1.50", eth_reset_time="10e-3", eth_dynamic_ip=False,
            with_hyperram=False, with_sdcard=False, with_jtagbone=True, with_uartbone=False, with_spi_flash=False,
            with_led_chaser=True, **kwargs):
        platform = antmicro_ddr5_tester_usp.Platform()

        self.submodules.crg = _CRG(platform, sys_clk_freq, iodelay_clk_freq=iodelay_clk_freq)

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq, ident="LiteX SoC on DDR5 Tester Ultrascale+", **kwargs)

        # DDR5 SDRAM RDIMM -------------------------------------------------------------------------
        ddr5_pads = platform.request("ddr5")

        # Remapping of data pins so that they align with appriopriate BITSLICEs
        # TODO: platform specific, probably should be somehow moved to platform.py
        A_dq = ddr5_pads.A_dq
        A_dq_perm = Cat( A_dq[0],  A_dq[2],  A_dq[1],  A_dq[3],
                A_dq[7],  A_dq[6],  A_dq[5],  A_dq[4],
                A_dq[10], A_dq[11], A_dq[8],  A_dq[9],
                A_dq[15], A_dq[14], A_dq[13], A_dq[12],
                A_dq[16], A_dq[17], A_dq[18], A_dq[19],
                A_dq[20], A_dq[21], A_dq[22], A_dq[23],
                A_dq[24], A_dq[26], A_dq[25], A_dq[27],
                A_dq[28], A_dq[30], A_dq[31], A_dq[29],
          )

        B_dq = ddr5_pads.B_dq
        B_dq_perm = Cat( B_dq[1],  B_dq[0],  B_dq[2],  B_dq[3],
                B_dq[4],  B_dq[7],  B_dq[6],  B_dq[5],
                B_dq[9],  B_dq[8],  B_dq[11], B_dq[10],
                B_dq[15], B_dq[13], B_dq[14], B_dq[12],
                B_dq[16], B_dq[18], B_dq[17], B_dq[19],
                B_dq[22], B_dq[20], B_dq[23], B_dq[21],
                B_dq[24], B_dq[26], B_dq[25], B_dq[27],
                B_dq[31], B_dq[30], B_dq[29], B_dq[28],
          )

        A_cb = ddr5_pads.A_cb
        A_cb_perm = Cat(A_cb[1], A_cb[0], A_cb[2], A_cb[3],
                A_cb[6], A_cb[4], A_cb[7], A_cb[5])

        B_cb = ddr5_pads.B_cb
        B_cb_perm = Cat(B_cb[3], B_cb[0], B_cb[1], B_cb[2],
                B_cb[4], B_cb[7], B_cb[6], B_cb[5])

        A_ca = ddr5_pads.A_ca
        A_cs = ddr5_pads.A_cs_n
        CC_perm = Cat(A_cs[0], A_cs[1], A_ca[4], A_ca[5], A_ca[2], A_ca[3], A_ca[1], A_ca[0], A_ca[6], A_ca[7])

        self.platform.add_source("ddr5phy_usp.sv")
        self.specials += Instance("ddr5_usp_phy",
                i_sys_clk        = ClockSignal("sys"),
                io_A_dq_pads     = A_dq_perm,
                io_A_dqs_t_pads  = ddr5_pads.A_dqs_t,
                io_A_dqs_c_pads  = ddr5_pads.A_dqs_c,
                io_A_cb_pads     = A_cb_perm,
                io_A_dqsb_t_pads = ddr5_pads.A_dqsb_t,
                io_A_dqsb_c_pads = ddr5_pads.A_dqsb_c,

                io_B_dq_pads     = B_dq_perm,
                io_B_dqs_t_pads  = ddr5_pads.B_dqs_t,
                io_B_dqs_c_pads  = ddr5_pads.B_dqs_c,
                io_B_cb_pads     = B_cb_perm,
                io_B_dqsb_t_pads = ddr5_pads.B_dqsb_t,
                io_B_dqsb_c_pads = ddr5_pads.B_dqsb_c,

                o_A_cc_pads = CC_perm,
                o_ck_t_pad = ddr5_pads.ck_t,
                o_ck_c_pad = ddr5_pads.ck_c
            )

        if False:
            if not self.integrated_main_ram_size:
                self.submodules.ddrphy = K7DDR5PHY(platform.request("ddr5"),
                    iodelay_clk_freq = iodelay_clk_freq,
                    sys_clk_freq     = sys_clk_freq)
                self.add_sdram("sdram",
                    phy                     = self.ddrphy,
                    module                  = M329R8GA0BB0(sys_clk_freq, "1:4"),
                    l2_cache_size           = kwargs.get("l2_size", 8192),
                    l2_cache_min_data_width = 256,
                    size                    = 0x40000000,
                )

        # HyperRAM ---------------------------------------------------------------------------------
        if with_hyperram:
            self.submodules.hyperram = HyperRAM(platform.request("hyperram"), sys_clk_freq=sys_clk_freq)
            self.bus.add_slave("hyperram", slave=self.hyperram.bus, region=SoCRegion(origin=0x20000000, size=8*1024*1024))

        # SD Card ----------------------------------------------------------------------------------
        if with_sdcard:
            self.add_sdcard()

        # Ethernet / Etherbone ---------------------------------------------------------------------
        if with_ethernet or with_etherbone:
            # Traces between PHY and FPGA introduce ignorable delays of ~0.165ns +/- 0.015ns.
            # PHY chip does not introduce delays on TX (FPGA->PHY), however it includes 1.2ns
            # delay for RX CLK so we only need 0.8ns to match the desired 2ns.
            self.submodules.ethphy = LiteEthUSPHYRGMII(
                clock_pads = self.platform.request("eth_clocks"),
                pads       = self.platform.request("eth"),
                rx_delay   = 0.8e-9,
                usp = True
            )
            if with_ethernet:
                self.add_ethernet(phy=self.ethphy, dynamic_ip=eth_dynamic_ip)
            if with_etherbone:
                self.add_etherbone(phy=self.ethphy, ip_address=eth_ip)

        # UartBone ---------------------------------------------------------------------------------
        if with_uartbone:
            self.add_uartbone("serial", baudrate=1e6)

        # Leds -------------------------------------------------------------------------------------
        if with_led_chaser:
            self.submodules.leds = LedChaser(
                pads         = platform.request_all("user_led"),
                sys_clk_freq = sys_clk_freq)

        # SPI Flash --------------------------------------------------------------------------------
        if with_spi_flash:
            self.add_spi_flash(mode="4x", module=S25FL128S0(Codes.READ_1_1_4), with_master=True)

        # I2C ----------------------------------------------------------
        i2c_pads = platform.request('i2c')
        self.submodules.i2c = I2CMaster(i2c_pads)

    def generate_sdram_phy_py_header(self, output_file):
        os.makedirs(os.path.dirname(output_file), exist_ok=True)
        f = open(output_file, "w")
        f.write(get_sdram_phy_py_header(
            self.sdram.controller.settings.phy,
            self.sdram.controller.settings.timing))
        f.close()


# Build --------------------------------------------------------------------------------------------

class LiteDRAMSettingsEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, (ControllerSettings, GeomSettings, PhySettings, TimingSettings)):
            ignored = ["self", "refresh_cls"]
            return {k: v for k, v in vars(o).items() if k not in ignored}
        elif isinstance(o, Signal) and isinstance(o.reset, Constant):
            return o.reset
        elif isinstance(o, Constant):
            return o.value
        print('o', end=' = '); __import__('pprint').pprint(o)
        return super().default(o)

def main():
    from litex.soc.integration.soc import LiteXSoCArgumentParser
    parser = LiteXSoCArgumentParser(description="LiteX SoC on DDR5 Tester Board")
    target_group = parser.add_argument_group(title="Target options")
    target_group.add_argument("--build",                  action="store_true",    help="Build design")
    target_group.add_argument("--load",                   action="store_true",    help="Load bitstream")
    target_group.add_argument("--flash",                  action="store_true",    help="Flash bitstream")
    target_group.add_argument("--sys-clk-freq",           default=100e6,           help="System clock frequency")
    target_group.add_argument("--iodelay-clk-freq",       default=200e6,          help="IODELAYCTRL frequency")
    ethopts = target_group.add_mutually_exclusive_group()
    ethopts.add_argument("--with-ethernet",         action="store_true",    help="Add Ethernet")
    ethopts.add_argument("--with-etherbone",        action="store_true",    help="Add EtherBone")
    target_group.add_argument("--eth-ip",                 default="192.168.1.50", help="Ethernet/Etherbone IP address")
    target_group.add_argument("--eth-dynamic-ip",         action="store_true",    help="Enable dynamic Ethernet IP addresses setting")
    target_group.add_argument("--eth-reset-time",         default="10e-3",        help="Duration of Ethernet PHY reset")
    target_group.add_argument("--with-hyperram",          action="store_true",    help="Add HyperRAM")
    target_group.add_argument("--with-sdcard",            action="store_true",    help="Add SDCard")
    target_group.add_argument("--with-jtagbone",          action="store_true",    help="Add JTAGBone")
    target_group.add_argument("--with-uartbone",          action="store_true",    help="Add UartBone on 2nd serial")
    target_group.add_argument("--with-video-terminal",    action="store_true",    help="Enable Video Terminal (HDMI)")
    target_group.add_argument("--with-video-framebuffer", action="store_true",    help="Enable Video Framebuffer (HDMI)")
    target_group.add_argument("--with-spi-flash",         action="store_true",    help="Enable SPI Flash (MMAPed).")
    builder_args(parser)
    soc_core_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    assert not (args.with_etherbone and args.eth_dynamic_ip)

    soc = BaseSoC(
        sys_clk_freq           = int(float(args.sys_clk_freq)),
        iodelay_clk_freq       = int(float(args.iodelay_clk_freq)),
        with_ethernet          = args.with_ethernet,
        with_etherbone         = args.with_etherbone,
        eth_ip                 = args.eth_ip,
        eth_dynamic_ip         = args.eth_dynamic_ip,
        with_hyperram          = args.with_hyperram,
        with_sdcard            = args.with_sdcard,
        with_jtagbone          = args.with_jtagbone,
        with_uartbone          = args.with_uartbone,
        with_spi_flash         = args.with_spi_flash,
        with_video_terminal    = args.with_video_terminal,
        with_video_framebuffer = args.with_video_framebuffer,
        **soc_core_argdict(args))
    builder = Builder(soc, **builder_argdict(args))
    if args.build:
        builder.build(**vivado_build_argdict(args))
        #builder.soc.generate_sdram_phy_py_header(os.path.join(builder.output_dir, "sdram_init.py"))
        # LiteDRAM settings (controller, phy, geom, timing)
        #with open(os.path.join(builder.output_dir, 'litedram_settings.json'), 'w') as f:
        #    json.dump(builder.soc.sdram.controller.settings, f, cls=LiteDRAMSettingsEncoder, indent=4)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(builder.get_bitstream_filename(mode="sram"))

    if args.flash:
        prog = soc.platform.create_programmer()
        prog.flash(0, builder.get_bitstream_filename(mode="flash"))

if __name__ == "__main__":
    main()
