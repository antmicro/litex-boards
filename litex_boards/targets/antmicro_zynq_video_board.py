#!/usr/bin/env python3

# Copyright (c) 2022 Antmicro <www.antmicro.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#
import os
import argparse

from migen import *

from litex_boards.platforms import antmicro_zynq_video_board
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict

from litex.soc.interconnect import axi, wishbone, stream
from litex.soc.cores.clock import S7PLL
from litex.soc.integration.soc_core import SoCCore, soc_core_args, soc_core_argdict
from litex.soc.integration.soc import SoCRegion
from litex.soc.integration.builder import Builder, builder_args, builder_argdict
from litex.soc.cores.led import LedChaser

from fpga_isp.debayer.wrapper import DemosaicWrapper
from fpga_isp.debayer.common import Bayer_t, Demosaic_t


class FastVDMAOutput(Module):
    def __init__(self, platform, data_width=32, adr_width=30):
        self.bayer_rgb_layout = [("data",   32)] # send 2 pixels at once
        # Add verilog file with generated netlist for FastVDMA -------------------------------------
        platform.add_sources(os.path.abspath(os.path.dirname(__file__)), "DMATopAXIS_WB_AXI.v")

        # Attach FastVDMA signals to wishbone buses ------------------------------------------------
        self.wb_control_bus = wishbone.Interface(data_width, adr_width)
        self.rgb = stream.Endpoint(self.bayer_rgb_layout) # input raw bayer image
        self.axi_write_bus = axi.AXIInterface(data_width)
        self.irq_readerDone = Signal()
        self.irq_writerDone = Signal()

        self.sync_readerSync = Signal()
        self.sync_writerSync = Signal()

        self.specials += Instance("DMATopAXIS_WB_AXI",
                                  i_clock = ClockSignal("ps7"),
                                  i_reset = ResetSignal("ps7"),
                                  i_io_control_dat_i = self.wb_control_bus.dat_w,
                                  o_io_control_dat_o = self.wb_control_bus.dat_r,
                                  i_io_control_cyc_i = self.wb_control_bus.cyc,
                                  i_io_control_stb_i = self.wb_control_bus.stb,
                                  i_io_control_we_i = self.wb_control_bus.we,
                                  i_io_control_adr_i = self.wb_control_bus.adr,
                                  i_io_control_sel_i = self.wb_control_bus.sel,
                                  o_io_control_ack_o = self.wb_control_bus.ack,
                                  o_io_control_err_o = self.wb_control_bus.err,

                                  i_io_read_tdata = self.rgb.data,
                                  i_io_read_tvalid = self.rgb.valid,
                                  o_io_read_tready = self.rgb.ready,
                                  i_io_read_tlast = self.rgb.last,

                                  o_io_write_aw_awid = self.axi_write_bus.aw.id,
                                  o_io_write_aw_awaddr = self.axi_write_bus.aw.addr,
                                  o_io_write_aw_awlen = self.axi_write_bus.aw.len,
                                  o_io_write_aw_awsize = self.axi_write_bus.aw.size,
                                  o_io_write_aw_awburst = self.axi_write_bus.aw.burst,
                                  o_io_write_aw_awlock = self.axi_write_bus.aw.lock,
                                  o_io_write_aw_awcache = self.axi_write_bus.aw.cache,
                                  o_io_write_aw_awprot = self.axi_write_bus.aw.prot,
                                  o_io_write_aw_awqos = self.axi_write_bus.aw.qos,
                                  o_io_write_aw_awvalid = self.axi_write_bus.aw.valid,
                                  i_io_write_aw_awready = self.axi_write_bus.aw.ready,
                                  o_io_write_w_wdata = self.axi_write_bus.w.data,
                                  o_io_write_w_wstrb = self.axi_write_bus.w.strb,
                                  o_io_write_w_wlast = self.axi_write_bus.w.last,
                                  o_io_write_w_wvalid = self.axi_write_bus.w.valid,
                                  i_io_write_w_wready = self.axi_write_bus.w.ready,
                                  i_io_write_b_bid = self.axi_write_bus.b.id,
                                  i_io_write_b_bresp = self.axi_write_bus.b.resp,
                                  i_io_write_b_bvalid = self.axi_write_bus.b.valid,
                                  o_io_write_b_bready= self.axi_write_bus.b.ready,
                                  o_io_write_ar_arid = self.axi_write_bus.ar.id,
                                  o_io_write_ar_araddr = self.axi_write_bus.ar.addr,
                                  o_io_write_ar_arlen = self.axi_write_bus.ar.len,
                                  o_io_write_ar_arsize = self.axi_write_bus.ar.size,
                                  o_io_write_ar_arburst = self.axi_write_bus.ar.burst,
                                  o_io_write_ar_arlock = self.axi_write_bus.ar.lock,
                                  o_io_write_ar_arcache = self.axi_write_bus.ar.cache,
                                  o_io_write_ar_arprot = self.axi_write_bus.ar.prot,
                                  o_io_write_ar_arqos = self.axi_write_bus.ar.qos,
                                  o_io_write_ar_arvalid = self.axi_write_bus.ar.valid,
                                  i_io_write_ar_arready = self.axi_write_bus.ar.ready,
                                  i_io_write_r_rid = self.axi_write_bus.r.id,
                                  i_io_write_r_rdata = self.axi_write_bus.r.data,
                                  i_io_write_r_rresp = self.axi_write_bus.r.resp,
                                  i_io_write_r_rlast = self.axi_write_bus.r.last,
                                  i_io_write_r_rvalid = self.axi_write_bus.r.valid,
                                  o_io_write_r_rready = self.axi_write_bus.r.ready,

                                  o_io_irq_readerDone = self.irq_readerDone,
                                  o_io_irq_writerDone = self.irq_writerDone,
                                  i_io_sync_readerSync = self.sync_readerSync,
                                  i_io_sync_writerSync = self.sync_writerSync,
        )

class FastVDMAInput(Module):
    def __init__(self, platform, data_width=32, adr_width=30):
        bayer_raw_layout = [("data",   32), ("reset_state", 1)]
        # Add verilog file with generated netlist for FastVDMA -------------------------------------
        platform.add_sources(os.path.abspath(os.path.dirname(__file__)), "DMATopAXI_WB_AXIS.v")

        # Attach FastVDMA signals to wishbone buses ------------------------------------------------
        self.wb_control_bus = wishbone.Interface(data_width, adr_width)
        self.raw = stream.Endpoint(bayer_raw_layout) # input raw bayer image
        self.axi_read_bus = axi.AXIInterface(data_width)

        self.irq_readerDone = Signal()
        self.irq_writerDone = Signal()

        self.sync_readerSync = Signal()
        self.sync_writerSync = Signal()

        self.specials += Instance("DMATopAXI_WB_AXIS",
                                  i_clock = ClockSignal("ps7"),
                                  i_reset = ResetSignal("ps7"),
                                  i_io_control_dat_i = self.wb_control_bus.dat_w,
                                  o_io_control_dat_o = self.wb_control_bus.dat_r,
                                  i_io_control_cyc_i = self.wb_control_bus.cyc,
                                  i_io_control_stb_i = self.wb_control_bus.stb,
                                  i_io_control_we_i = self.wb_control_bus.we,
                                  i_io_control_adr_i = self.wb_control_bus.adr,
                                  i_io_control_sel_i = self.wb_control_bus.sel,
                                  o_io_control_ack_o = self.wb_control_bus.ack,
                                  o_io_control_err_o = self.wb_control_bus.err,

                                  o_io_write_tdata = self.raw.data,
                                  o_io_write_tvalid = self.raw.valid,
                                  i_io_write_tready = self.raw.ready,
                                  o_io_write_tlast = self.raw.last,
                                  o_io_write_tuser = self.raw.first,

                                  o_io_read_aw_awid = self.axi_read_bus.aw.id,
                                  o_io_read_aw_awaddr = self.axi_read_bus.aw.addr,
                                  o_io_read_aw_awlen = self.axi_read_bus.aw.len,
                                  o_io_read_aw_awsize = self.axi_read_bus.aw.size,
                                  o_io_read_aw_awburst = self.axi_read_bus.aw.burst,
                                  o_io_read_aw_awlock = self.axi_read_bus.aw.lock,
                                  o_io_read_aw_awcache = self.axi_read_bus.aw.cache,
                                  o_io_read_aw_awprot = self.axi_read_bus.aw.prot,
                                  o_io_read_aw_awqos = self.axi_read_bus.aw.qos,
                                  o_io_read_aw_awvalid = self.axi_read_bus.aw.valid,
                                  i_io_read_aw_awready = self.axi_read_bus.aw.ready,
                                  o_io_read_w_wdata = self.axi_read_bus.w.data,
                                  o_io_read_w_wstrb = self.axi_read_bus.w.strb,
                                  o_io_read_w_wlast = self.axi_read_bus.w.last,
                                  o_io_read_w_wvalid = self.axi_read_bus.w.valid,
                                  i_io_read_w_wready = self.axi_read_bus.w.ready,
                                  i_io_read_b_bid = self.axi_read_bus.b.id,
                                  i_io_read_b_bresp = self.axi_read_bus.b.resp,
                                  i_io_read_b_bvalid = self.axi_read_bus.b.valid,
                                  o_io_read_b_bready= self.axi_read_bus.b.ready,
                                  o_io_read_ar_arid = self.axi_read_bus.ar.id,
                                  o_io_read_ar_araddr = self.axi_read_bus.ar.addr,
                                  o_io_read_ar_arlen = self.axi_read_bus.ar.len,
                                  o_io_read_ar_arsize = self.axi_read_bus.ar.size,
                                  o_io_read_ar_arburst = self.axi_read_bus.ar.burst,
                                  o_io_read_ar_arlock = self.axi_read_bus.ar.lock,
                                  o_io_read_ar_arcache = self.axi_read_bus.ar.cache,
                                  o_io_read_ar_arprot = self.axi_read_bus.ar.prot,
                                  o_io_read_ar_arqos = self.axi_read_bus.ar.qos,
                                  o_io_read_ar_arvalid = self.axi_read_bus.ar.valid,
                                  i_io_read_ar_arready = self.axi_read_bus.ar.ready,
                                  i_io_read_r_rid = self.axi_read_bus.r.id,
                                  i_io_read_r_rdata = self.axi_read_bus.r.data,
                                  i_io_read_r_rresp = self.axi_read_bus.r.resp,
                                  i_io_read_r_rlast = self.axi_read_bus.r.last,
                                  i_io_read_r_rvalid = self.axi_read_bus.r.valid,
                                  o_io_read_r_rready = self.axi_read_bus.r.ready,

                                  o_io_irq_readerDone = self.irq_readerDone,
                                  o_io_irq_writerDone = self.irq_writerDone,
                                  i_io_sync_readerSync = self.sync_readerSync,
                                  i_io_sync_writerSync = self.sync_writerSync,
        )
# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq, use_ps7_clk=False):
        self.clock_domains.cd_sys = ClockDomain()

        # # #
        if use_ps7_clk:
            self.comb += ClockSignal("sys").eq(ClockSignal("ps7"))
            self.comb += ResetSignal("sys").eq(ResetSignal("ps7"))
        else:
            self.submodules.pll = pll = S7PLL(speedgrade=-1)
            pll.register_clkin(platform.request("clk125"), 125e6)
            pll.create_clkout(self.cd_sys, sys_clk_freq)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=int(100e6), **kwargs):
       # base_address = 0x43c0_0000
        base_address = 0x0
        platform = antmicro_zynq_video_board.Platform()
        mem_map = {
            "csr":          0x43c1_0000 - base_address,
        }

        # SoCCore ----------------------------------------------------------------------------------
        kwargs["ident"] = "LiteX SoC on ZVB"
        kwargs["ident_version"]  = True
        SoCCore.__init__(self, platform, sys_clk_freq, **kwargs)

        # Since we correctly calcule modules' offsets we also need to decode them
        # this in the end impacts the sel signal on AXI
        self.cpu.csr_decode = True
        self.mem_map.update(mem_map)
        
        # The IO region is added to allow DMA's and csr offset at < 0x4000_0000
        # And when specyfing 0x43cxxxxx addresses the transactions fail to be eecuted  
        self.bus.io_regions["core_space"] = SoCRegion(origin=0x00000000, size=0x10_0000)
        
        # The reset address must be at allocated region -- here we don't really need
        # the reset address; this SoCRegion is only to fulfill LiteX constrains
        self.bus.regions["reset"] = SoCRegion(origin=0xfc000000, size=0x100)

        # The IO region is added to allow DMA's and csr offset at < 0x4000_0000
        # And when specyfing 0x43cxxxxx addresses the transactions fail to be eecuted
        #self.bus.io_regions["core_space"] = SoCRegion(origin=0x00000000, size=0x10_0000)

        # add fastvdma
        self.submodules.fastvdmaIn = FastVDMAInput(self.platform)
        self.bus.add_slave("fastvdma_control_in", self.fastvdmaIn.wb_control_bus,
                SoCRegion(origin=0x43c0_0000 - base_address, size=0x00001000, cached=False))

        self.comb += self.fastvdmaIn.axi_read_bus.connect(self.cpu.add_axi_hp_slave())

        self.submodules.fastvdmaOut = FastVDMAOutput(self.platform)
        self.bus.add_slave("fastvdma_control_out", self.fastvdmaOut.wb_control_bus,
                SoCRegion(origin=0x43c0_1000 - base_address, size=0x00001000, cached=False))

        self.comb += self.fastvdmaOut.axi_write_bus.connect(self.cpu.add_axi_hp_slave())

        im = kwargs["image"]
        self.submodules.wrapper = DemosaicWrapper(kwargs["algorithm"],
                                       self.fastvdmaIn.raw,
                                       self.fastvdmaOut.rgb,
                                       im["width"],
                                       im["height"],
                                       im["pattern"])
        self.add_csr("wrapper")

        # Zynq7000 Integration ---------------------------------------------------------------------
        self.cpu.set_ps7_xci("zvb_xci/zynq_video_board_ps7.xci")

        # Connect AXI GP0 to the SoC
        wb_gp0 = wishbone.Interface()
        self.submodules += axi.AXI2Wishbone(
            axi          = self.cpu.add_axi_gp_master(),
            wishbone     = wb_gp0,
            base_address = base_address)
        vdma_irq = Signal(16)
        self.comb += [
            vdma_irq[0].eq(self.fastvdmaIn.irq_readerDone),
            vdma_irq[2].eq(self.fastvdmaOut.irq_writerDone),
        ]
        self.cpu.add_ps7_irq(vdma_irq)
        self.add_wb_master(wb_gp0)

        print(self.cpu.io_regions)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform, sys_clk_freq, use_ps7_clk=True)

# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="LiteX SoC on Zybo Z7")
    parser.add_argument("--build", action="store_true", help="Build bitstream")
    parser.add_argument("--algorithm", required=True, help="One of Nearest, Bilinear, Edge")
    builder_args(parser)
    soc_core_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()
    alg_type = None
    if args.algorithm:
        if args.algorithm == "Nearest":
            alg_type=Demosaic_t.NEAREST
        elif args.algorithm == "Bilinear":
            alg_type=Demosaic_t.BILINEAR
        elif args.algorithm == "Edge":
            alg_type=Demosaic_t.EDGE_DIRECTED
        else:
            raise ValueError

    dummy_image = {
        "width"   : 6,
        "height"  : 8,
        "pattern" : Bayer_t.RGGB,
    }

    soc_args = soc_core_argdict(args)
    soc_args["cpu_type"] = "zynq7000"
    soc_args["sys_clk_freq"] = 250000000

    soc = BaseSoC(**soc_args, image=dummy_image, algorithm=alg_type)
    builder = Builder(soc, **builder_argdict(args))
    builder.build(**vivado_build_argdict(args), run=args.build)

if __name__ == "__main__":
    main()
