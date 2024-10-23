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

    # PCIe
    # TODO: verify lane order
    ("pcie_x1", 0,
       Subsignal("rst_n", Pins("A10"), IOStandard("LVCMOS33")),
       Subsignal("clk_p", Pins("AB7")),
       Subsignal("clk_n", Pins("AB6")),
       Subsignal("rx_p",  Pins("AF2")),
       Subsignal("rx_n",  Pins("AF1")),
       Subsignal("tx_p",  Pins("AF7")),
       Subsignal("tx_n",  Pins("AF6"))
    ),
    ("pcie_x2", 0,
       Subsignal("rst_n", Pins("A10"), IOStandard("LVCMOS33")),
       Subsignal("clk_p", Pins("AB7")),
       Subsignal("clk_n", Pins("AB6")),
       Subsignal("rx_p",  Pins("AF2 AE4")),
       Subsignal("rx_n",  Pins("AF1 AE3")),
       Subsignal("tx_p",  Pins("AF7 AE9")),
       Subsignal("tx_n",  Pins("AF6 AE8"))
    ),
    ("pcie_x4", 0,
       Subsignal("rst_n", Pins("A10"), IOStandard("LVCMOS33")),
       Subsignal("clk_p", Pins("AB7")),
       Subsignal("clk_n", Pins("AB6")),
       Subsignal("rx_p",  Pins("AF2 AE4 AD2 AB2")),
       Subsignal("rx_n",  Pins("AF1 AE3 AD1 AB1")),
       Subsignal("tx_p",  Pins("AF7 AE9 AD7 AC5")),
       Subsignal("tx_n",  Pins("AF6 AE8 AD6 AC4"))
    ),
    ("pcie_x8", 0,
       Subsignal("rst_n", Pins("A10"), IOStandard("LVCMOS33")),
       Subsignal("clk_p", Pins("AB7")),
       Subsignal("clk_n", Pins("AB6")),
       Subsignal("rx_p",  Pins("AF2 AE4 AD2 AB2 Y2 V2 T2 P2")),
       Subsignal("rx_n",  Pins("AF1 AE3 AD1 AB1 Y1 V1 T1 P1")),
       Subsignal("tx_p",  Pins("AF7 AE9 AD7 AC5 AA5 W5 U5 R5")),
       Subsignal("tx_n",  Pins("AF6 AE8 AD6 AC4 AA4 W4 U4 R4"))
    ),

    # HDMI
    ("hdmi_out", 0,
        Subsignal("clk_p",   Pins("G5")),
        Subsignal("clk_n",   Pins("G4")),
        Subsignal("data0_p", Pins("N5")),
        Subsignal("data0_n", Pins("N4")),
        Subsignal("data1_p", Pins("L5")),
        Subsignal("data1_n", Pins("L4")),
        Subsignal("data2_p", Pins("J5")),
        Subsignal("data2_n", Pins("J4")),
        Subsignal("sda",     Pins("J13"), IOStandard("LVCMOS33")),
        Subsignal("scl",     Pins("H13"), IOStandard("LVCMOS33")),
        Subsignal("hpd",     Pins("C13"), IOStandard("LVCMOS33")),
        Subsignal("cd",      Pins("A14"), IOStandard("LVCMOS33")),
        Subsignal("txen",    Pins("C12"), IOStandard("LVCMOS33"))
    ),

    ("hdmi_in", 0,
        Subsignal("clk_p",   Pins("M7")),
        Subsignal("clk_n",   Pins("M6")),
        Subsignal("data0_p", Pins("M1")),
        Subsignal("data0_n", Pins("M2")),
        Subsignal("data1_p", Pins("K1")),
        Subsignal("data1_n", Pins("K1")),
        Subsignal("data2_p", Pins("H1")),
        Subsignal("data2_n", Pins("H2")),
        Subsignal("sda",     Pins("J12"), IOStandard("LVCMOS33")),
        Subsignal("scl",     Pins("H12"), IOStandard("LVCMOS33")),
        Subsignal("hpd",     Pins("B12"), IOStandard("LVCMOS33"))
    ),

    ("si5319_ctl", 0,
        Subsignal("int_cb", Pins("A12")),
        Subsignal("lol",    Pins("B14")),
        Subsignal("rst_n",  Pins("B14")),
        Subsignal("sda",    Pins("H14")),
        Subsignal("scl",    Pins("G14")),
        IOStandard("LVCMOS33")
    ),

    # AUX JTAG
    ("jtag_aux", 0,
        Subsignal("rst" Pins("D10")), 
        Subsignal("tms" Pins("D9")), 
        Subsignal("tck" Pins("C9")), 
        Subsignal("tdi" Pins("B9")), 
        Subsignal("tdo" Pins("A9")), 
        IOStandard("LVCMOS33")
    )


    # TODO: Add DDR
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

