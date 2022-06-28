# Copyright (c) 2022 Antmicro <www.antmicro.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#

from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform, VivadoProgrammer

# IOs ----------------------------------------------------------------------------------------------

_io = [
    # clk125
    ("clk125", 0, Pins("Y6"), IOStandard("LVCMOS33")),

    # user led
    ("user_led", 0, Pins("N22"), IOStandard("LVCMOS33")),
    ("user_led", 1, Pins("P22"), IOStandard("LVCMOS33")),
    ("user_led", 2, Pins("M15"), IOStandard("LVCMOS33")),
    ("user_led", 3, Pins("M16"), IOStandard("LVCMOS33")),
    ("user_led", 5, Pins("L17"), IOStandard("LVCMOS33")),
    ("user_led", 6, Pins("M17"), IOStandard("LVCMOS33")),
    ("user_led", 7, Pins("J21"), IOStandard("LVCMOS33")),
    ("user_led", 8, Pins("J22"), IOStandard("LVCMOS33")),

    # user btn
    ("user_btn", 0, Pins("W16"), IOStandard("LVCMOS33")),
    ("user_btn", 1, Pins("W18"), IOStandard("LVCMOS33")),
    ("user_btn", 2, Pins("Y16"), IOStandard("LVCMOS33")),
    ("user_btn", 3, Pins("W17"), IOStandard("LVCMOS33")),
    
    # serial
    ("serial", 0,
        Subsignal("tx", Pins("M17")),
        Subsignal("rx", Pins("J20")),
        IOStandard("LVCMOS33")
    ),
]

_ps7_io = [
    # ps7
    ("ps7_clk",   0, Pins(1)),
    ("ps7_porb",  0, Pins(1)),
    ("ps7_srstb", 0, Pins(1)),
    ("ps7_mio",   0, Pins(54)),
    ("ps7_ddram", 0,
        Subsignal("addr",    Pins(15)),
        Subsignal("ba",      Pins(3)),
        Subsignal("cas_n",   Pins(1)),
        Subsignal("ck_n",    Pins(1)),
        Subsignal("ck_p",    Pins(1)),
        Subsignal("cke",     Pins(1)),
        Subsignal("cs_n",    Pins(1)),
        Subsignal("dm",      Pins(4)),
        Subsignal("dq",      Pins(32)),
        Subsignal("dqs_n",   Pins(4)),
        Subsignal("dqs_p",   Pins(4)),
        Subsignal("odt",     Pins(1)),
        Subsignal("ras_n",   Pins(1)),
        Subsignal("reset_n", Pins(1)),
        Subsignal("we_n",    Pins(1)),
        Subsignal("vrn",     Pins(1)),
        Subsignal("vrp",     Pins(1)),
    ),
    ("ps7_sdio0_cd", 0,
        Subsignal("cdn",    Pins("L22"), IOStandard("LVCMOS33")),
    ),
]

# Platform -----------------------------------------------------------------------------------------

class Platform(XilinxPlatform):
    default_clk_name   = "clk128"
    default_clk_period = 1e9/125e6

    def __init__(self):
        XilinxPlatform.__init__(self, "xc7z020-clg484-1", _io, toolchain="vivado")
        self.add_extension(_ps7_io)

    def create_programmer(self):
        return VivadoProgrammer()

    def do_finalize(self, fragment):
        XilinxPlatform.do_finalize(self, fragment)
        self.add_period_constraint(self.lookup_request("clk125", loose=True), 1e9/125e6)
