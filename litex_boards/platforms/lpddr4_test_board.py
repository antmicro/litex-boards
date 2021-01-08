from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform
from litex.build.openocd import OpenOCD

# IOs ----------------------------------------------------------------------------------------------

_io = [
    # ("clk100", 0, Pins("E21"), IOStandard("LVCMOS33")),
    ("clk100", 0, Pins("L19"), IOStandard("LVCMOS33")),

    ("user_led", 0, Pins("F8"),  IOStandard("LVCMOS33")),
    ("user_led", 1, Pins("C8"),  IOStandard("LVCMOS33")),
    ("user_led", 2, Pins("A8"),  IOStandard("LVCMOS33")),
    ("user_led", 3, Pins("D9"), IOStandard("LVCMOS33")),
    ("user_led", 4, Pins("F9"), IOStandard("LVCMOS33")),

    ("user_btn", 0, Pins("E8"), IOStandard("LVCMOS33")),
    ("user_btn", 1, Pins("B9"), IOStandard("LVCMOS33")),
    ("user_btn", 2, Pins("C9"), IOStandard("LVCMOS33")),
    ("user_btn", 3, Pins("E9"), IOStandard("LVCMOS33")),

    ("serial", 0,
        Subsignal("tx", Pins("AB18")),
        Subsignal("rx", Pins("AA18")),
        IOStandard("LVCMOS33")
    ),
    ("serial", 1,
        Subsignal("tx", Pins("AA20")),
        Subsignal("rx", Pins("AB20")),
        IOStandard("LVCMOS33")
    ),

    # LPDDR4 (actually at 1.1V not 1.2V)
    ("lpddr4", 0,
        Subsignal("clk_p", Pins("Y3"), IOStandard("DIFF_SSTL12")),
        Subsignal("clk_n", Pins("Y2"), IOStandard("DIFF_SSTL12")),
        Subsignal("cke",   Pins("N4"), IOStandard("SSTL12")),
        Subsignal("odt",   Pins(""), IOStandard("SSTL12")),
        Subsignal("reset_n", Pins(""), IOStandard("SSTL12")),
        Subsignal("cs",  Pins("N3"), IOStandard("SSTL12")),
        Subsignal("ca", Pins(
            "L3 L4 AA4 AA3 AB3 AB2"),
            IOStandard("SSTL12")),
        Subsignal("dq", Pins(
            "L1 K2  K1  K3 R1 P2 P1 N2",
            "W2 Y1 AA1 AB1 R2 T1 T3 U1"),
            IOStandard("SSTL12"),
            Misc("IN_TERM=UNTUNED_SPLIT_40")),
        Subsignal("dqs_p", Pins("M2 U2"),
            IOStandard("DIFF_SSTL12"),
            Misc("IN_TERM=UNTUNED_SPLIT_40")),
        Subsignal("dqs_n", Pins("M1 V2"),
            IOStandard("DIFF_SSTL12"),
            Misc("IN_TERM=UNTUNED_SPLIT_40")),
        Subsignal("dmi", Pins("M3 W1"), IOStandard("SSTL12")),
        Misc("SLEW=FAST"),
    ),

    # Ethernet
    ("eth_ref_clk", 0, Pins("C12"), IOStandard("LVCMOS33")),
    ("eth_clocks", 0,
        # Subsignal("tx", Pins("B18")),
        # Subsignal("rx", Pins("B12")),
        Subsignal("tx", Pins("E17")),
        Subsignal("rx", Pins("C17")),
        IOStandard("LVCMOS33"),
    ),
    ("eth", 0,
        Subsignal("rst_n",   Pins("C15")),
        Subsignal("mdio",    Pins("C13")),
        Subsignal("mdc",     Pins("C14")),
        Subsignal("rx_dv",   Pins("B13")),
        Subsignal("rx_er",   Pins("A14")),
        Subsignal("rx_data", Pins("A15 B16 A16 B17")),
        Subsignal("tx_en",   Pins("A18")),
        Subsignal("tx_data", Pins("A19 B20 A20 B21")),
        Subsignal("col",     Pins("B15")),
        Subsignal("crs",     Pins("A13")),
        IOStandard("LVCMOS33"),
    ),

    # HyperRAM
    ("hyperram", 0,
        Subsignal("clk",   Pins("AB15")),  # clk_n AB16
        Subsignal("rst_n", Pins("V17")),
        Subsignal("dq",    Pins("W15 AA15 AA14 W14 Y14 V15 Y16 W17")),
        Subsignal("cs_n",  Pins("AA16")),
        Subsignal("rwds",  Pins("Y17")),
        IOStandard("LVCMOS33")
    ),

]

# Platform -----------------------------------------------------------------------------------------

class Platform(XilinxPlatform):
    default_clk_name   = "clk100"
    default_clk_period = 1e9/100e6

    def __init__(self, device="xc7k70tfbg484-1"):
        XilinxPlatform.__init__(self, device, _io, toolchain="vivado")
        self.toolchain.bitstream_commands = \
            ["set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]"]
        self.toolchain.additional_commands = \
            ["write_cfgmem -force -format bin -interface spix4 -size 16 "
             "-loadbit \"up 0x0 {build_name}.bit\" -file {build_name}.bin"]
        self.add_platform_command("set_property INTERNAL_VREF 0.6 [get_iobanks 34]")  # TODO: external verf?

    def create_programmer(self):
        raise NotImplementedError()

    def do_finalize(self, fragment):
        XilinxPlatform.do_finalize(self, fragment)
        self.add_period_constraint(self.lookup_request("clk100", loose=True), 1e9/100e6)

