from litex.build.generic_platform import *
from litex.build.lattice import LatticePlatform
from litex.build.lattice.programmer import OpenOCDJTAGProgrammer

# IOs ----------------------------------------------------------------------------------------------

_io = [
    # Clk / Rst
    ("clk100", 0, Pins("C5"), IOStandard("LVCMOS33")),

    # Serial
    ("serial", 0,  # FIXME: this is fake pinout
        Subsignal("rx", Pins("C4"), IOStandard("LVCMOS33")),
        Subsignal("tx", Pins("D5"), IOStandard("LVCMOS33")),
    ),

    # DDR3 SDRAM
    ("ddram", 0,
        Subsignal("a", Pins(
            "W4 V7 U7 AE6 R6 AE4 U6 U5",
            "R7 R4 U4 T6 T5 T4 T7"),
            IOStandard("SSTL135_I")),
        Subsignal("ba",    Pins("AC7 V6 W5"), IOStandard("SSTL135_I")),
        Subsignal("ras_n", Pins("AB3"), IOStandard("SSTL135_I")),
        Subsignal("cas_n", Pins("W2"), IOStandard("SSTL135_I")),
        Subsignal("we_n",  Pins("AC5"), IOStandard("SSTL135_I")),
        Subsignal("cs_n",  Pins("R1"), IOStandard("SSTL135_I")),
        Subsignal("dm", Pins("AD7 AC2"), IOStandard("SSTL135_I")),
        Subsignal("dq", Pins(
            "AC6 AD6  Y4 AE5 AB7  Y5  Y6  Y7",
            "AE3 AE1 AD3 AB1 AB4 AC1 AE2 AD1"),
            IOStandard("SSTL135_I"),
            Misc("TERMINATION=75")),
        # TODO: verfify why trellisboard/ecpix5 have not dqs_n/clk_n, and don't use differential standard
        Subsignal("dqs_p", Pins("AB5 AC3"), IOStandard("SSTL135D_I"),
            Misc("TERMINATION=OFF"),
            Misc("DIFFRESISTOR=100")),
        Subsignal("clk_p", Pins("P5"), IOStandard("SSTL135D_I")),
        Subsignal("cke",   Pins("Y1"), IOStandard("SSTL135_I")),
        Subsignal("odt",   Pins("AD4"), IOStandard("SSTL135_I")),
        Subsignal("reset_n", Pins("T2"), IOStandard("SSTL135_I")),
        Misc("SLEWRATE=FAST"),
    ),

    # RGMII Ethernet
    # TODO: make sure that VCC for U21C on schematic is 3.3V
    ("eth_clocks", 0,
        Subsignal("tx",  Pins("C17")),
        Subsignal("rx",  Pins("A17")),
        Subsignal("ref", Pins("B17")),
        IOStandard("LVCMOS33")
    ),
    ("eth", 0,
        Subsignal("rst_n",   Pins("D18")),
        Subsignal("int_n",   Pins("A19")),
        Subsignal("mdio",    Pins("D17")),
        Subsignal("mdc",     Pins("B16")),
        Subsignal("rx_ctl",  Pins("C16")),
        Subsignal("rx_data", Pins("A16 D16 E16 C8")),
        Subsignal("tx_ctl",  Pins("D15")),
        Subsignal("tx_data", Pins("A14 A8 B8 D8")),
        IOStandard("LVCMOS33")
    ),

    # PCIe
    ("pcie_x1", 0,
        Subsignal("clk_p",  Pins("AM14")),
        Subsignal("clk_n",  Pins("AM15")),
        Subsignal("rx_p",   Pins("AM8")),
        Subsignal("rx_n",   Pins("AM9")),
        Subsignal("tx_p",   Pins("AK9")),
        Subsignal("tx_n",   Pins("AK10")),
        # Subsignal("perst",  Pins("D22"), IOStandard("LVCMOS33")),
        # Subsignal("wake_n", Pins("A23"), IOStandard("LVCMOS33")),
    ),

    # USB ULPI
    ("ulpi_clock", 0, Pins("P28"), IOStandard("LVCMOS33")),
    ("ulpi", 0,
        Subsignal("stp",   Pins("P32")),
        Subsignal("dir",   Pins("P31")),
        Subsignal("nxt",   Pins("N32")),
        Subsignal("reset", Pins("P30")),
        Subsignal("data",  Pins("W31 W32 V32 U31 U32 T31 T32 R32")),
        IOStandard("LVCMOS33")
    ),
    ("ulpi_clock", 1, Pins("N26"), IOStandard("LVCMOS33")),
    ("ulpi", 1,
        Subsignal("stp",   Pins("Y28")),
        Subsignal("dir",   Pins("Y29")),
        Subsignal("nxt",   Pins("Y30")),
        Subsignal("reset", Pins("Y32")),
        Subsignal("data",  Pins("AE32 AE31 AD32 AC31 AC32 AB31 AB32 AB30")),
        IOStandard("LVCMOS33")
    ),
]

# Platform -----------------------------------------------------------------------------------------

class Platform(LatticePlatform):
    default_clk_name   = "clk100"
    default_clk_period = 1e9/100e6

    def __init__(self, toolchain="trellis", **kwargs):
        LatticePlatform.__init__(self, "LFE5UM5G-85F-8BG756C", _io, toolchain=toolchain, **kwargs)

    def create_programmer(self):
        return None#OpenOCDJTAGProgrammer("openocd_trellisboard.cfg")

    def do_finalize(self, fragment):
        LatticePlatform.do_finalize(self, fragment)
        self.add_period_constraint(self.lookup_request("clk100",        loose=True), 1e9/100e6)
        self.add_period_constraint(self.lookup_request("eth_clocks:rx", loose=True), 1e9/125e6)

