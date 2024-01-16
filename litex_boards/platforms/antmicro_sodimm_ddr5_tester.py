#
# This file is part of LiteX-Boards.
#
# Copyright (c) 2024 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: BSD-2-Clause

from litex.build.generic_platform import *
from litex.build.xilinx import Xilinx7SeriesPlatform
from litex.build.openocd import OpenOCD

# IOs ----------------------------------------------------------------------------------------------

_io = [
    ("clk100", 0, Pins("C12"), IOStandard("LVCMOS33")),

    ("user_led", 0, Pins("D21"), IOStandard("LVCMOS33")),
    ("user_led", 1, Pins("B20"), IOStandard("LVCMOS33")),
    ("user_led", 2, Pins("B21"), IOStandard("LVCMOS33")),
    ("user_led", 3, Pins("C22"), IOStandard("LVCMOS33")),
    ("user_led", 4, Pins("E22"), IOStandard("LVCMOS33")),

    ("user_btn", 0, Pins("C21"), IOStandard("LVCMOS33")),
    ("user_btn", 1, Pins("A20"), IOStandard("LVCMOS33")),
    ("user_btn", 2, Pins("E21"), IOStandard("LVCMOS33")),
    ("user_btn", 3, Pins("D23"), IOStandard("LVCMOS33")),

    ("serial", 0,
        Subsignal("tx", Pins("E26")),
        Subsignal("rx", Pins("F25")),
        IOStandard("LVCMOS33")
    ),

    ("lpddr5", 0,
        Subsignal("ck_n", Pins("Y2"), IOStandard("DIFF_SSTL12")),
        Subsignal("ck_p", Pins("Y3"), IOStandard("DIFF_SSTL12")),
        Subsignal("wck_n", Pins("V2 AB1"), IOStandard("DIFF_SSTL12")),
        Subsignal("wck_p", Pins("U2 AA1"), IOStandard("DIFF_SSTL12")),
        Subsignal("reset_n", Pins("AB3"), IOStandard("SSTL12")),
        Subsignal("cs", Pins("V4 U3"), IOStandard("SSTL12")),
        Subsignal("ca", Pins("T4 U5 W1 V3 W2 Y1 W4"), IOStandard("SSTL12")),
        Subsignal("dq_in", Pins("K3 K2 K1 L1 N2 N5 N3 M3"), IOStandard("SSTL12")),
        Subsignal("dq_out", Pins("P1 R1 P2 R2 T3 U1 P4 T1"), IOStandard("SSTL12")),
        Subsignal("rdqs_n", Pins("M1 N4"), IOStandard("DIFF_SSTL12")),
        Subsignal("rdqs_p", Pins("M2 M5"), IOStandard("DIFF_SSTL12")),
        Subsignal("dmi_in", Pins("L3 AA3"), IOStandard("SSTL12")),
        Subsignal("dmi_out", Pins("L5 AA4"), IOStandard("SSTL12")),
    ),

    ("spiflash4x", 0,  # clock needs to be accessed through STARTUPE2
        Subsignal("cs_n", Pins("C23")),
        Subsignal("dq",   Pins("B24", "A25", "B22", "A22")),
        IOStandard("LVCMOS33")
    ),

    # RGMII Ethernet
    ("eth_ref_clk", 0, Pins("AA23"), IOStandard("LVCMOS33")),
    ("eth_clocks", 0,
        Subsignal("rx", Pins("Y23")),
        Subsignal("tx", Pins("AA24")),
        IOStandard("LVCMOS33")
    ),
    ("eth", 0,
        Subsignal("rst_n",   Pins("AA22")),
        Subsignal("mdio",    Pins("AB26")),
        Subsignal("mdc",     Pins("AA25")),
        Subsignal("rx_ctl",  Pins("Y25")),
        Subsignal("rx_data", Pins("W26 W25 V26 U25")),
        Subsignal("tx_ctl",  Pins("U26")),
        Subsignal("tx_data", Pins("W24 Y26 Y22 Y21")),
        IOStandard("LVCMOS33")
    ),

    # HyperRAM
    ("hyperram", 0,
        Subsignal("clk", Pins("AD26")), # clk_n AE26
        Subsignal("rst_n", Pins("AC24")),
        Subsignal("cs_n",  Pins("AC26")),
        Subsignal("dq",    Pins("AE23 AD25 AF24 AE22 AF23 AF25 AE25 AD24")),
        Subsignal("rwds",  Pins("AD23")),
        IOStandard("LVCMOS33")
    ),

    # SD Card
    ("sdcard", 0,
        Subsignal("data", Pins("E10 F8 C9 D9"), Misc("PULLUP True")),
        Subsignal("cmd",  Pins("D8"), Misc("PULLUP True")),
        Subsignal("clk",  Pins("D10")),
        Subsignal("cd",   Pins("F9")),
        Misc("SLEW=FAST"),
        IOStandard("LVCMOS33"),
    ),

    # I2C
    ("i2c", 0,
        Subsignal("scl", Pins("E25")),
        Subsignal("sda", Pins("D26")),
        IOStandard("LVCMOS33"),
    ),

    # HDMI Out
    ("hdmi_out", 0,
        Subsignal("clk_p",   Pins("B15"),  IOStandard("TMDS_33")),
        Subsignal("clk_n",   Pins("A15"),  IOStandard("TMDS_33")),
        Subsignal("data0_p", Pins("B14"),  IOStandard("TMDS_33")),
        Subsignal("data0_n", Pins("A14"),  IOStandard("TMDS_33")),
        Subsignal("data1_p", Pins("A13"),  IOStandard("TMDS_33")),
        Subsignal("data1_n", Pins("A12"),  IOStandard("TMDS_33")),
        Subsignal("data2_p", Pins("B10"),  IOStandard("TMDS_33")),
        Subsignal("data2_n", Pins("A10"),  IOStandard("TMDS_33")),
    ),

    # PCIe
    ("pcie_x1", 0,
        Subsignal("rst_n", Pins("E18"), IOStandard("LVCMOS33")),
        Subsignal("clk_p", Pins("F10")),
        Subsignal("clk_n", Pins("E10")),
        Subsignal("rx_p",  Pins("D11")),
        Subsignal("rx_n",  Pins("C11")),
        Subsignal("tx_p",  Pins("D5")),
        Subsignal("tx_n",  Pins("C5"))
    ),
    ("pcie_x2", 0,
        Subsignal("rst_n", Pins("E18"), IOStandard("LVCMOS33")),
        Subsignal("clk_p", Pins("F10")),
        Subsignal("clk_n", Pins("E10")),
        Subsignal("rx_p",  Pins("D11 B10")),
        Subsignal("rx_n",  Pins("C11 A10")),
        Subsignal("tx_p",  Pins("D5 B6")),
        Subsignal("tx_n",  Pins("C5 A6"))
    ),
    ("pcie_x4", 0,
        Subsignal("rst_n", Pins("E18"), IOStandard("LVCMOS33")),
        Subsignal("clk_p", Pins("F10")),
        Subsignal("clk_n", Pins("E10")),
        Subsignal("rx_p",  Pins("D11 B10 D9 B8")),
        Subsignal("rx_n",  Pins("C11 A10 C9 A8")),
        Subsignal("tx_p",  Pins("D5 B6 D7 B4")),
        Subsignal("tx_n",  Pins("C5 A6 C7 A4"))
    ),

]

# Platform -----------------------------------------------------------------------------------------

class Platform(Xilinx7SeriesPlatform):
    default_clk_name   = "clk100"
    default_clk_period = 1e9/100e6

    def __init__(self, device="xc7k70tfbg484-3", toolchain="vivado"):
        Xilinx7SeriesPlatform.__init__(self, device, _io, toolchain=toolchain)
        self.toolchain.bitstream_commands = \
            ["set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]"]
        self.toolchain.additional_commands = \
            ["write_cfgmem -force -format bin -interface spix4 -size 16 "
             "-loadbit \"up 0x0 {build_name}.bit\" -file {build_name}.bin"]

    def create_programmer(self):
        bscan_spi = "bscan_spi_xc7k160t.bit" if "xc7k160t" in self.device else "bscan_spi_xc7k160t.bit"
        return OpenOCD("openocd_xc7_ft4232.cfg", bscan_spi)

    def do_finalize(self, fragment):
        Xilinx7SeriesPlatform.do_finalize(self, fragment)
        self.add_period_constraint(self.lookup_request("clk100", loose=True), 1e9/100e6)
