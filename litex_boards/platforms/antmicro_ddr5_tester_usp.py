#
# This file is part of LiteX-Boards.
#
# Copyright (c) 2022 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: BSD-2-Clause

from litex.build.generic_platform import *
from litex.build.xilinx import XilinxUSPPlatform
from litex.build.openocd import OpenOCD

# IOs ----------------------------------------------------------------------------------------------

_io = [
    # Clocking
    ("clk100", 0
        Subsignal("p", Pins("B19")),
        Subsignal("n", Pins("B20")),
        IOStandard("LVDS")
    ),

    # User LEDs
    ("user_led", 0, Pins("K10"), IOStandard("LVCMOS33")),
    ("user_led", 1, Pins("K9"),  IOStandard("LVCMOS33")),
    ("user_led", 2, Pins("J11"), IOStandard("LVCMOS33")),
    ("user_led", 3, Pins("J10"), IOStandard("LVCMOS33")),
    ("user_led", 4, Pins("J9"),  IOStandard("LVCMOS33")),

    # UARTs
    ("serial", 0,
        Subsignal("tx", Pins("G9")),
        Subsignal("rx", Pins("G10")),
        IOStandard("LVCMOS33")
    ),

    ("serial", 1,
        Subsignal("tx", Pins("F10")),
        Subsignal("rx", Pins("F9")),
        IOStandard("LVCMOS33")
    ),

    # SPI flash
    ("spiflash4x", 0,
        Subsignal("cs_n", Pins("AA12")),
        Subsignal("clk",  Pins("Y11")), #TODO: Maybe only accessible via STARTUPE3, verify
        Subsignal("dq",   Pins("AD11", "AC12", "AC11", "AE11")),
        IOStandard("LVCMOS18")
    )

    # RGMII Ethernet
    ("eth_ref_clk", 0, Pins("B24"), IOStandard("LVCMOS18")),
    ("eth_clocks", 0,
        Subsignal("rx", Pins("B21")),
        Subsignal("tx", Pins("E21")),
        IOStandard("LVCMOS18")
    ),
    ("eth", 0,
        Subsignal("rst_n",   Pins("C23")),
        Subsignal("mdio",    Pins("A24")),
        Subsignal("mdc",     Pins("C22")),
        Subsignal("rx_ctl",  Pins("C21")),
        Subsignal("rx_data", Pins("A19", "B17", "C17", "A15")),
        Subsignal("tx_ctl",  Pins("D21")),
        Subsignal("tx_data", Pins("B15", "A18", "A20", "A17")),
        IOStandard("LVCMOS18")
    ),

    # HyperRAM
    ("hyperram", 0,
        Subsignal("clk",   Pins("E16")), # clk_n E17
        Subsignal("rst_n", Pins("F15")),
        Subsignal("cs_n",  Pins("H18")),
        Subsignal("dq",    Pins("H16 C16 E15 D15 G16 H17 D16 G17")),
        Subsignal("rwds",  Pins("G15")),
        IOStandard("LVCMOS18")
    ),

    # SD Card
    ("sdcard", 0,
        Subsignal("data", Pins("G20 G21 F19 F20"), Misc("PULLUP True")),
        Subsignal("cmd",  Pins("H19"), Misc("PULLUP True")),
        Subsignal("clk",  Pins("F18")),
        Subsignal("cd",   Pins("E20")),
        Subsignal("vsel", Pins("D14"), IOStandard("LVCMOS33"), Misc("PULLUP True")), # SD card voltage selection
        Misc("SLEW=FAST"),
        IOStandard("LVCMOS18"),
    ),

    # I2C
    ("i2c", 0
        Subsignal("sda", Pins("W14"), IOStandard("LVCMOS33")),
        Subsignal("scl", Pins("W15"), IOStandard("LVCMOS33")),
        IOStandard("LVCMOS33")
    ),

    ("i2c_platform", 0
        Subsignal("sda", Pins("W12"), IOStandard("LVCMOS33")),
        Subsignal("scl", Pins("W13"), IOStandard("LVCMOS33")),
        IOStandard("LVCMOS33")
    ),

    # Misc
    ("hot_swap_yellow", 0, Pins("AF14"), IOStandard("LVCMOS33")),
    ("hot_swap_red",    0, Pins("AF15"), IOStandard("LVCMOS33")),
    ("hot_swap_green",  0, Pins("AE13"), IOStandard("LVCMOS33")),
    ("hot_swap_button", 0, Pins("AF13"), IOStandard("LVCMOS33")),

    ("fpga_power_cycle", 0, Pins("AA15"), IOStandard("LVCMOS33")),
    ("fpga_power_off",   0, Pins("Y15"),  IOStandard("LVCMOS33")),
    ("fan_pwm",          0, Pins("AA14"), IOStandard("LVCMOS33")),

    ("ddr_presence_n", 0,   Pins("AD13"), IOStandard("LVCMOS33"),),

    ("si5319_ctl", 0,
        Subsignal("int_cb", Pins("A12")),
        Subsignal("lol",    Pins("B14")),
        Subsignal("rst_n",  Pins("B14")),
        IOSta
    )

    # TODO: Add PCIe
    # TODO: Add HDMI
    # TODO: Add DDR
    # TODO: Add AUX_JTAG
    # TODO: Add I3C
]

class Platform(XilinxUSPPlatform):
    default_clk_name = "clk100"
    default_clk_period = 1e9/100e6

    def __init__(self, device="xcau25p-", toolchain="vivado"):
        XilinxUSPPlatform.__init__(self, device, _io, toolchain=toolchain)
        self.toolchain.bitstream_commands = \
            ["set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]"]
        self.toolchain.additional_commands = \
            ["write_cfgmem -force -format bin -interface spix4 -size 16 "
             "-loadbit \"up 0x0 {build_name}.bit\" -file {build_name}.bin"]

    def create_programmer(self):
        pass #TODO:

    def do_finalize(self, fragment):
        XilinxUSPPlatform.do_finalize(self, fragment)
        self.add_period_constraint(self.lookup_request("clk100", loose=True), 1e9/100e6)

