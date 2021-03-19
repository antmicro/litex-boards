#!/usr/bin/env python3

import os
import argparse

from migen import *

from litex_boards.platforms import lpddr4_test_board
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict
from litex.soc.interconnect.csr import AutoCSR, CSRStorage, CSRStatus

from litex.soc.cores.clock.common import *
from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.soc_sdram import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

from litedram.modules import MT53E256M16D1
from litedram.phy.lpddr4 import S7LPDDR4PHY
from litedram.core.controller import ControllerSettings

from liteeth.phy import LiteEthS7PHYRGMII

from litehyperbus.core.hyperbus import HyperRAM

from litevideo.output import VideoOut

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq, with_sdram, with_ethernet):
        self.clock_domains.cd_sys       = ClockDomain()
        if with_sdram:
            self.clock_domains.cd_sys2x     = ClockDomain(reset_less=True)
            self.clock_domains.cd_sys8x     = ClockDomain(reset_less=True)
        if with_sdram or with_ethernet:
            self.clock_domains.cd_idelay    = ClockDomain()

        # # #

        self.submodules.pll = pll = S7PLL(speedgrade=-1)
        # self.comb += pll.reset.eq(~platform.request("cpu_reset"))
        pll.register_clkin(platform.request("clk100"), 100e6)
        pll.create_clkout(self.cd_sys,       sys_clk_freq)
        if with_sdram:
            pll.create_clkout(self.cd_sys2x,     2*sys_clk_freq)
            pll.create_clkout(self.cd_sys8x,     8*sys_clk_freq)
            # pll.create_clkout(self.cd_sys8x_dqs, 4*sys_clk_freq, phase=90)
        if with_sdram or with_ethernet:
            pll.create_clkout(self.cd_idelay,    200e6)

        if with_sdram or with_ethernet:
            self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq, with_sdram, with_ethernet, with_etherbone, with_hyperram,
            with_video, with_uartbone, with_analyzer, rw_bios_mem, with_masked_write, with_sdcard, **kwargs):
        platform = lpddr4_test_board.Platform()

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq,
            ident               = "LiteX SoC",
            ident_version       = True,
            integrated_rom_mode = 'rw' if rw_bios_mem else 'r',
            **kwargs)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform,
            sys_clk_freq=sys_clk_freq, with_sdram=with_sdram, with_ethernet=with_ethernet or with_etherbone)

        # LDDR4 SDRAM ------------------------------------------------------------------------------
        if with_sdram:
            class ControllerDynamicSettings(Module, AutoCSR):
                def __init__(self):
                    self.refresh = CSRStorage(reset=1, description="Enable/disable Refresh commands sending")
                    self.masked_write = CSRStorage(reset=int(with_masked_write), description="Switch between WRITE/MASKED-WRITE commands")
            self.submodules.controller_settings = ControllerDynamicSettings()
            self.add_csr("controller_settings")


            self.submodules.ddrphy = S7LPDDR4PHY(platform.request("lpddr4"),
                iodelay_clk_freq = 200e6,
                sys_clk_freq     = sys_clk_freq,
                masked_write     = self.controller_settings.masked_write.storage,
            )
            self.add_csr("ddrphy")

            controller_settings = ControllerSettings()
            controller_settings.with_auto_precharge = False
            controller_settings.with_refresh = self.controller_settings.refresh.storage

            module = MT53E256M16D1(sys_clk_freq, "1:8")
            self.add_sdram("sdram",
                phy                     = self.ddrphy,
                module                  = module,
                origin                  = self.mem_map["main_ram"],
                size                    = kwargs.get("max_sdram_size", 0x40000000),
                l2_cache_size           = 0,
                controller_settings     = controller_settings,
            )

            # Debug info ---------------------------------------------------------------------------
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
            dump(self.ddrphy.settings)
            dump(module.geom_settings)
            dump(module.timing_settings)
            print()
            print("=" * 80)

        # Ethernet / Etherbone ---------------------------------------------------------------------
        assert not (with_ethernet and with_etherbone)
        if with_ethernet or with_etherbone:
            self.submodules.ethphy = LiteEthS7PHYRGMII(
                clock_pads = self.platform.request("eth_clocks"),
                pads       = self.platform.request("eth"))
            self.add_csr("ethphy")
            if with_ethernet:
                self.add_ethernet(phy=self.ethphy)
            if with_etherbone:
                self.add_etherbone(phy=self.ethphy)

        # HyperRAM ---------------------------------------------------------------------------------
        if with_hyperram:
            hyperram_base = 0x30000000
            self.submodules.hyperram = HyperRAM(platform.request("hyperram"))
            self.add_wb_slave(hyperram_base, self.hyperram.bus)
            self.add_memory_region("hyperram", hyperram_base, 8*1024*1024)  # TODO: size?

        # SD Card ----------------------------------------------------------------------------------
        if with_sdcard:
            self.add_sdcard()

        # Video out --------------------------------------------------------------------------------
        if with_video:

            mode = "ycbcr422"
            if mode == "ycbcr422":
                dw = 16
            elif mode == "rgb":
                dw = 32
            else:
                raise SystemError("Unknown pixel mode.")

            pix_freq = 148.50e6

            hdmi_out0_pads = platform.request("hdmi_out")
            hdmi_out0_dram_port = self.sdram.crossbar.get_port(
                mode="read",
                data_width=dw,
                clock_domain="sys",
                reverse=True,
            )
    
            self.submodules.hdmi_out0 = VideoOut(
                platform.device,
                hdmi_out0_pads,
                hdmi_out0_dram_port,
                mode=mode,
                fifo_depth=4096,
            )
    
            self.platform.add_false_path_constraints(
                self.crg.cd_sys.clk,
                self.hdmi_out0.driver.clocking.cd_pix.clk)
            self.platform.add_period_constraint(self.hdmi_out0.driver.clocking.cd_pix.clk, period_ns(1*pix_freq))
            self.platform.add_period_constraint(self.hdmi_out0.driver.clocking.cd_pix5x.clk, period_ns(5*pix_freq))
    
            self.platform.add_false_path_constraints(
                self.crg.cd_sys.clk,
                self.hdmi_out0.driver.clocking.cd_pix.clk,
                self.hdmi_out0.driver.clocking.cd_pix5x.clk)
    
            #for name, value in sorted(self.platform.hdmi_infos.items()):
            #    self.add_constant(name, value)

            self.add_csr("hdmi_out0")

        # Leds -------------------------------------------------------------------------------------
        self.submodules.leds = LedChaser(
            pads         = platform.request_all("user_led"),
            sys_clk_freq = sys_clk_freq)
        self.add_csr("leds")

        # UartBone ---------------------------------------------------------------------------------
        if with_uartbone:
            # host bridge on second serial, use:
            #   litex_server --uart --uart-port /dev/ttyUSB3 --uart-baudrate 1e6
            self.add_uartbone("serial", clk_freq=sys_clk_freq, baudrate=1e6, cd="sys")

        # LiteScope --------------------------------------------------------------------------------
        if with_analyzer:
            assert with_uartbone

            signals = []
            # sys clk
            signals += [
                self.ddrphy._out.clk,
                self.ddrphy._out.cs,
                *self.ddrphy._out.ca,
                self.ddrphy._out.dq_o[0],
                self.ddrphy._out.dq_i[0],
                self.ddrphy._out.dq_oe,
                self.ddrphy._out.dqs_o[0],
                self.ddrphy._out.dqs_i[0],
                self.ddrphy._out.dq_oe,
                self.ddrphy._out.dqs_oe,
                self.ddrphy._out.dmi_o[0],
            ]
            # sys2x clk
            signals += [
                self.ddrphy.out.clk,
                self.ddrphy.out.cs,
                *self.ddrphy.out.ca,
                # self.ddrphy.out.dq_o[0],
                *self.ddrphy.out.dq_o,
                # self.ddrphy.out.dq_i[0],
                *self.ddrphy.out.dq_i,
                self.ddrphy.out.dqs_o[0],
                self.ddrphy.out.dqs_i[0],
                self.ddrphy.out.dq_oe,
                self.ddrphy.out.dqs_oe,
                self.ddrphy.out.dmi_o[0],
            ]
            # dfi
            signals += [
                *[p.rddata_en for p in self.ddrphy.dfi.phases],
                *[p.rddata_valid for p in self.ddrphy.dfi.phases],
                *[p.rddata for p in self.ddrphy.dfi.phases],
                *[p.wrdata_en for p in self.ddrphy.dfi.phases],
                *[p.cas_n for p in self.ddrphy.dfi.phases],
                *[p.ras_n for p in self.ddrphy.dfi.phases],
                *[p.we_n  for p in self.ddrphy.dfi.phases],
            ]

            print("=" * 60)
            print("LiteScope data_width = {}".format(sum(map(len, signals))))
            print("=" * 60)

            from litescope import LiteScopeAnalyzer
            self.submodules.analyzer = LiteScopeAnalyzer(signals,
                depth        = 128,
                # register     = 2,
                clock_domain = "sys2x",
                csr_csv      = "analyzer.csv")
            self.add_csr("analyzer")

            def savefile(soc, save):
                from litex.build.sim import gtkwave as gtkw
                # each phase in separate group
                with save.gtkw.group("dfi phaseX", closed=True):
                    for i, phase in enumerate(soc.ddrphy.dfi.phases):
                        save.add(phase, group_name="dfi p{}".format(i), mappers=[
                            gtkw.dfi_sorter(phases=False),
                            gtkw.dfi_in_phase_colorer(),
                        ])
                # only dfi command signals
                save.add(soc.ddrphy.dfi, group_name="dfi commands", mappers=[
                    gtkw.regex_filter(gtkw.suffixes2re(["cas_n", "ras_n", "we_n"])),
                    gtkw.dfi_sorter(),
                    gtkw.dfi_per_phase_colorer(),
                ])
                # serialization
                with save.gtkw.group("serialization", closed=True):
                    ser_groups = [("out 1x", soc.ddrphy._out), ("out 2x", soc.ddrphy.out)]
                    for name, out in ser_groups:
                        save.group([out.cs, *out.ca, *out.dq_o, out.dq_oe, *out.dmi_o, *out.dqs_o, out.dqs_oe],
                            group_name = name,
                            mappers = [
                                gtkw.regex_colorer({
                                    "green": gtkw.suffixes2re(["cs\d*"]),
                                    "yellow": gtkw.suffixes2re(["ca\d*", "dqs_o\d+"]),
                                    "orange": ["dq_o\d+", "dmi_o\d+"],
                                    "red": gtkw.suffixes2re(["oe\d*"]),
                                })
                            ]
                        )
                with save.gtkw.group("deserialization", closed=True):
                    ser_groups = [("in 2x", soc.ddrphy.out), ("in 1x", soc.ddrphy._out)]
                    for name, out in ser_groups:
                        save.group([*out.dq_i, out.dq_oe, *out.dqs_i, out.dqs_oe],
                            group_name = name,
                            mappers = [gtkw.regex_colorer({
                                "yellow": ["dqs_i"],
                                "orange": ["dq_i"],
                                "red": gtkw.suffixes2re(["oe\d*"]),
                            })]
                        )
                save.add(soc.ddrphy.dfi, group_name="dfi rddata", mappers=[
                    gtkw.regex_filter(gtkw.suffixes2re(["rddata", "p0.*rddata_valid"])),
                    gtkw.dfi_sorter(),
                    gtkw.dfi_per_phase_colorer(),
                ])

            self.generate_gtkwave_savefile = savefile

# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="LiteX SoC")
    target = parser.add_argument_group(title="Target options")
    target.add_argument("--build", action="store_true", help="Build bitstream")
    target.add_argument("--load",  action="store_true", help="Load bitstream")
    target.add_argument("--load-bios",  action="store_true", help="Reload BIOS code on running target")
    target.add_argument("--flash",  action="store_true", help="Flash bitstream to QSPI flash configuration memory")
    target.add_argument("--sys-clk-freq", default="35e6", help="System clock frequency")
    target.add_argument("--rw-bios-mem", action="store_true", help="Make BIOS memory writable")
    target.add_argument("--with-sdram", action="store_true", help="Add LPDDR4 PHY")
    target.add_argument("--no-masked-write", action="store_true", help="Use LPDDR4 WRITE instead of MASKED-WRITE")
    target.add_argument("--with-ethernet", action="store_true", help="Add Ethernet PHY")
    target.add_argument("--with-etherbone", action="store_true", help="Add EtherBone")
    target.add_argument("--with-uartbone", action="store_true", help="Add UartBone on 2nd serial")
    target.add_argument("--with-hyperram", action="store_true", help="Add HyperRAM")
    target.add_argument("--with-video", action="store_true", help="Add LiteVideo")
    target.add_argument("--with-analyzer", action="store_true", help="Add LiteScope")
    target.add_argument("--with-sdcard", action="store_true", help="Add SDCard")
    target.add_argument("--gtkw-savefile", action="store_true", help="Generate GTKWave savefile")
    builder_args(parser)
    soc_sdram_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    soc_kwargs = soc_sdram_argdict(args)
    soc_kwargs['integrated_rom_size'] = 0x10000
    if not args.with_sdram and (args.with_ethernet or args.with_etherbone):
        # 100k to satisfy BIOS requiring MAIN_RAM_BASE
        soc_kwargs["integrated_main_ram_size"] = 0x10000

    soc = BaseSoC(
        sys_clk_freq      = int(float(args.sys_clk_freq)),
        with_sdram        = args.with_sdram,
        with_masked_write = not args.no_masked_write,
        with_ethernet     = args.with_ethernet,
        with_etherbone    = args.with_etherbone,
        with_uartbone     = args.with_uartbone,
        with_hyperram     = args.with_hyperram,
        with_video        = args.with_video,
        with_analyzer     = args.with_analyzer,
        rw_bios_mem       = args.rw_bios_mem,
        with_sdcard       = args.with_sdcard,
        **soc_kwargs)
    builder = Builder(soc, **builder_argdict(args))
    vns = builder.build(**vivado_build_argdict(args), run=args.build)

    if args.with_analyzer and args.gtkw_savefile:
        from litex.build.sim import gtkwave as gtkw
        savefile = os.path.join(builder.gateware_dir, "dump.gtkw")
        with gtkw.GTKWSave(vns, savefile=savefile, dumpfile="dump.vcd", prefix="", treeopen=False) as save:
            soc.generate_gtkwave_savefile(soc, save)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

    if args.load_bios:
        # FIXME: writing the memory during runtime may lead to unexpected behaviour,
        # but currently it is not possible to hold the CPU in a reset state using ctrl_reset
        assert args.rw_bios_mem, 'BIOS memory must be writible'

        from litex import RemoteClient
        wb = RemoteClient()
        wb.open()

        def memwrite(wb, data, *, base, burst=0xff):
            for i in range(0, len(data), burst):
                wb.write(base + 4 * i, data[i:i + burst])

        from litex.soc.integration.common import get_mem_data
        bios_bin = os.path.join(builder.software_dir, "bios", "bios.bin")
        rom_data = get_mem_data(bios_bin, "little")
        print(f"Loading BIOS from: {bios_bin} starting at 0x{wb.mems.rom.base:08x} ...")
        memwrite(wb, rom_data, base=wb.mems.rom.base)
        wb.read(wb.mems.rom.base)

        # reboot CPU
        print('Rebooting CPU')
        wb.regs.ctrl_reset.write(1)

        wb.close()

    if args.flash:
        prog = soc.platform.create_programmer()
        prog.flash(0, os.path.join(builder.gateware_dir, soc.build_name + ".bin"))


if __name__ == "__main__":
    main()
