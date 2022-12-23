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

from litex.soc.interconnect.axi import AXIInterface, AXILiteInterface, AXILite2AXI, AXI2Wishbone
from litex.soc.interconnect import wishbone
from litex.soc.cores.clock import S7PLL
from litex.soc.integration.soc_core import SoCCore, soc_core_args, soc_core_argdict
from litex.soc.integration.soc import SoCRegion
from litex.soc.integration.builder import Builder, builder_args, builder_argdict
from litex.soc.cores.led import LedChaser

class AIG(Module):
    def __init__(self, platform, data_width=32, adr_width=30):
        platform.add_sources(os.path.abspath(os.path.dirname(__file__)), "AcceleratorTop.v")
        platform.add_sources(os.path.abspath(os.path.dirname(__file__)), "AcceleratorIntegration.v")
        platform.add_sources(os.path.abspath(os.path.dirname(__file__)), "fpga_isp.v")
        platform.add_sources(os.path.abspath(os.path.dirname(__file__)), "DMATopAXI_AXIL_AXIS.v")
        platform.add_sources(os.path.abspath(os.path.dirname(__file__)), "DMATopAXIS_AXIL_AXI.v")

        self.axi_write = AXIInterface(data_width)
        self.axi_read = AXIInterface(data_width)
        self.axi_control = AXILiteInterface(data_width)

        self.irq_dmaIn = Signal(2)
        self.irq_dmaOut = Signal(2)

        self.specials += Instance("AcceleratorTop",
                                  i_clock = ClockSignal("ps7"),
                                  i_reset = ResetSignal("ps7"),

                                  o_io_in_read_aw_awid = self.axi_read.aw.id,
                                  o_io_in_read_aw_awaddr = self.axi_read.aw.addr,
                                  o_io_in_read_aw_awlen = self.axi_read.aw.len,
                                  o_io_in_read_aw_awsize = self.axi_read.aw.size,
                                  o_io_in_read_aw_awburst = self.axi_read.aw.burst,
                                  o_io_in_read_aw_awlock = self.axi_read.aw.lock,
                                  o_io_in_read_aw_awcache = self.axi_read.aw.cache,
                                  o_io_in_read_aw_awprot = self.axi_read.aw.prot,
                                  o_io_in_read_aw_awqos = self.axi_read.aw.qos,
                                  o_io_in_read_aw_awvalid = self.axi_read.aw.valid,
                                  i_io_in_read_aw_awready = self.axi_read.aw.ready,
                                  o_io_in_read_w_wdata = self.axi_read.w.data,
                                  o_io_in_read_w_wstrb = self.axi_read.w.strb,
                                  o_io_in_read_w_wlast = self.axi_read.w.last,
                                  o_io_in_read_w_wvalid = self.axi_read.w.valid,
                                  i_io_in_read_w_wready = self.axi_read.w.ready,
                                  i_io_in_read_b_bid = self.axi_read.b.id,
                                  i_io_in_read_b_bresp = self.axi_read.b.resp,
                                  i_io_in_read_b_bvalid = self.axi_read.b.valid,
                                  o_io_in_read_b_bready= self.axi_read.b.ready,
                                  o_io_in_read_ar_arid = self.axi_read.ar.id,
                                  o_io_in_read_ar_araddr = self.axi_read.ar.addr,
                                  o_io_in_read_ar_arlen = self.axi_read.ar.len,
                                  o_io_in_read_ar_arsize = self.axi_read.ar.size,
                                  o_io_in_read_ar_arburst = self.axi_read.ar.burst,
                                  o_io_in_read_ar_arlock = self.axi_read.ar.lock,
                                  o_io_in_read_ar_arcache = self.axi_read.ar.cache,
                                  o_io_in_read_ar_arprot = self.axi_read.ar.prot,
                                  o_io_in_read_ar_arqos = self.axi_read.ar.qos,
                                  o_io_in_read_ar_arvalid = self.axi_read.ar.valid,
                                  i_io_in_read_ar_arready = self.axi_read.ar.ready,
                                  i_io_in_read_r_rid = self.axi_read.r.id,
                                  i_io_in_read_r_rdata = self.axi_read.r.data,
                                  i_io_in_read_r_rresp = self.axi_read.r.resp,
                                  i_io_in_read_r_rlast = self.axi_read.r.last,
                                  i_io_in_read_r_rvalid = self.axi_read.r.valid,
                                  o_io_in_read_r_rready = self.axi_read.r.ready,

                                  i_io_control_aw_awaddr = self.axi_control.aw.addr,
                                  i_io_control_aw_awprot = self.axi_control.aw.prot,
                                  i_io_control_aw_awvalid = self.axi_control.aw.valid,
                                  o_io_control_aw_awready = self.axi_control.aw.ready,
                                  i_io_control_w_wdata = self.axi_control.w.data,
                                  i_io_control_w_wstrb = self.axi_control.w.strb,
                                  i_io_control_w_wvalid = self.axi_control.w.valid,
                                  o_io_control_w_wready = self.axi_control.w.ready,
                                  o_io_control_b_bresp = self.axi_control.b.resp,
                                  o_io_control_b_bvalid = self.axi_control.b.valid,
                                  i_io_control_b_bready = self.axi_control.b.ready,
                                  i_io_control_ar_araddr = self.axi_control.ar.addr,
                                  i_io_control_ar_arprot = self.axi_control.ar.prot,
                                  i_io_control_ar_arvalid = self.axi_control.ar.valid,
                                  o_io_control_ar_arready = self.axi_control.ar.ready,
                                  o_io_control_r_rdata = self.axi_control.r.data,
                                  o_io_control_r_rresp = self.axi_control.r.resp,
                                  o_io_control_r_rvalid = self.axi_control.r.valid,
                                  i_io_control_r_rready = self.axi_control.r.ready,

                                  o_io_out_write_aw_awid = self.axi_write.aw.id,
                                  o_io_out_write_aw_awaddr = self.axi_write.aw.addr,
                                  o_io_out_write_aw_awlen = self.axi_write.aw.len,
                                  o_io_out_write_aw_awsize = self.axi_write.aw.size,
                                  o_io_out_write_aw_awburst = self.axi_write.aw.burst,
                                  o_io_out_write_aw_awlock = self.axi_write.aw.lock,
                                  o_io_out_write_aw_awcache = self.axi_write.aw.cache,
                                  o_io_out_write_aw_awprot = self.axi_write.aw.prot,
                                  o_io_out_write_aw_awqos = self.axi_write.aw.qos,
                                  o_io_out_write_aw_awvalid = self.axi_write.aw.valid,
                                  i_io_out_write_aw_awready = self.axi_write.aw.ready,
                                  o_io_out_write_w_wdata = self.axi_write.w.data,
                                  o_io_out_write_w_wstrb = self.axi_write.w.strb,
                                  o_io_out_write_w_wlast = self.axi_write.w.last,
                                  o_io_out_write_w_wvalid = self.axi_write.w.valid,
                                  i_io_out_write_w_wready = self.axi_write.w.ready,
                                  i_io_out_write_b_bid = self.axi_write.b.id,
                                  i_io_out_write_b_bresp = self.axi_write.b.resp,
                                  i_io_out_write_b_bvalid = self.axi_write.b.valid,
                                  o_io_out_write_b_bready= self.axi_write.b.ready,
                                  o_io_out_write_ar_arid = self.axi_write.ar.id,
                                  o_io_out_write_ar_araddr = self.axi_write.ar.addr,
                                  o_io_out_write_ar_arlen = self.axi_write.ar.len,
                                  o_io_out_write_ar_arsize = self.axi_write.ar.size,
                                  o_io_out_write_ar_arburst = self.axi_write.ar.burst,
                                  o_io_out_write_ar_arlock = self.axi_write.ar.lock,
                                  o_io_out_write_ar_arcache = self.axi_write.ar.cache,
                                  o_io_out_write_ar_arprot = self.axi_write.ar.prot,
                                  o_io_out_write_ar_arqos = self.axi_write.ar.qos,
                                  o_io_out_write_ar_arvalid = self.axi_write.ar.valid,
                                  i_io_out_write_ar_arready = self.axi_write.ar.ready,
                                  i_io_out_write_r_rid = self.axi_write.r.id,
                                  i_io_out_write_r_rdata = self.axi_write.r.data,
                                  i_io_out_write_r_rresp = self.axi_write.r.resp,
                                  i_io_out_write_r_rlast = self.axi_write.r.last,
                                  i_io_out_write_r_rvalid = self.axi_write.r.valid,
                                  o_io_out_write_r_rready = self.axi_write.r.ready,

                                  o_io_irq_dmaIn = self.irq_dmaIn,
                                  o_io_irq_dmaOut = self.irq_dmaOut
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
    def __init__(self, sys_clk_freq=int(75e6), **kwargs):
        base_address = 0x43c00000
        platform = antmicro_zynq_video_board.Platform()
        mem_map = {
            "csr":          0x43c5_0000 - base_address,
        }

        # SoCCore ----------------------------------------------------------------------------------
        kwargs["ident"] = "LiteX SoC on ZVB"
        kwargs["ident_version"]  = True
        SoCCore.__init__(self, platform, sys_clk_freq, **kwargs)

        # Since we correctly calcule modules' offsets we also need to decode them
        # this in the end impacts the sel signal on AXI
#        self.cpu.csr_decode = True
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

        self.submodules.AIG = AIG(self.platform)

        self.comb += self.AIG.axi_read.connect(self.cpu.add_axi_hp_slave())
        self.comb += self.AIG.axi_write.connect(self.cpu.add_axi_hp_slave())

        # Zynq7000 Integration ---------------------------------------------------------------------
        self.cpu.set_ps7_xci("zvb_xci/zynq_video_board_ps7.xci")

 #       axi_master = self.cpu.add_axi_gp_master()
#        self.submodules += AXILite2AXI(self.AIG.axi_control, axi_master)

        # add fastvdma
#        self.bus.add_slave("fastvdma_control_in", axi_master, SoCRegion(origin=0x43c0_0000 - base_address, size=0x00001000, cached=False))
#        self.bus.add_slave("fastvdma_control_out", axi_master, SoCRegion(origin=0x43c0_1000 - base_address, size=0x00001000, cached=False))

        self.bus.add_slave("AIG", self.AIG.axi_control, SoCRegion(origin=0x43c1_0000 - base_address, size=0x00001000, cached=False))

        wb_gp0 = wishbone.Interface()
        self.submodules += AXI2Wishbone(
            axi          = self.cpu.add_axi_gp_master(),
            wishbone     = wb_gp0,
            base_address = base_address)

        self.add_wb_master(wb_gp0)

        vdma_irq = Signal(16)
        self.comb += [
            vdma_irq[0].eq(self.AIG.irq_dmaIn[0]),
            vdma_irq[2].eq(self.AIG.irq_dmaOut[1]),
        ]
        self.cpu.add_ps7_irq(vdma_irq)

        # CRG --------------------------------------------------------------------------------------
        self.submodules.crg = _CRG(platform, sys_clk_freq, use_ps7_clk=True)

# Build --------------------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="LiteX SoC on Zybo Z7")
    parser.add_argument("--build", action="store_true", help="Build bitstream")
    builder_args(parser)
    soc_core_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    soc_args = soc_core_argdict(args)
    soc_args["cpu_type"] = "zynq7000"
    soc_args["sys_clk_freq"] = int(250000000)

    soc = BaseSoC(**soc_args)
    builder = Builder(soc, **builder_argdict(args))
    builder.build(**vivado_build_argdict(args), run=args.build)

if __name__ == "__main__":
    main()
