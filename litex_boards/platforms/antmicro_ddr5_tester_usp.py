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
    ("clk100", 0,
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
    ),

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
    ("i2c", 0,
        Subsignal("sda", Pins("W14"), IOStandard("LVCMOS33")),
        Subsignal("scl", Pins("W15"), IOStandard("LVCMOS33")),
        IOStandard("LVCMOS33")
    ),

    ("i2c_platform", 0,
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

    ("ddr_presence_n", 0,   Pins("AD13"), IOStandard("LVCMOS33")),
    ("vin_bulk_en", 0, Pins("AD15"), IOStandard("LVCMOS33")),
    ("vin_mgmt_en", 0, Pins("AD14"), IOStandard("LVCMOS33")),

    # PCIe
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
        Subsignal("rst", Pins("D10")),
        Subsignal("tms", Pins("D9")),
        Subsignal("tck", Pins("C9")),
        Subsignal("tdi", Pins("B9")),
        Subsignal("tdo", Pins("A9")),
        IOStandard("LVCMOS33")
    ),

    # DDR
    ("ddr5", 0,
        Subsignal(
            "ck_t",
            Pins("W25"),
            IOStandard("DIFF_POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "ck_c",
            Pins("W26"),
            IOStandard("DIFF_POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "A_ca",
            Pins("W23 V23 AA24 AA25 Y25 Y26 V24"),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "B_ca",
            Pins("U25 T25 R25 P26 P25 P24 N24"),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "A_cs_n",
            Pins("Y22 Y23"),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "B_cs_n",
            Pins("T24 U24"),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "A_par",
            Pins("W24"),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "B_par",
            Pins("R26"),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal("alert_n", Pins("AA23"), IOStandard("POD12_DCI")),
        Subsignal(
            "reset_n",
            Pins("T19"),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        #Subsignal("pgood",   Pins("N26"), IOStandard("POD12_DCI")), Unused at this point
        Subsignal("A_dq",
            Pins(
                "AA19 AA20 AB19 AB20 AA18 Y18  AA17 Y17",
                "AF18 AF19 AC19 AD19 AE16 AD16 AF17 AE17",
                "AD23 AE23 AC22 AC23 AD21 AE21 AB21 AC21",
                "AB25 AF24 AB26 AF25 AD24 AC24 AD25 AB24"
            ),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "A_dqs_t",
            Pins("Y20  AB17 AD20 AC18 AE22 AA22 AE25 AC26"),
            IOStandard("DIFF_POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "A_dqs_c",
            Pins("Y21  AC17 AE20 AD18 AF22 AB22 AE26 AD26"),
            IOStandard("DIFF_POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        # Unused at this point
        #Subsignal("A_cb",   Pins("U22 U21 T20 U20 T23 W20 T22 W19"), IOStandard("POD12_DCI")),
        #Subsignal("A_dqsb_t", Pins("U19 V21"), IOStandard("DIFF_POD12_DCI")),
        #Subsignal("A_dqsb_c", Pins("V19 V22"), IOStandard("DIFF_POD12_DCI")),
        Subsignal("B_dq",
            Pins(
                "M21 M20 J19 J20 K21 K20 L20 J21",
                "M26 M25 K26 K25 J24 K23 J23 K22",
                "H23 J25 H24 J26 G26 H22 H26 H21",
                "F23 D24 E23 D25 B26 B25 C26 D26"
            ),
            IOStandard("POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "B_dqs_t",
            Pins("L18 M19 L22 L24 G24 F24 E25 D23"),
            IOStandard("DIFF_POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        Subsignal(
            "B_dqs_c",
            Pins("K18 L19 L23 L25 G25 F25 E26 C24"),
            IOStandard("DIFF_POD12_DCI"),
            Misc("PRE_EMPHASIS=RDRV_240"),
            Misc("OUTPUT_IMPEDANCE=RDRV_40_40"),
        ),
        # Unused atthis point
        # Subsignal("B_cb",   Pins("P19 N21 N22 N19 P20 R21 R20 P21"), IOStandard("POD12_DCI")),
        # Subsignal("B_dqsb_t", Pins("N23 R22"), IOStandard("DIFF_POD12_DCI")),
        # Subsignal("B_dqsb_c", Pins("P23 R23"), IOStandard("DIFF_POD12_DCI")),
        # Subsignal("dlbdq",  Pins("U26"), IOStandard("POD12_DCI")),
        # Subsignal("dlbdqs", Pins("V26"), IOStandard("POD12_DCI")),
        Misc("SLEW=FAST"),
    )
    # TODO: Add I3C
]

# TODO: Fill other IOs
# Must be consistent with _io
# Each tuple has following format: bank #, byte #, nibble(1 - upper, 0 - lower), bitslice
_io_bank = dict(
    ddr5=dict(
        ck_t    = [(65, 1, 1, 0)],
        ck_c    = [(65, 1, 1, 1)],
        A_ca    = [(65, 1, nibble, bitslice) for nibble, bitslice in [
            (1, 3), (1, 2), (0, 4), (0, 5), (0, 2), (0, 3), (1, 4)]],
        B_ca    = [(65, 2, nibble, bitslice) for nibble, bitslice in [
            (0, 3), (1, 4), (0, 2), (1, 3), (1, 2), (0, 5), (0, 4)]],
        A_cs_n  = [(65, 1, nibble, bitslice) for nibble, bitslice in [(0, 0), (0, 1)]],
        B_cs_n  = [(65, 2, nibble, bitslice) for nibble, bitslice in [(0, 0), (0, 1)]],
        A_par   = [(65, 1, 1, 5)],
        B_par   = [(65, 2, 1, 5)],
        alert_n = [(65, 1, 1, 6)],
        reset_n = [(65, 3, 1, 6)],
        A_dq    = [(64, byte, nibble, bitslice) for byte, nibble, bitslice in [
            (3, 0, 2), (3, 0, 4), (3, 0, 3), (3, 0, 5), (3, 1, 5), (3, 1, 4), (3, 1, 3), (3, 1, 2),
            (2, 0, 4), (2, 0, 5), (2, 0, 2), (2, 0, 3), (2, 1, 5), (2, 1, 4), (2, 1, 3), (2, 1, 2),
            (1, 0, 2), (1, 0, 3), (1, 0, 4), (1, 0, 5), (1, 1, 2), (1, 1, 3), (1, 1, 4), (1, 1, 5),
            (0, 0, 2), (0, 0, 4), (0, 0, 3), (0, 0, 5), (0, 1, 2), (0, 1, 5), (0, 1, 3), (0, 1, 4)]],
        B_dq    = [(66, byte, nibble, bitslice) for byte, nibble, bitslice in [
            (0, 0, 3), (0, 0, 2), (0, 0, 4), (0, 0, 5), (0, 1, 2), (0, 1, 5), (0, 1, 4), (0, 1, 3),
            (1, 0, 3), (1, 0, 2), (1, 0, 5), (1, 0, 4), (1, 1, 5), (1, 1, 3), (1, 1, 4), (1, 1, 2),
            (2, 0, 2), (2, 0, 4), (2, 0, 3), (2, 0, 5), (2, 1, 3), (2, 1, 5), (2, 1, 2), (2, 1, 4),
            (3, 0, 2), (3, 0, 4), (3, 0, 3), (3, 0, 5), (3, 1, 5), (3, 1, 4), (3, 1, 3), (3, 1, 2)]],
        A_dqs_t = [(64, byte, nibble, bitslice) for byte, nibble, bitslice in [
            (3, 0, 0), (3, 1, 0), (2, 0, 0), (2, 1, 0), (1, 0, 0), (1, 1, 0), (0, 0, 0), (0, 1, 0)]],
        A_dqs_c = [(64, byte, nibble, bitslice) for byte, nibble, bitslice in [
            (3, 0, 1), (3, 1, 1), (2, 0, 1), (2, 1, 1), (1, 0, 1), (1, 1, 1), (0, 0, 1), (0, 1, 1)]],
        B_dqs_t = [(66, byte, nibble, bitslice) for byte, nibble, bitslice in [
            (0, 0, 0), (0, 1, 0), (1, 0, 0), (1, 1, 0), (2, 0, 0), (2, 1, 0), (3, 0, 0), (3, 1, 0)]],
        B_dqs_c = [(66, byte, nibble, bitslice) for byte, nibble, bitslice in [
            (0, 0, 1), (0, 1, 1), (1, 0, 1), (1, 1, 1), (2, 0, 1), (2, 1, 1), (3, 0, 1), (3, 1, 1)]],
        A_cb    = [(65, 0, nibble, bitslice) for nibble, bitslice in [
            (0, 3), (0, 2), (0, 4), (0, 5), (1, 3), (1, 5), (1, 2), (1, 4)]],
        B_cb    = [(65, 3, nibble, bitslice) for nibble, bitslice in [
            (1, 3), (1, 4), (1, 5), (1, 2), (0, 2), (0, 5), (0, 4), (0, 3)]],
        A_dqsb_t = [(65, 0, nibble, bitslice) for nibble, bitslice in [(0, 0), (1, 0)]],
        A_dqsb_c = [(65, 0, nibble, bitslice) for nibble, bitslice in [(0, 1), (1, 1)]],
        B_dqsb_t = [(65, 3, nibble, bitslice) for nibble, bitslice in [(1, 0), (0, 0)]],
        B_dqsb_c = [(65, 3, nibble, bitslice) for nibble, bitslice in [(1, 1), (0, 1)]],
    ),
)

class Platform(XilinxUSPPlatform):
    default_clk_name = "clk100"
    default_clk_period = 1e9/100e6

    def __init__(self, device="xcau25p-ffvb676-2-i", toolchain="vivado"):
        XilinxUSPPlatform.__init__(self, device, _io, toolchain=toolchain)
        self.toolchain.bitstream_commands = \
            ["set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]"]
        self.toolchain.additional_commands = \
            ["write_cfgmem -force -format bin -interface spix4 -size 16 "
             "-loadbit \"up 0x0 {build_name}.bit\" -file {build_name}.bin"]
        self.add_platform_command("set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets IBUF/O]") # Needed since RXC for ETH is not GC
        self.add_platform_command("set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports eth_tx_data[3]]")

    def pin_bank_byte_nibble_bitslice_mapping(self):
        return _io_bank

    def create_programmer(self):
        pass #TODO:

    def do_finalize(self, fragment):
        XilinxUSPPlatform.do_finalize(self, fragment)
        self.add_period_constraint(self.lookup_request("clk100", loose=True), 1e9/100e6)
        self.add_period_constraint(self.lookup_request("eth_clocks_rx", loose=True), 1e9/125e6)

