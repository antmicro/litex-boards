#!/usr/bin/env python3

#
# This file is part of LiteX-Boards.
#
# Copyright (c) 2015-2019 Florent Kermarrec <florent@enjoy-digital.fr>
# Copyright (c) 2020-2021 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: BSD-2-Clause

import os
import argparse

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex_boards.platforms import arty
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict

from litex.soc.cores.clock import *
from litex.soc.integration.soc import SoCRegion
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

from litedram.modules import MT41K128M16
from litedram.phy import s7ddrphy

from liteeth.phy.mii import LiteEthPHYMII

from litespi.modules import S25FL128L
from litespi.opcodes import SpiNorFlashOpCodes as Codes
from litespi.phy.generic import LiteSPIPHY
from litespi import LiteSPI

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq, with_mapped_flash):
        self.rst = Signal()
        self.clock_domains.cd_sys       = ClockDomain()
        self.clock_domains.cd_sys2x     = ClockDomain()
        self.clock_domains.cd_sys8x     = ClockDomain(reset_less=True)
        self.clock_domains.cd_sys8x_dqs = ClockDomain(reset_less=True)
        self.clock_domains.cd_idelay    = ClockDomain()
        self.clock_domains.cd_eth       = ClockDomain()

        # # #

        self.submodules.pll = pll = S7PLL(speedgrade=-1)
        self.comb += pll.reset.eq(~platform.request("cpu_reset") | self.rst)
        pll.register_clkin(platform.request("clk100"), 100e6)
        pll.create_clkout(self.cd_sys,       sys_clk_freq)
        pll.create_clkout(self.cd_sys2x,     2*sys_clk_freq, with_reset=False)
        pll.create_clkout(self.cd_sys8x,     8*sys_clk_freq)
        pll.create_clkout(self.cd_sys8x_dqs, 8*sys_clk_freq, phase=90)
        pll.create_clkout(self.cd_idelay,    200e6)
        pll.create_clkout(self.cd_eth,       25e6)
        platform.add_false_path_constraints(self.cd_sys.clk, pll.clkin) # Ignore sys_clk to pll.clkin path created by SoC's rst.

        self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)

        # Make sure sys2x counters are reset syncronized to sys clock
        # HalfRateA7DDRPHY will pass `serdes_reset_cnt=0` to DFIRateConverter
        self.comb += self.cd_sys2x.rst.eq(self.cd_sys.rst)

        self.comb += platform.request("eth_ref_clk").eq(self.cd_eth.clk)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, variant="a7-35", toolchain="vivado", sys_clk_freq=int(100e6), with_ethernet=False, with_etherbone=False, eth_ip="192.168.1.50", eth_dynamic_ip=False, ident_version=True, with_jtagbone=True, with_mapped_flash=False, **kwargs):
        platform = arty.Platform(variant=variant, toolchain=toolchain)

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq,
            ident          = "LiteX SoC on Arty A7",
            ident_version  = ident_version,
            integrated_rom_mode="rw",
            **kwargs)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform, sys_clk_freq, with_mapped_flash)

        # DDR3 SDRAM -------------------------------------------------------------------------------
        if not self.integrated_main_ram_size:
            self.submodules.ddrphy = s7ddrphy.HalfRateA7DDRPHY(platform.request("ddram"),
                memtype        = "DDR3",
                nphases        = 4,
                sys_clk_freq   = sys_clk_freq)
            sdram_module = MT41K128M16(sys_clk_freq, "1:8")
            self.add_sdram("sdram",
                phy           = self.ddrphy,
                module        = sdram_module,
                # l2_cache_size = kwargs.get("l2_size", 8192)
                l2_cache_size = 0
            )

            if False:
                from litescope import LiteScopeAnalyzer
                analyzer_signals = [
                    *[p.cas_n for p in self.ddrphy.dfi.phases],
                    *[p.ras_n for p in self.ddrphy.dfi.phases],
                    *[p.we_n for p in self.ddrphy.dfi.phases],
                    # *[p.wrdata for p in self.ddrphy.dfi.phases],
                    # *[p.wrdata_mask for p in self.ddrphy.dfi.phases],
                    *[p.wrdata_en for p in self.ddrphy.dfi.phases],
                    # *[p.rddata for p in self.ddrphy.dfi.phases],
                    *[p.rddata_en for p in self.ddrphy.dfi.phases],
                    *[p.rddata_valid for p in self.ddrphy.dfi.phases],
                    *[p.cas_n for p in self.ddrphy.phy.dfi.phases],
                    *[p.ras_n for p in self.ddrphy.phy.dfi.phases],
                    *[p.we_n for p in self.ddrphy.phy.dfi.phases],
                    # *[p.wrdata for p in self.ddrphy.phy.dfi.phases],
                    # *[p.wrdata_mask for p in self.ddrphy.phy.dfi.phases],
                    *[p.wrdata_en for p in self.ddrphy.phy.dfi.phases],
                    # *[p.rddata for p in self.ddrphy.phy.dfi.phases],
                    *[p.rddata_en for p in self.ddrphy.phy.dfi.phases],
                    *[p.rddata_valid for p in self.ddrphy.phy.dfi.phases],
                    self.ddrphy.dfi_converter.cmd_cnt,
                    self.ddrphy.dfi_converter.wr_cnt,
                    self.ddrphy.dfi_converter.rd_cnt,
                ]
                self.submodules.analyzer = LiteScopeAnalyzer(analyzer_signals,
                    register     = 1,
                    depth        = 128,
                    clock_domain = "sys2x",
                    csr_csv      = "analyzer.csv")
                print('data_width', end=' = '); __import__('pprint').pprint(self.analyzer.data_width)


            if True:
                def dump(obj):
                    print()
                    print(" " + obj.__class__.__name__)
                    print(" " + "-" * len(obj.__class__.__name__))
                    d = obj if isinstance(obj, dict) else vars(obj)
                    for var, val in d.items():
                        if var == "self":
                            continue
                        if isinstance(val, Signal):
                            val = "Signal(reset={})".format(val.reset.value)
                        print("  {}: {}".format(var, val))

                print("=" * 80)
                dump(sdram_module.geom_settings)
                dump(sdram_module.timing_settings)
                dump(self.ddrphy.phy.settings)
                print("\n   ⬆️⬆️⬆️ OLD | NEW ⬇️")
                dump(self.ddrphy.settings)
                print()
                print("=" * 80)

        # Ethernet / Etherbone ---------------------------------------------------------------------
        if with_ethernet or with_etherbone:
            self.submodules.ethphy = LiteEthPHYMII(
                clock_pads = self.platform.request("eth_clocks"),
                pads       = self.platform.request("eth"))
            if with_ethernet:
                self.add_ethernet(phy=self.ethphy, dynamic_ip=eth_dynamic_ip)
            if with_etherbone:
                self.add_etherbone(phy=self.ethphy, ip_address=eth_ip)

        # Jtagbone ---------------------------------------------------------------------------------
        if with_jtagbone:
            self.add_jtagbone()

        # Flash (through LiteSPI, experimental).
        if with_mapped_flash:
            self.submodules.spiflash_phy  = LiteSPIPHY(platform.request("spiflash4x"), S25FL128L(Codes.READ_1_1_4))
            self.submodules.spiflash_mmap = LiteSPI(self.spiflash_phy, clk_freq=sys_clk_freq, mmap_endianness=self.cpu.endianness)
            spiflash_region = SoCRegion(origin=self.mem_map.get("spiflash", None), size=S25FL128L.total_size, cached=False)
            self.bus.add_slave(name="spiflash", slave=self.spiflash_mmap.bus, region=spiflash_region)

        # Leds -------------------------------------------------------------------------------------
        self.submodules.leds = LedChaser(
            pads         = platform.request_all("user_led"),
            sys_clk_freq = sys_clk_freq)

def generate_gtkw_savefile(builder, vns, trace_fst):
    from litex.build.sim import gtkwave as gtkw

    soc = builder.soc
    wrphase = soc.sdram.controller.settings.phy.wrphase.reset.value

    with gtkw.GTKWSave(vns, savefile="dump.gtkw", dumpfile="dump.vcd", prefix="") as save:
        for name, dfi in {"dfi new": soc.ddrphy.dfi, "dfi old": soc.ddrphy.phy.dfi}.items():
            with save.gtkw.group(name):
                # all dfi signals
                save.add(dfi, mappers=[gtkw.dfi_sorter(), gtkw.dfi_in_phase_colorer()])
                # each phase in separate group
                with save.gtkw.group("dfi phaseX", closed=True):
                    for i, phase in enumerate(dfi.phases):
                        save.add(phase, group_name="dfi p{}".format(i), mappers=[
                            gtkw.dfi_sorter(phases=False),
                            gtkw.dfi_in_phase_colorer(),
                        ])
                # only dfi command signals
                save.add(dfi, group_name="dfi commands", mappers=[
                    gtkw.regex_filter(gtkw.suffixes2re(["cas_n", "ras_n", "we_n"])),
                    gtkw.dfi_sorter(),
                    gtkw.dfi_per_phase_colorer(),
                ])
                # only dfi data signals
                save.add(dfi, group_name="dfi wrdata", mappers=[
                    gtkw.regex_filter(["wrdata$", "p{}.*wrdata_en$".format(wrphase)]),
                    gtkw.dfi_sorter(),
                    gtkw.dfi_per_phase_colorer(),
                ])
                save.add(dfi, group_name="dfi wrdata_mask", mappers=[
                    gtkw.regex_filter(gtkw.suffixes2re(["wrdata_mask"])),
                    gtkw.dfi_sorter(),
                    gtkw.dfi_per_phase_colorer(),
                ])
                save.add(dfi, group_name="dfi rddata", mappers=[
                    gtkw.regex_filter(gtkw.suffixes2re(["rddata", "p0.*rddata_valid"])),
                    gtkw.dfi_sorter(),
                    gtkw.dfi_per_phase_colorer(),
                ])

# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="LiteX SoC on Arty A7")
    parser.add_argument("--toolchain",           default="vivado",                 help="Toolchain use to build (default: vivado)")
    parser.add_argument("--build",               action="store_true",              help="Build bitstream")
    parser.add_argument("--load",                action="store_true",              help="Load bitstream")
    parser.add_argument("--load-bios",           action="store_true",              help="Reload BIOS")
    parser.add_argument("--variant",             default="a7-35",                  help="Board variant: a7-35 (default) or a7-100")
    parser.add_argument("--sys-clk-freq",        default=50e6,                    help="System clock frequency (default: 50MHz)")
    ethopts = parser.add_mutually_exclusive_group()
    ethopts.add_argument("--with-ethernet",      action="store_true",              help="Enable Ethernet support")
    ethopts.add_argument("--with-etherbone",     action="store_true",              help="Enable Etherbone support")
    parser.add_argument("--eth-ip",              default="192.168.1.50", type=str, help="Ethernet/Etherbone IP address")
    parser.add_argument("--eth-dynamic-ip",      action="store_true",              help="Enable dynamic Ethernet IP addresses setting")
    sdopts = parser.add_mutually_exclusive_group()
    sdopts.add_argument("--with-spi-sdcard",     action="store_true",              help="Enable SPI-mode SDCard support")
    sdopts.add_argument("--with-sdcard",         action="store_true",              help="Enable SDCard support")
    parser.add_argument("--sdcard-adapter",      type=str,                         help="SDCard PMOD adapter: digilent (default) or numato")
    parser.add_argument("--no-ident-version",    action="store_false",             help="Disable build time output")
    parser.add_argument("--with-jtagbone",       action="store_true",              help="Enable Jtagbone support")
    parser.add_argument("--with-mapped-flash",   action="store_true",              help="Enable Memory Mapped Flash")
    builder_args(parser)
    soc_core_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    assert not (args.with_etherbone and args.eth_dynamic_ip)

    soc = BaseSoC(
        variant           = args.variant,
        toolchain         = args.toolchain,
        sys_clk_freq      = int(float(args.sys_clk_freq)),
        with_ethernet     = args.with_ethernet,
        with_etherbone    = args.with_etherbone,
        eth_ip            = args.eth_ip,
        eth_dynamic_ip    = args.eth_dynamic_ip,
        ident_version     = args.no_ident_version,
        with_jtagbone     = args.with_jtagbone,
        with_mapped_flash = args.with_mapped_flash,
        **soc_core_argdict(args)
    )
    if args.sdcard_adapter == "numato":
        soc.platform.add_extension(arty._numato_sdcard_pmod_io)
    else:
        soc.platform.add_extension(arty._sdcard_pmod_io)
    if args.with_spi_sdcard:
        soc.add_spi_sdcard()
    if args.with_sdcard:
        soc.add_sdcard()
    builder = Builder(soc, **builder_argdict(args))
    builder_kwargs = vivado_build_argdict(args) if args.toolchain == "vivado" else {}
    vns = builder.build(**builder_kwargs, run=args.build)

    generate_gtkw_savefile(builder, vns, trace_fst=False)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

    if args.load_bios:
        from litex import RemoteClient
        wb = RemoteClient()
        wb.open()

        from litex.soc.integration.common import get_mem_data
        bios_bin = os.path.join(builder.software_dir, "bios", "bios.bin")
        rom_data = get_mem_data(bios_bin, "little")
        print(f"Loading BIOS from: {bios_bin} starting at 0x{wb.mems.rom.base:08x} ...")

        print('Stopping CPU')
        wb.regs.ctrl_reset.write(0b10)  # cpu_rst

        for i, word in enumerate(rom_data):
            wb.write(wb.mems.rom.base + 4*i, word)
        wb.read(wb.mems.rom.base)

        print('Rebooting CPU')
        wb.regs.ctrl_reset.write(0)

        wb.close()

if __name__ == "__main__":
    main()
