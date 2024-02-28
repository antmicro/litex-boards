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

    ("serial", 0,
        Subsignal("tx", Pins("E26")),
        Subsignal("rx", Pins("F25")),
        IOStandard("LVCMOS33")
    ),

    # _IN  <=> FPGA -> MEM
    # _OUT <=> MEM -> FPGA
    ("lpddr5", 0,
        Subsignal("A_ck_p",    Pins("AB11"),                IOStandard("DIFF_SSTL12")),
        Subsignal("A_ck_n",    Pins("AC11"),                IOStandard("DIFF_SSTL12")),
        Subsignal("B_ck_p",    Pins("AA10"),                IOStandard("DIFF_SSTL12")),
        Subsignal("B_ck_n",    Pins("AB10"),                IOStandard("DIFF_SSTL12")),
        Subsignal("A_wck_p",   Pins("Y15 W18"),             IOStandard("DIFF_SSTL12")),
        Subsignal("A_wck_n",   Pins("Y16 W19"),             IOStandard("DIFF_SSTL12")),
        Subsignal("B_wck_p",   Pins("W6 AA5"),              IOStandard("DIFF_SSTL12")),
        Subsignal("B_wck_n",   Pins("W5 AB5"),              IOStandard("DIFF_SSTL12")),
        Subsignal("reset_n",   Pins("AF9"),                 IOStandard("SSTL12")),
        Subsignal("A_cs",      Pins("AA12 AB12"),           IOStandard("SSTL12")),
        Subsignal("B_cs",      Pins("Y8 AF10"),             IOStandard("SSTL12")),
        Subsignal("A_ca",      Pins("AD11 AC12 AD10 AC13",
                                    "AC9 AA9 AB9"),         IOStandard("SSTL12")),
        Subsignal("B_ca",      Pins("V7 Y7 V8 V9",
                                    "Y10 Y11 W9"),          IOStandard("SSTL12")),
        Subsignal("A_rdqs_p",  Pins("AE18 AD20"),           IOStandard("DIFF_SSTL12")),
        Subsignal("A_rdqs_n",  Pins("AF18 AE20"),           IOStandard("DIFF_SSTL12")),
        Subsignal("B_rdqs_p",  Pins("AB1 AF5"),             IOStandard("DIFF_SSTL12")),
        Subsignal("B_rdqs_n",  Pins("AC1 AF4"),             IOStandard("DIFF_SSTL12")),
        Subsignal("A_dq_in",   Pins("AB15 AC14 AB14 AD14",
                                    "AA17 AA18 AB16 AC16",
                                    "V14  V17  V16  V18",
                                    "Y17  W14  W16  W15"),  IOStandard("SSTL12")),
        Subsignal("A_dq_out",  Pins("AF14 AE15 AF15 AD15",
                                    "AD16 AF20 AF19 AE17",
                                    "AA19 AB19 AB17 AA20",
                                    "AC17 AD18 AD19 AC18"), IOStandard("SSTL12")),
        Subsignal("B_dq_in",   Pins("U7  U5  V6  U6",
                                    "W3  U2  V4  V3",
                                    "AB6 Y5  Y6  AC6",
                                    "AB4 AA4 AC4 AC3"),     IOStandard("SSTL12")),
        Subsignal("B_dq_out",  Pins("V2  Y2  V1  W1",
                                    "AA2 AB2 Y3  AC2",
                                    "AE5 AF3 AD4 AE6",
                                    "AE1 AD1 AE2 AF2"),     IOStandard("SSTL12")),
        Subsignal("A_dmi_in",  Pins("AA15 V19"),            IOStandard("SSTL12")),
        Subsignal("A_dmi_out", Pins("AF17 AC19"),           IOStandard("SSTL12")),
        Subsignal("B_dmi_in",  Pins("U1 AD5"),              IOStandard("SSTL12")),
        Subsignal("B_dmi_out", Pins("Y1 AE3"),              IOStandard("SSTL12")),
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
       Subsignal("rst_n", Pins("E21"), IOStandard("LVCMOS33")),
       Subsignal("clk_p", Pins("D6")),
       Subsignal("clk_n", Pins("D5")),
       Subsignal("rx_p",  Pins("G4")),
       Subsignal("rx_n",  Pins("G3")),
       Subsignal("tx_p",  Pins("F2")),
       Subsignal("tx_n",  Pins("F1"))
   ),
   ("pcie_x2", 0,
       Subsignal("rst_n", Pins("E21"), IOStandard("LVCMOS33")),
       Subsignal("clk_p", Pins("D6")),
       Subsignal("clk_n", Pins("D5")),
       Subsignal("rx_p",  Pins("G4 E4")),
       Subsignal("rx_n",  Pins("G3 E3")),
       Subsignal("tx_p",  Pins("F2 D2")),
       Subsignal("tx_n",  Pins("F1 D1"))
   ),
   ("pcie_x4", 0,
       Subsignal("rst_n", Pins("E21"), IOStandard("LVCMOS33")),
       Subsignal("clk_p", Pins("D6")),
       Subsignal("clk_n", Pins("D5")),
       Subsignal("rx_p",  Pins("G4 E4 C4 B6")),
       Subsignal("rx_n",  Pins("G3 E3 C3 B5")),
       Subsignal("tx_p",  Pins("F2 D2 B2 A4")),
       Subsignal("tx_n",  Pins("F1 D1 B1 A3"))
   ),
]

# Platform -----------------------------------------------------------------------------------------

class Platform(Xilinx7SeriesPlatform):
    default_clk_name   = "clk100"
    default_clk_period = 1e9/100e6

    def __init__(self, device="xc7k160tffg676-3", toolchain="vivado"):
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
