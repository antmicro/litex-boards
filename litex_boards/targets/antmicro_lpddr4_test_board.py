#!/usr/bin/env python3
#
# This file is part of LiteX-Boards.
#
# Copyright (c) 2021 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: BSD-2-Clause

import os
import math
import argparse

from migen import *

from litex_boards.platforms import lpddr4_test_board
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

from litedram.modules import MT53E256M16D1
from litedram.phy import lpddr4

from liteeth.phy import LiteEthS7PHYRGMII
from litehyperbus.core.hyperbus import HyperRAM

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq, iodelay_clk_freq):
        self.clock_domains.cd_sys    = ClockDomain()
        self.clock_domains.cd_sys2x  = ClockDomain(reset_less=True)
        self.clock_domains.cd_sys8x  = ClockDomain(reset_less=True)
        self.clock_domains.cd_idelay = ClockDomain()

        # # #

        self.submodules.pll = pll = S7PLL(speedgrade=-1)
        pll.register_clkin(platform.request("clk100"), 100e6)
        pll.create_clkout(self.cd_sys,    sys_clk_freq)
        pll.create_clkout(self.cd_sys2x,  2 * sys_clk_freq)
        pll.create_clkout(self.cd_sys8x,  8 * sys_clk_freq)
        pll.create_clkout(self.cd_idelay, iodelay_clk_freq)

        self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    mem_map = {
        "hyperram": 0x20000000,
    }
    mem_map.update(SoCCore.mem_map)

    def __init__(self, *, sys_clk_freq=int(50e6), iodelay_clk_freq=200e6,
            with_ethernet=False, with_etherbone=False, eth_ip="192.168.1.50", eth_dynamic_ip=False,
            with_hyperram=False, with_sdcard=False, with_jtagbone=True, with_uartbone=False,
            ident_version=True, rw_bios_mem=False, with_masked_write=True, l2_size=8192, **kwargs):
        platform = lpddr4_test_board.Platform()

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq,
            ident         = "LiteX SoC on LPDDR4 Test Board",
            ident_version = ident_version,
            integrated_rom_mode = 'rw' if rw_bios_mem else 'r',
            **kwargs)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform, sys_clk_freq, iodelay_clk_freq=iodelay_clk_freq)

        # LDDR4 SDRAM ------------------------------------------------------------------------------
        if not self.integrated_main_ram_size:
            from litex.soc.interconnect.csr import AutoCSR, CSRStorage, CSRStatus
            class ControllerDynamicSettings(Module, AutoCSR):
                def __init__(self):
                    self.refresh = CSRStorage(reset=1, description="Enable/disable Refresh commands sending")
                    self.masked_write = CSRStorage(reset=int(with_masked_write), description="Switch between WRITE/MASKED-WRITE commands")
            self.submodules.controller_settings = ControllerDynamicSettings()
            self.add_csr("controller_settings")

            self.submodules.ddrphy = lpddr4.K7LPDDR4PHY(platform.request("lpddr4"),
                iodelay_clk_freq = iodelay_clk_freq,
                sys_clk_freq     = sys_clk_freq,
                masked_write     = self.controller_settings.masked_write.storage,
            )

            from litedram.core.controller import ControllerSettings
            controller_settings = ControllerSettings()
            controller_settings.with_auto_precharge = False
            controller_settings.with_refresh = self.controller_settings.refresh.storage

            module = MT53E256M16D1(sys_clk_freq, "1:8")
            self.add_sdram("sdram",
                phy                     = self.ddrphy,
                module                  = MT53E256M16D1(sys_clk_freq, "1:8"),
                l2_cache_size           = l2_size,
                l2_cache_min_data_width = 256,
                controller_settings     = controller_settings,
            )

            self.add_constant("SDRAM_DEBUG")

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
            __import__('pprint').pprint(self.ddrphy.dfi.layout[0])
            print()
            print("=" * 80)

        # HyperRAM ---------------------------------------------------------------------------------
        if with_hyperram:
            self.submodules.hyperram = HyperRAM(platform.request("hyperram"))
            self.register_mem("hyperram", self.mem_map["hyperram"], self.hyperram.bus, 8*1024*1024)

        # SD Card ----------------------------------------------------------------------------------
        if with_sdcard:
            self.add_sdcard()

        # Ethernet / Etherbone ---------------------------------------------------------------------
        if with_ethernet or with_etherbone:
            # Traces between PHY and FPGA introduce ignorable delays of ~0.165ns +/- 0.015ns.
            # PHY chip does not introduce delays on TX (FPGA->PHY), however it includes 1.2ns
            # delay for RX CLK so we only need 0.8ns to match the desired 2ns.
            self.submodules.ethphy = LiteEthS7PHYRGMII(
                clock_pads = self.platform.request("eth_clocks"),
                pads       = self.platform.request("eth"),
                rx_delay   = 0.8e-9,
                iodelay_clk_freq = iodelay_clk_freq,
            )
            if with_ethernet:
                self.add_ethernet(phy=self.ethphy, dynamic_ip=eth_dynamic_ip)
            if with_etherbone:
                self.add_etherbone(phy=self.ethphy, ip_address=eth_ip)

        # Jtagbone ---------------------------------------------------------------------------------
        if with_jtagbone:
            self.add_jtagbone()

        # UartBone ---------------------------------------------------------------------------------
        if with_uartbone:
            self.add_uartbone("serial", baudrate=1e6)

        # Leds -------------------------------------------------------------------------------------
        self.submodules.leds = LedChaser(
            pads         = platform.request_all("user_led"),
            sys_clk_freq = sys_clk_freq)

# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="LiteX SoC on LPDDR4 Test Board")
    target = parser.add_argument_group(title="Target options")
    target.add_argument("--build",            action="store_true",    help="Build bitstream")
    target.add_argument("--load",             action="store_true",    help="Load bitstream")
    target.add_argument("--flash",            action="store_true",    help="Flash bitstream")
    target.add_argument("--load-bios",  action="store_true", help="Reload BIOS code on running target")
    target.add_argument("--scan-pll", nargs=3, help="Scan for available PLL configs in sysclk frequency range (fmin, fmax, fstep)")
    target.add_argument("--sys-clk-freq",     default=50e6,           help="System clock frequency")
    target.add_argument("--iodelay-clk-freq", default=200e6,          help="IODELAYCTRL frequency")
    target.add_argument("--rw-bios-mem", action="store_true", help="Make BIOS memory writable")
    target.add_argument("--no-masked-write", action="store_true", help="Use LPDDR4 WRITE instead of MASKED-WRITE")
    ethopts = target.add_mutually_exclusive_group()
    ethopts.add_argument("--with-ethernet",   action="store_true",    help="Add Ethernet")
    ethopts.add_argument("--with-etherbone",  action="store_true",    help="Add EtherBone")
    target.add_argument("--eth-ip",           default="192.168.1.50", help="Ethernet/Etherbone IP address")
    target.add_argument("--eth-dynamic-ip",   action="store_true",    help="Enable dynamic Ethernet IP addresses setting")
    target.add_argument("--with-hyperram",    action="store_true",    help="Add HyperRAM")
    target.add_argument("--with-sdcard",      action="store_true",    help="Add SDCard")
    target.add_argument("--with-jtagbone",    action="store_true",    help="Add JTAGBone")
    target.add_argument("--with-uartbone",    action="store_true",    help="Add UartBone on 2nd serial")
    parser.add_argument("--no-ident-version", action="store_false",   help="Disable build time output")
    builder_args(parser)
    soc_core_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    sys_clk_freq      = int(float(args.sys_clk_freq))
    iodelay_clk_freq  = int(float(args.iodelay_clk_freq))

    if args.scan_pll:
        verbose = False

        if not verbose:
            import logging
            logging.getLogger("S7PLL").setLevel(logging.WARNING)

        fmin, fmax, fstep = map(float, args.scan_pll)
        found = []
        for i in range(math.floor((fmax - fmin) / fstep)):
            freq = fmin + i * fstep
            crg = _CRG(platform=lpddr4_test_board.Platform(), sys_clk_freq=freq, iodelay_clk_freq=iodelay_clk_freq)
            try:
                if verbose: print(f"Trying sys_clk_freq = {freq/1e6:6.2f} MHz ... ")
                crg.finalize()
                found.append(freq)
                if verbose:
                    print(f"  ... OK")
                else:
                    print(".", end="", flush=True)
            except ValueError as e:
                if "No PLL config found" not in str(e):
                    raise
                if verbose:
                    print(f"  ... FAIL")
                else:
                    print("X", end="", flush=True)
        print("\nFound PLL configs for:")
        prev = None
        for freq in found:
            if prev is None or (freq - prev) > fstep * 1.001:
                print("---")
            print(f"  sys_clk_freq = {freq/1e6:6.2f} MHz")
            prev = freq
        import sys
        sys.exit(0)

    assert not (args.with_etherbone and args.eth_dynamic_ip)

    soc_kwargs = soc_core_argdict(args)
    soc_kwargs['integrated_rom_size'] = 0x10000

    soc = BaseSoC(
        sys_clk_freq      = sys_clk_freq,
        iodelay_clk_freq  = iodelay_clk_freq,
        with_masked_write = not args.no_masked_write,
        rw_bios_mem       = args.rw_bios_mem,
        with_ethernet     = args.with_ethernet,
        with_etherbone    = args.with_etherbone,
        eth_ip            = args.eth_ip,
        eth_dynamic_ip    = args.eth_dynamic_ip,
        with_hyperram     = args.with_hyperram,
        with_sdcard       = args.with_sdcard,
        with_jtagbone     = args.with_jtagbone,
        with_uartbone     = args.with_uartbone,
        ident_version     = args.no_ident_version,
        l2_size           = args.l2_size,
        **soc_kwargs)
    builder = Builder(soc, **builder_argdict(args))
    vns = builder.build(**vivado_build_argdict(args), run=args.build)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(os.path.join(builder.gateware_dir, soc.build_name + ".bit"))

    if args.flash:
        prog = soc.platform.create_programmer()
        prog.flash(0, os.path.join(builder.gateware_dir, soc.build_name + ".bin"))

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

        # reboot CPU
        print('Reseting CPU')
        wb.regs.ctrl_reset_hold.write(1)
        # import time
        # time.sleep(0.2)

        print(f"Loading BIOS from: {bios_bin} starting at 0x{wb.mems.rom.base:08x} ...")
        memwrite(wb, rom_data, base=wb.mems.rom.base)
        wb.read(wb.mems.rom.base)

        # reboot CPU
        print('Rebooting CPU')
        wb.regs.ctrl_reset_hold.write(0)

        wb.close()

if __name__ == "__main__":
    main()
