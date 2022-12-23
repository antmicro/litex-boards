module AcceleratorDecoder(
  input         clock,
  input         reset,
  output [31:0] io_controlIn_aw_awaddr,
  output [2:0]  io_controlIn_aw_awprot,
  output        io_controlIn_aw_awvalid,
  input         io_controlIn_aw_awready,
  output [31:0] io_controlIn_w_wdata,
  output [3:0]  io_controlIn_w_wstrb,
  output        io_controlIn_w_wvalid,
  input         io_controlIn_w_wready,
  input  [1:0]  io_controlIn_b_bresp,
  input         io_controlIn_b_bvalid,
  output        io_controlIn_b_bready,
  output [31:0] io_controlIn_ar_araddr,
  output [2:0]  io_controlIn_ar_arprot,
  output        io_controlIn_ar_arvalid,
  input         io_controlIn_ar_arready,
  input  [31:0] io_controlIn_r_rdata,
  input  [1:0]  io_controlIn_r_rresp,
  input         io_controlIn_r_rvalid,
  output        io_controlIn_r_rready,
  output [31:0] io_controlOut_aw_awaddr,
  output [2:0]  io_controlOut_aw_awprot,
  output        io_controlOut_aw_awvalid,
  input         io_controlOut_aw_awready,
  output [31:0] io_controlOut_w_wdata,
  output [3:0]  io_controlOut_w_wstrb,
  output        io_controlOut_w_wvalid,
  input         io_controlOut_w_wready,
  input  [1:0]  io_controlOut_b_bresp,
  input         io_controlOut_b_bvalid,
  output        io_controlOut_b_bready,
  output [31:0] io_controlOut_ar_araddr,
  output [2:0]  io_controlOut_ar_arprot,
  output        io_controlOut_ar_arvalid,
  input         io_controlOut_ar_arready,
  input  [31:0] io_controlOut_r_rdata,
  input  [1:0]  io_controlOut_r_rresp,
  input         io_controlOut_r_rvalid,
  output        io_controlOut_r_rready,
  output [31:0] io_controlAcc_aw_awaddr,
  output        io_controlAcc_aw_awvalid,
  input         io_controlAcc_aw_awready,
  output [31:0] io_controlAcc_w_wdata,
  output        io_controlAcc_w_wvalid,
  input         io_controlAcc_w_wready,
  input         io_controlAcc_b_bvalid,
  output        io_controlAcc_b_bready,
  output [31:0] io_controlAcc_ar_araddr,
  output        io_controlAcc_ar_arvalid,
  input         io_controlAcc_ar_arready,
  input  [31:0] io_controlAcc_r_rdata,
  input         io_controlAcc_r_rvalid,
  output        io_controlAcc_r_rready,
  input  [31:0] io_control_aw_awaddr,
  input  [2:0]  io_control_aw_awprot,
  input         io_control_aw_awvalid,
  output        io_control_aw_awready,
  input  [31:0] io_control_w_wdata,
  input  [3:0]  io_control_w_wstrb,
  input         io_control_w_wvalid,
  output        io_control_w_wready,
  output [1:0]  io_control_b_bresp,
  output        io_control_b_bvalid,
  input         io_control_b_bready,
  input  [31:0] io_control_ar_araddr,
  input  [2:0]  io_control_ar_arprot,
  input         io_control_ar_arvalid,
  output        io_control_ar_arready,
  output [31:0] io_control_r_rdata,
  output [1:0]  io_control_r_rresp,
  output        io_control_r_rvalid,
  input         io_control_r_rready
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] bus; // @[AcceleratorDecoder.scala 60:20]
  wire  _ctlIn_T_3 = io_control_aw_awaddr < 32'h40; // @[AcceleratorDecoder.scala 13:33]
  wire  _ctlIn_T_9 = io_control_ar_araddr < 32'h40; // @[AcceleratorDecoder.scala 13:33]
  wire  _ctlIn_T_11 = io_control_ar_arvalid & _ctlIn_T_9; // @[AcceleratorDecoder.scala 22:28]
  wire  _ctlIn_T_12 = io_control_aw_awvalid & _ctlIn_T_3 | _ctlIn_T_11; // @[AcceleratorDecoder.scala 21:84]
  wire  ctlIn = _ctlIn_T_12 | bus == 2'h1; // @[AcceleratorDecoder.scala 113:29]
  wire  _ctlOut_T_4 = io_control_aw_awaddr >= 32'h1000 & io_control_aw_awaddr < 32'h1040; // @[AcceleratorDecoder.scala 13:24]
  wire  _ctlOut_T_10 = io_control_ar_araddr >= 32'h1000 & io_control_ar_araddr < 32'h1040; // @[AcceleratorDecoder.scala 13:24]
  wire  _ctlOut_T_11 = io_control_ar_arvalid & _ctlOut_T_10; // @[AcceleratorDecoder.scala 27:28]
  wire  _ctlOut_T_12 = io_control_aw_awvalid & _ctlOut_T_4 | _ctlOut_T_11; // @[AcceleratorDecoder.scala 26:85]
  wire  ctlOut = _ctlOut_T_12 | bus == 2'h2; // @[AcceleratorDecoder.scala 114:31]
  wire  _ctlAcc_T_4 = io_control_aw_awaddr >= 32'h10000 & io_control_aw_awaddr < 32'h10040; // @[AcceleratorDecoder.scala 13:24]
  wire  _ctlAcc_T_10 = io_control_ar_araddr >= 32'h10000 & io_control_ar_araddr < 32'h10040; // @[AcceleratorDecoder.scala 13:24]
  wire  _ctlAcc_T_11 = io_control_ar_arvalid & _ctlAcc_T_10; // @[AcceleratorDecoder.scala 32:28]
  wire  _ctlAcc_T_12 = io_control_aw_awvalid & _ctlAcc_T_4 | _ctlAcc_T_11; // @[AcceleratorDecoder.scala 31:85]
  wire  ctlAcc = _ctlAcc_T_12 | bus == 2'h3; // @[AcceleratorDecoder.scala 115:31]
  wire [31:0] _GEN_0 = ctlAcc ? io_control_aw_awaddr : 32'h0; // @[AcceleratorDecoder.scala 127:22 128:19 98:27]
  wire  _GEN_2 = ctlAcc & io_control_aw_awvalid; // @[AcceleratorDecoder.scala 127:22 128:19 97:28]
  wire  _GEN_3 = ctlAcc & io_controlAcc_aw_awready; // @[AcceleratorDecoder.scala 127:22 128:19 64:25]
  wire [31:0] _GEN_4 = ctlAcc ? io_control_w_wdata : 32'h0; // @[AcceleratorDecoder.scala 127:22 128:19 101:25]
  wire  _GEN_6 = ctlAcc & io_control_w_wvalid; // @[AcceleratorDecoder.scala 127:22 128:19 100:26]
  wire  _GEN_7 = ctlAcc & io_controlAcc_w_wready; // @[AcceleratorDecoder.scala 127:22 128:19 65:23]
  wire  _GEN_9 = ctlAcc & io_controlAcc_b_bvalid; // @[AcceleratorDecoder.scala 127:22 128:19 66:23]
  wire  _GEN_10 = ctlAcc & io_control_b_bready; // @[AcceleratorDecoder.scala 127:22 128:19 103:26]
  wire [31:0] _GEN_11 = ctlAcc ? io_control_ar_araddr : 32'h0; // @[AcceleratorDecoder.scala 127:22 128:19 105:27]
  wire  _GEN_13 = ctlAcc & io_control_ar_arvalid; // @[AcceleratorDecoder.scala 127:22 128:19 104:28]
  wire  _GEN_14 = ctlAcc & io_controlAcc_ar_arready; // @[AcceleratorDecoder.scala 127:22 128:19 68:25]
  wire [31:0] _GEN_15 = ctlAcc ? io_controlAcc_r_rdata : 32'h0; // @[AcceleratorDecoder.scala 127:22 128:19 69:22]
  wire  _GEN_17 = ctlAcc & io_controlAcc_r_rvalid; // @[AcceleratorDecoder.scala 127:22 128:19 70:23]
  wire  _GEN_18 = ctlAcc & io_control_r_rready; // @[AcceleratorDecoder.scala 127:22 128:19 107:26]
  wire [1:0] _GEN_19 = ctlAcc ? 2'h3 : bus; // @[AcceleratorDecoder.scala 127:22 131:9 60:20]
  wire [31:0] _GEN_20 = ctlOut ? io_control_aw_awaddr : 32'h0; // @[AcceleratorDecoder.scala 122:22 123:19 86:27]
  wire [2:0] _GEN_21 = ctlOut ? io_control_aw_awprot : 3'h0; // @[AcceleratorDecoder.scala 122:22 123:19 87:27]
  wire  _GEN_22 = ctlOut & io_control_aw_awvalid; // @[AcceleratorDecoder.scala 122:22 123:19 85:28]
  wire  _GEN_23 = ctlOut ? io_controlOut_aw_awready : _GEN_3; // @[AcceleratorDecoder.scala 122:22 123:19]
  wire [31:0] _GEN_24 = ctlOut ? io_control_w_wdata : 32'h0; // @[AcceleratorDecoder.scala 122:22 123:19 89:25]
  wire [3:0] _GEN_25 = ctlOut ? io_control_w_wstrb : 4'h0; // @[AcceleratorDecoder.scala 122:22 123:19 90:25]
  wire  _GEN_26 = ctlOut & io_control_w_wvalid; // @[AcceleratorDecoder.scala 122:22 123:19 88:26]
  wire  _GEN_27 = ctlOut ? io_controlOut_w_wready : _GEN_7; // @[AcceleratorDecoder.scala 122:22 123:19]
  wire [1:0] _GEN_28 = ctlOut ? io_controlOut_b_bresp : 2'h0; // @[AcceleratorDecoder.scala 122:22 123:19]
  wire  _GEN_29 = ctlOut ? io_controlOut_b_bvalid : _GEN_9; // @[AcceleratorDecoder.scala 122:22 123:19]
  wire  _GEN_30 = ctlOut & io_control_b_bready; // @[AcceleratorDecoder.scala 122:22 123:19 91:26]
  wire [31:0] _GEN_31 = ctlOut ? io_control_ar_araddr : 32'h0; // @[AcceleratorDecoder.scala 122:22 123:19 93:27]
  wire [2:0] _GEN_32 = ctlOut ? io_control_ar_arprot : 3'h0; // @[AcceleratorDecoder.scala 122:22 123:19 94:27]
  wire  _GEN_33 = ctlOut & io_control_ar_arvalid; // @[AcceleratorDecoder.scala 122:22 123:19 92:28]
  wire  _GEN_34 = ctlOut ? io_controlOut_ar_arready : _GEN_14; // @[AcceleratorDecoder.scala 122:22 123:19]
  wire [31:0] _GEN_35 = ctlOut ? io_controlOut_r_rdata : _GEN_15; // @[AcceleratorDecoder.scala 122:22 123:19]
  wire [1:0] _GEN_36 = ctlOut ? io_controlOut_r_rresp : 2'h0; // @[AcceleratorDecoder.scala 122:22 123:19]
  wire  _GEN_37 = ctlOut ? io_controlOut_r_rvalid : _GEN_17; // @[AcceleratorDecoder.scala 122:22 123:19]
  wire  _GEN_38 = ctlOut & io_control_r_rready; // @[AcceleratorDecoder.scala 122:22 123:19 95:26]
  wire [1:0] _GEN_39 = ctlOut ? 2'h2 : _GEN_19; // @[AcceleratorDecoder.scala 122:22 126:9]
  wire [31:0] _GEN_40 = ctlOut ? 32'h0 : _GEN_0; // @[AcceleratorDecoder.scala 122:22 98:27]
  wire  _GEN_42 = ctlOut ? 1'h0 : _GEN_2; // @[AcceleratorDecoder.scala 122:22 97:28]
  wire [31:0] _GEN_43 = ctlOut ? 32'h0 : _GEN_4; // @[AcceleratorDecoder.scala 122:22 101:25]
  wire  _GEN_45 = ctlOut ? 1'h0 : _GEN_6; // @[AcceleratorDecoder.scala 122:22 100:26]
  wire  _GEN_46 = ctlOut ? 1'h0 : _GEN_10; // @[AcceleratorDecoder.scala 122:22 103:26]
  wire [31:0] _GEN_47 = ctlOut ? 32'h0 : _GEN_11; // @[AcceleratorDecoder.scala 122:22 105:27]
  wire  _GEN_49 = ctlOut ? 1'h0 : _GEN_13; // @[AcceleratorDecoder.scala 122:22 104:28]
  wire  _GEN_50 = ctlOut ? 1'h0 : _GEN_18; // @[AcceleratorDecoder.scala 122:22 107:26]
  wire [1:0] _GEN_70 = ctlIn ? 2'h1 : _GEN_39; // @[AcceleratorDecoder.scala 117:15 121:9]
  wire  _T_3 = io_controlIn_b_bready & io_controlIn_b_bvalid | io_controlIn_r_rready & io_controlIn_r_rvalid; // @[AcceleratorDecoder.scala 17:50]
  wire  _T_7 = io_controlOut_b_bready & io_controlOut_b_bvalid | io_controlOut_r_rready & io_controlOut_r_rvalid; // @[AcceleratorDecoder.scala 17:50]
  wire  _T_11 = io_controlAcc_b_bready & io_controlAcc_b_bvalid | io_controlAcc_r_rready & io_controlAcc_r_rvalid; // @[AcceleratorDecoder.scala 17:50]
  wire [1:0] _GEN_95 = _T_11 ? 2'h0 : _GEN_70; // @[AcceleratorDecoder.scala 146:34 147:13]
  assign io_controlIn_aw_awaddr = ctlIn ? io_control_aw_awaddr : 32'h0; // @[AcceleratorDecoder.scala 117:15 118:18 74:26]
  assign io_controlIn_aw_awprot = ctlIn ? io_control_aw_awprot : 3'h0; // @[AcceleratorDecoder.scala 117:15 118:18 75:26]
  assign io_controlIn_aw_awvalid = ctlIn & io_control_aw_awvalid; // @[AcceleratorDecoder.scala 117:15 118:18 73:27]
  assign io_controlIn_w_wdata = ctlIn ? io_control_w_wdata : 32'h0; // @[AcceleratorDecoder.scala 117:15 118:18 77:24]
  assign io_controlIn_w_wstrb = ctlIn ? io_control_w_wstrb : 4'h0; // @[AcceleratorDecoder.scala 117:15 118:18 78:24]
  assign io_controlIn_w_wvalid = ctlIn & io_control_w_wvalid; // @[AcceleratorDecoder.scala 117:15 118:18 76:25]
  assign io_controlIn_b_bready = ctlIn & io_control_b_bready; // @[AcceleratorDecoder.scala 117:15 118:18 79:25]
  assign io_controlIn_ar_araddr = ctlIn ? io_control_ar_araddr : 32'h0; // @[AcceleratorDecoder.scala 117:15 118:18 81:26]
  assign io_controlIn_ar_arprot = ctlIn ? io_control_ar_arprot : 3'h0; // @[AcceleratorDecoder.scala 117:15 118:18 82:26]
  assign io_controlIn_ar_arvalid = ctlIn & io_control_ar_arvalid; // @[AcceleratorDecoder.scala 117:15 118:18 80:27]
  assign io_controlIn_r_rready = ctlIn & io_control_r_rready; // @[AcceleratorDecoder.scala 117:15 118:18 83:25]
  assign io_controlOut_aw_awaddr = ctlIn ? 32'h0 : _GEN_20; // @[AcceleratorDecoder.scala 117:15 86:27]
  assign io_controlOut_aw_awprot = ctlIn ? 3'h0 : _GEN_21; // @[AcceleratorDecoder.scala 117:15 87:27]
  assign io_controlOut_aw_awvalid = ctlIn ? 1'h0 : _GEN_22; // @[AcceleratorDecoder.scala 117:15 85:28]
  assign io_controlOut_w_wdata = ctlIn ? 32'h0 : _GEN_24; // @[AcceleratorDecoder.scala 117:15 89:25]
  assign io_controlOut_w_wstrb = ctlIn ? 4'h0 : _GEN_25; // @[AcceleratorDecoder.scala 117:15 90:25]
  assign io_controlOut_w_wvalid = ctlIn ? 1'h0 : _GEN_26; // @[AcceleratorDecoder.scala 117:15 88:26]
  assign io_controlOut_b_bready = ctlIn ? 1'h0 : _GEN_30; // @[AcceleratorDecoder.scala 117:15 91:26]
  assign io_controlOut_ar_araddr = ctlIn ? 32'h0 : _GEN_31; // @[AcceleratorDecoder.scala 117:15 93:27]
  assign io_controlOut_ar_arprot = ctlIn ? 3'h0 : _GEN_32; // @[AcceleratorDecoder.scala 117:15 94:27]
  assign io_controlOut_ar_arvalid = ctlIn ? 1'h0 : _GEN_33; // @[AcceleratorDecoder.scala 117:15 92:28]
  assign io_controlOut_r_rready = ctlIn ? 1'h0 : _GEN_38; // @[AcceleratorDecoder.scala 117:15 95:26]
  assign io_controlAcc_aw_awaddr = ctlIn ? 32'h0 : _GEN_40; // @[AcceleratorDecoder.scala 117:15 98:27]
  assign io_controlAcc_aw_awvalid = ctlIn ? 1'h0 : _GEN_42; // @[AcceleratorDecoder.scala 117:15 97:28]
  assign io_controlAcc_w_wdata = ctlIn ? 32'h0 : _GEN_43; // @[AcceleratorDecoder.scala 117:15 101:25]
  assign io_controlAcc_w_wvalid = ctlIn ? 1'h0 : _GEN_45; // @[AcceleratorDecoder.scala 117:15 100:26]
  assign io_controlAcc_b_bready = ctlIn ? 1'h0 : _GEN_46; // @[AcceleratorDecoder.scala 117:15 103:26]
  assign io_controlAcc_ar_araddr = ctlIn ? 32'h0 : _GEN_47; // @[AcceleratorDecoder.scala 117:15 105:27]
  assign io_controlAcc_ar_arvalid = ctlIn ? 1'h0 : _GEN_49; // @[AcceleratorDecoder.scala 117:15 104:28]
  assign io_controlAcc_r_rready = ctlIn ? 1'h0 : _GEN_50; // @[AcceleratorDecoder.scala 117:15 107:26]
  assign io_control_aw_awready = ctlIn ? io_controlIn_aw_awready : _GEN_23; // @[AcceleratorDecoder.scala 117:15 118:18]
  assign io_control_w_wready = ctlIn ? io_controlIn_w_wready : _GEN_27; // @[AcceleratorDecoder.scala 117:15 118:18]
  assign io_control_b_bresp = ctlIn ? io_controlIn_b_bresp : _GEN_28; // @[AcceleratorDecoder.scala 117:15 118:18]
  assign io_control_b_bvalid = ctlIn ? io_controlIn_b_bvalid : _GEN_29; // @[AcceleratorDecoder.scala 117:15 118:18]
  assign io_control_ar_arready = ctlIn ? io_controlIn_ar_arready : _GEN_34; // @[AcceleratorDecoder.scala 117:15 118:18]
  assign io_control_r_rdata = ctlIn ? io_controlIn_r_rdata : _GEN_35; // @[AcceleratorDecoder.scala 117:15 118:18]
  assign io_control_r_rresp = ctlIn ? io_controlIn_r_rresp : _GEN_36; // @[AcceleratorDecoder.scala 117:15 118:18]
  assign io_control_r_rvalid = ctlIn ? io_controlIn_r_rvalid : _GEN_37; // @[AcceleratorDecoder.scala 117:15 118:18]
  always @(posedge clock) begin
    if (reset) begin // @[AcceleratorDecoder.scala 60:20]
      bus <= 2'h0; // @[AcceleratorDecoder.scala 60:20]
    end else if (2'h1 == bus) begin // @[AcceleratorDecoder.scala 134:15]
      if (_T_3) begin // @[AcceleratorDecoder.scala 136:34]
        bus <= 2'h0; // @[AcceleratorDecoder.scala 137:13]
      end else begin
        bus <= _GEN_70;
      end
    end else if (2'h2 == bus) begin // @[AcceleratorDecoder.scala 134:15]
      if (_T_7) begin // @[AcceleratorDecoder.scala 141:34]
        bus <= 2'h0; // @[AcceleratorDecoder.scala 142:13]
      end else begin
        bus <= _GEN_70;
      end
    end else if (2'h3 == bus) begin // @[AcceleratorDecoder.scala 134:15]
      bus <= _GEN_95;
    end else begin
      bus <= _GEN_70;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  bus = _RAND_0[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AXI4LiteCustomCSR(
  input         clock,
  input         reset,
  input  [7:0]  io_ctl_aw_awaddr,
  input         io_ctl_aw_awvalid,
  output        io_ctl_aw_awready,
  input  [31:0] io_ctl_w_wdata,
  input         io_ctl_w_wvalid,
  output        io_ctl_w_wready,
  output        io_ctl_b_bvalid,
  input         io_ctl_b_bready,
  input  [7:0]  io_ctl_ar_araddr,
  input         io_ctl_ar_arvalid,
  output        io_ctl_ar_arready,
  output [31:0] io_ctl_r_rdata,
  output        io_ctl_r_rvalid,
  input         io_ctl_r_rready,
  input         io_bus_ready,
  output [5:0]  io_bus_addr,
  output        io_bus_reg_read,
  output [31:0] io_bus_reg_dataOut,
  output        io_bus_reg_write,
  input  [31:0] io_bus_reg_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] state; // @[AXI4LiteCustomCSR.scala 17:22]
  reg  awready; // @[AXI4LiteCustomCSR.scala 19:24]
  reg  wready; // @[AXI4LiteCustomCSR.scala 20:23]
  reg  bvalid; // @[AXI4LiteCustomCSR.scala 21:23]
  reg  arready; // @[AXI4LiteCustomCSR.scala 24:24]
  reg  rvalid; // @[AXI4LiteCustomCSR.scala 25:23]
  reg [7:0] addr; // @[AXI4LiteCustomCSR.scala 28:21]
  wire  _GEN_2 = io_ctl_ar_arvalid | arready; // @[AXI4LiteCustomCSR.scala 53:36 56:17 24:24]
  wire  _GEN_5 = io_ctl_aw_awvalid | awready; // @[AXI4LiteCustomCSR.scala 48:30 51:17 19:24]
  wire  _GEN_9 = io_ctl_ar_arvalid & arready | rvalid; // @[AXI4LiteCustomCSR.scala 60:41 63:16 25:23]
  wire [2:0] _GEN_10 = io_ctl_r_rready & io_ctl_r_rvalid ? 3'h0 : state; // @[AXI4LiteCustomCSR.scala 67:47 68:15 17:22]
  wire  _GEN_11 = io_ctl_r_rready & io_ctl_r_rvalid ? 1'h0 : rvalid; // @[AXI4LiteCustomCSR.scala 67:47 69:16 25:23]
  wire [2:0] _GEN_12 = io_ctl_aw_awvalid & awready ? 3'h4 : state; // @[AXI4LiteCustomCSR.scala 73:41 74:15 17:22]
  wire  _GEN_13 = io_ctl_aw_awvalid & awready ? 1'h0 : awready; // @[AXI4LiteCustomCSR.scala 73:41 75:17 19:24]
  wire  _GEN_14 = io_ctl_aw_awvalid & awready | wready; // @[AXI4LiteCustomCSR.scala 73:41 76:16 20:23]
  wire [2:0] _GEN_15 = io_ctl_w_wvalid & io_ctl_w_wready ? 3'h5 : state; // @[AXI4LiteCustomCSR.scala 80:47 81:15 17:22]
  wire  _GEN_16 = io_ctl_w_wvalid & io_ctl_w_wready ? 1'h0 : wready; // @[AXI4LiteCustomCSR.scala 80:47 82:16 20:23]
  wire  _GEN_17 = io_ctl_w_wvalid & io_ctl_w_wready | bvalid; // @[AXI4LiteCustomCSR.scala 80:47 83:16 21:23]
  wire [2:0] _GEN_18 = io_ctl_b_bready & bvalid ? 3'h0 : state; // @[AXI4LiteCustomCSR.scala 87:38 88:15 17:22]
  wire  _GEN_19 = io_ctl_b_bready & bvalid ? 1'h0 : bvalid; // @[AXI4LiteCustomCSR.scala 87:38 89:16 21:23]
  wire [2:0] _GEN_20 = 3'h5 == state ? _GEN_18 : state; // @[AXI4LiteCustomCSR.scala 46:16 17:22]
  wire  _GEN_21 = 3'h5 == state ? _GEN_19 : bvalid; // @[AXI4LiteCustomCSR.scala 46:16 21:23]
  wire [2:0] _GEN_22 = 3'h4 == state ? _GEN_15 : _GEN_20; // @[AXI4LiteCustomCSR.scala 46:16]
  wire  _GEN_23 = 3'h4 == state ? _GEN_16 : wready; // @[AXI4LiteCustomCSR.scala 46:16 20:23]
  wire  _GEN_24 = 3'h4 == state ? _GEN_17 : _GEN_21; // @[AXI4LiteCustomCSR.scala 46:16]
  wire [2:0] _GEN_25 = 3'h3 == state ? _GEN_12 : _GEN_22; // @[AXI4LiteCustomCSR.scala 46:16]
  wire  _GEN_26 = 3'h3 == state ? _GEN_13 : awready; // @[AXI4LiteCustomCSR.scala 46:16 19:24]
  wire  _GEN_27 = 3'h3 == state ? _GEN_14 : _GEN_23; // @[AXI4LiteCustomCSR.scala 46:16]
  wire  _GEN_28 = 3'h3 == state ? bvalid : _GEN_24; // @[AXI4LiteCustomCSR.scala 46:16 21:23]
  assign io_ctl_aw_awready = awready; // @[AXI4LiteCustomCSR.scala 33:21]
  assign io_ctl_w_wready = wready & io_bus_ready; // @[AXI4LiteCustomCSR.scala 34:29]
  assign io_ctl_b_bvalid = bvalid; // @[AXI4LiteCustomCSR.scala 35:19]
  assign io_ctl_ar_arready = arready; // @[AXI4LiteCustomCSR.scala 38:21]
  assign io_ctl_r_rdata = io_bus_reg_dataIn; // @[AXI4LiteCustomCSR.scala 30:18]
  assign io_ctl_r_rvalid = rvalid & io_bus_ready; // @[AXI4LiteCustomCSR.scala 39:29]
  assign io_bus_addr = addr[5:0]; // @[AXI4LiteCustomCSR.scala 44:15]
  assign io_bus_reg_read = io_ctl_r_rready & rvalid; // @[AXI4LiteCustomCSR.scala 42:38]
  assign io_bus_reg_dataOut = io_ctl_w_wdata; // @[AXI4LiteCustomCSR.scala 31:22]
  assign io_bus_reg_write = io_ctl_w_wvalid & wready; // @[AXI4LiteCustomCSR.scala 43:39]
  always @(posedge clock) begin
    if (reset) begin // @[AXI4LiteCustomCSR.scala 17:22]
      state <= 3'h0; // @[AXI4LiteCustomCSR.scala 17:22]
    end else if (3'h0 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (io_ctl_aw_awvalid) begin // @[AXI4LiteCustomCSR.scala 48:30]
        state <= 3'h3; // @[AXI4LiteCustomCSR.scala 49:15]
      end else if (io_ctl_ar_arvalid) begin // @[AXI4LiteCustomCSR.scala 53:36]
        state <= 3'h1; // @[AXI4LiteCustomCSR.scala 54:15]
      end
    end else if (3'h1 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (io_ctl_ar_arvalid & arready) begin // @[AXI4LiteCustomCSR.scala 60:41]
        state <= 3'h2; // @[AXI4LiteCustomCSR.scala 61:15]
      end
    end else if (3'h2 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
      state <= _GEN_10;
    end else begin
      state <= _GEN_25;
    end
    if (reset) begin // @[AXI4LiteCustomCSR.scala 19:24]
      awready <= 1'h0; // @[AXI4LiteCustomCSR.scala 19:24]
    end else if (3'h0 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
      awready <= _GEN_5;
    end else if (!(3'h1 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (!(3'h2 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
        awready <= _GEN_26;
      end
    end
    if (reset) begin // @[AXI4LiteCustomCSR.scala 20:23]
      wready <= 1'h0; // @[AXI4LiteCustomCSR.scala 20:23]
    end else if (!(3'h0 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (!(3'h1 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
        if (!(3'h2 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
          wready <= _GEN_27;
        end
      end
    end
    if (reset) begin // @[AXI4LiteCustomCSR.scala 21:23]
      bvalid <= 1'h0; // @[AXI4LiteCustomCSR.scala 21:23]
    end else if (!(3'h0 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (!(3'h1 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
        if (!(3'h2 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
          bvalid <= _GEN_28;
        end
      end
    end
    if (reset) begin // @[AXI4LiteCustomCSR.scala 24:24]
      arready <= 1'h0; // @[AXI4LiteCustomCSR.scala 24:24]
    end else if (3'h0 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (!(io_ctl_aw_awvalid)) begin // @[AXI4LiteCustomCSR.scala 48:30]
        arready <= _GEN_2;
      end
    end else if (3'h1 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (io_ctl_ar_arvalid & arready) begin // @[AXI4LiteCustomCSR.scala 60:41]
        arready <= 1'h0; // @[AXI4LiteCustomCSR.scala 62:17]
      end
    end
    if (reset) begin // @[AXI4LiteCustomCSR.scala 25:23]
      rvalid <= 1'h0; // @[AXI4LiteCustomCSR.scala 25:23]
    end else if (!(3'h0 == state)) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (3'h1 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
        rvalid <= _GEN_9;
      end else if (3'h2 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
        rvalid <= _GEN_11;
      end
    end
    if (reset) begin // @[AXI4LiteCustomCSR.scala 28:21]
      addr <= 8'h0; // @[AXI4LiteCustomCSR.scala 28:21]
    end else if (3'h0 == state) begin // @[AXI4LiteCustomCSR.scala 46:16]
      if (io_ctl_aw_awvalid) begin // @[AXI4LiteCustomCSR.scala 48:30]
        addr <= {{2'd0}, io_ctl_aw_awaddr[7:2]}; // @[AXI4LiteCustomCSR.scala 50:14]
      end else if (io_ctl_ar_arvalid) begin // @[AXI4LiteCustomCSR.scala 53:36]
        addr <= {{2'd0}, io_ctl_ar_araddr[7:2]}; // @[AXI4LiteCustomCSR.scala 55:14]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  awready = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  wready = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  bvalid = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  arready = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  rvalid = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  addr = _RAND_6[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister(
  input         clock,
  input         reset,
  input  [31:0] io_dataOut,
  input         io_write,
  output [31:0] io_dataIn,
  output        fields_bgr,
  output [1:0]  fields_pattern,
  output [2:0]  fields_algorithm
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSRs.scala 14:24]
  assign io_dataIn = storage; // @[CSRs.scala 22:13]
  assign fields_bgr = storage[6]; // @[CSRs.scala 16:29]
  assign fields_pattern = storage[5:4]; // @[CSRs.scala 16:29]
  assign fields_algorithm = storage[2:0]; // @[CSRs.scala 16:29]
  always @(posedge clock) begin
    if (reset) begin // @[CSRs.scala 14:24]
      storage <= 32'h0; // @[CSRs.scala 14:24]
    end else if (io_write) begin // @[CSRs.scala 18:18]
      storage <= io_dataOut; // @[CSRs.scala 19:13]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StorageRegister_1(
  input         clock,
  input         reset,
  input  [31:0] io_dataOut,
  input         io_write,
  output [31:0] io_dataIn,
  output [12:0] fields_rows,
  output [12:0] fields_cols
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] storage; // @[CSRs.scala 14:24]
  assign io_dataIn = storage; // @[CSRs.scala 22:13]
  assign fields_rows = storage[25:13]; // @[CSRs.scala 16:29]
  assign fields_cols = storage[12:0]; // @[CSRs.scala 16:29]
  always @(posedge clock) begin
    if (reset) begin // @[CSRs.scala 14:24]
      storage <= 32'h0; // @[CSRs.scala 14:24]
    end else if (io_write) begin // @[CSRs.scala 18:18]
      storage <= io_dataOut; // @[CSRs.scala 19:13]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  storage = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CustomCSRWrapper(
  input         clock,
  input         reset,
  output        io_bus_ready,
  input  [5:0]  io_bus_addr,
  input         io_bus_reg_read,
  input  [31:0] io_bus_reg_dataOut,
  input         io_bus_reg_write,
  output [31:0] io_bus_reg_dataIn,
  output [2:0]  io_algorithm,
  output [1:0]  io_pattern,
  output        io_bgr,
  output [12:0] io_cols,
  output [12:0] io_rows
);
  wire  fpgaIsp_clock; // @[CSRMap.scala 41:26]
  wire  fpgaIsp_reset; // @[CSRMap.scala 41:26]
  wire [31:0] fpgaIsp_io_dataOut; // @[CSRMap.scala 41:26]
  wire  fpgaIsp_io_write; // @[CSRMap.scala 41:26]
  wire [31:0] fpgaIsp_io_dataIn; // @[CSRMap.scala 41:26]
  wire  fpgaIsp_fields_bgr; // @[CSRMap.scala 41:26]
  wire [1:0] fpgaIsp_fields_pattern; // @[CSRMap.scala 41:26]
  wire [2:0] fpgaIsp_fields_algorithm; // @[CSRMap.scala 41:26]
  wire  fpgaIspIm_clock; // @[CSRMap.scala 42:26]
  wire  fpgaIspIm_reset; // @[CSRMap.scala 42:26]
  wire [31:0] fpgaIspIm_io_dataOut; // @[CSRMap.scala 42:26]
  wire  fpgaIspIm_io_write; // @[CSRMap.scala 42:26]
  wire [31:0] fpgaIspIm_io_dataIn; // @[CSRMap.scala 42:26]
  wire [12:0] fpgaIspIm_fields_rows; // @[CSRMap.scala 42:26]
  wire [12:0] fpgaIspIm_fields_cols; // @[CSRMap.scala 42:26]
  wire [14:0] _GEN_0 = {{9'd0}, io_bus_addr}; // @[CustomCSRWrapper.scala 56:23]
  wire [14:0] _T_1 = _GEN_0 + 15'h4000; // @[CustomCSRWrapper.scala 56:23]
  wire [31:0] _GEN_3 = _T_1 == 15'h4001 ? fpgaIspIm_io_dataIn : 32'hdead; // @[CustomCSRWrapper.scala 56:74 57:14 37:21]
  StorageRegister fpgaIsp ( // @[CSRMap.scala 41:26]
    .clock(fpgaIsp_clock),
    .reset(fpgaIsp_reset),
    .io_dataOut(fpgaIsp_io_dataOut),
    .io_write(fpgaIsp_io_write),
    .io_dataIn(fpgaIsp_io_dataIn),
    .fields_bgr(fpgaIsp_fields_bgr),
    .fields_pattern(fpgaIsp_fields_pattern),
    .fields_algorithm(fpgaIsp_fields_algorithm)
  );
  StorageRegister_1 fpgaIspIm ( // @[CSRMap.scala 42:26]
    .clock(fpgaIspIm_clock),
    .reset(fpgaIspIm_reset),
    .io_dataOut(fpgaIspIm_io_dataOut),
    .io_write(fpgaIspIm_io_write),
    .io_dataIn(fpgaIspIm_io_dataIn),
    .fields_rows(fpgaIspIm_fields_rows),
    .fields_cols(fpgaIspIm_fields_cols)
  );
  assign io_bus_ready = io_bus_reg_write | io_bus_reg_read; // @[CustomCSRWrapper.scala 36:36]
  assign io_bus_reg_dataIn = _T_1 == 15'h4000 ? fpgaIsp_io_dataIn : _GEN_3; // @[CustomCSRWrapper.scala 56:74 57:14]
  assign io_algorithm = fpgaIsp_fields_algorithm; // @[CustomCSRWrapper.scala 21:26 43:28]
  assign io_pattern = fpgaIsp_fields_pattern; // @[CustomCSRWrapper.scala 22:24 46:26]
  assign io_bgr = fpgaIsp_fields_bgr; // @[CustomCSRWrapper.scala 23:20 47:22]
  assign io_cols = fpgaIspIm_fields_cols; // @[CustomCSRWrapper.scala 24:21 51:25]
  assign io_rows = fpgaIspIm_fields_rows; // @[CustomCSRWrapper.scala 25:21 52:25]
  assign fpgaIsp_clock = clock;
  assign fpgaIsp_reset = reset;
  assign fpgaIsp_io_dataOut = _T_1 == 15'h4000 ? io_bus_reg_dataOut : 32'h0; // @[CustomCSRWrapper.scala 56:74 57:14 61:22]
  assign fpgaIsp_io_write = _T_1 == 15'h4000 & io_bus_reg_write; // @[CustomCSRWrapper.scala 56:74 57:14 59:20]
  assign fpgaIspIm_clock = clock;
  assign fpgaIspIm_reset = reset;
  assign fpgaIspIm_io_dataOut = _T_1 == 15'h4001 ? io_bus_reg_dataOut : 32'h0; // @[CustomCSRWrapper.scala 56:74 57:14 61:22]
  assign fpgaIspIm_io_write = _T_1 == 15'h4001 & io_bus_reg_write; // @[CustomCSRWrapper.scala 56:74 57:14 59:20]
endmodule
module AcceleratorTop(
  input         clock,
  input         reset,
  output [3:0]  io_in_read_aw_awid,
  output [31:0] io_in_read_aw_awaddr,
  output [7:0]  io_in_read_aw_awlen,
  output [2:0]  io_in_read_aw_awsize,
  output [1:0]  io_in_read_aw_awburst,
  output        io_in_read_aw_awlock,
  output [3:0]  io_in_read_aw_awcache,
  output [2:0]  io_in_read_aw_awprot,
  output [3:0]  io_in_read_aw_awqos,
  output        io_in_read_aw_awvalid,
  input         io_in_read_aw_awready,
  output [31:0] io_in_read_w_wdata,
  output [3:0]  io_in_read_w_wstrb,
  output        io_in_read_w_wlast,
  output        io_in_read_w_wvalid,
  input         io_in_read_w_wready,
  input  [3:0]  io_in_read_b_bid,
  input  [1:0]  io_in_read_b_bresp,
  input         io_in_read_b_bvalid,
  output        io_in_read_b_bready,
  output [3:0]  io_in_read_ar_arid,
  output [31:0] io_in_read_ar_araddr,
  output [7:0]  io_in_read_ar_arlen,
  output [2:0]  io_in_read_ar_arsize,
  output [1:0]  io_in_read_ar_arburst,
  output        io_in_read_ar_arlock,
  output [3:0]  io_in_read_ar_arcache,
  output [2:0]  io_in_read_ar_arprot,
  output [3:0]  io_in_read_ar_arqos,
  output        io_in_read_ar_arvalid,
  input         io_in_read_ar_arready,
  input  [3:0]  io_in_read_r_rid,
  input  [31:0] io_in_read_r_rdata,
  input  [1:0]  io_in_read_r_rresp,
  input         io_in_read_r_rlast,
  input         io_in_read_r_rvalid,
  output        io_in_read_r_rready,
  input  [31:0] io_control_aw_awaddr,
  input  [2:0]  io_control_aw_awprot,
  input         io_control_aw_awvalid,
  output        io_control_aw_awready,
  input  [31:0] io_control_w_wdata,
  input  [3:0]  io_control_w_wstrb,
  input         io_control_w_wvalid,
  output        io_control_w_wready,
  output [1:0]  io_control_b_bresp,
  output        io_control_b_bvalid,
  input         io_control_b_bready,
  input  [31:0] io_control_ar_araddr,
  input  [2:0]  io_control_ar_arprot,
  input         io_control_ar_arvalid,
  output        io_control_ar_arready,
  output [31:0] io_control_r_rdata,
  output [1:0]  io_control_r_rresp,
  output        io_control_r_rvalid,
  input         io_control_r_rready,
  output [3:0]  io_out_write_aw_awid,
  output [31:0] io_out_write_aw_awaddr,
  output [7:0]  io_out_write_aw_awlen,
  output [2:0]  io_out_write_aw_awsize,
  output [1:0]  io_out_write_aw_awburst,
  output        io_out_write_aw_awlock,
  output [3:0]  io_out_write_aw_awcache,
  output [2:0]  io_out_write_aw_awprot,
  output [3:0]  io_out_write_aw_awqos,
  output        io_out_write_aw_awvalid,
  input         io_out_write_aw_awready,
  output [31:0] io_out_write_w_wdata,
  output [3:0]  io_out_write_w_wstrb,
  output        io_out_write_w_wlast,
  output        io_out_write_w_wvalid,
  input         io_out_write_w_wready,
  input  [3:0]  io_out_write_b_bid,
  input  [1:0]  io_out_write_b_bresp,
  input         io_out_write_b_bvalid,
  output        io_out_write_b_bready,
  output [3:0]  io_out_write_ar_arid,
  output [31:0] io_out_write_ar_araddr,
  output [7:0]  io_out_write_ar_arlen,
  output [2:0]  io_out_write_ar_arsize,
  output [1:0]  io_out_write_ar_arburst,
  output        io_out_write_ar_arlock,
  output [3:0]  io_out_write_ar_arcache,
  output [2:0]  io_out_write_ar_arprot,
  output [3:0]  io_out_write_ar_arqos,
  output        io_out_write_ar_arvalid,
  input         io_out_write_ar_arready,
  input  [3:0]  io_out_write_r_rid,
  input  [31:0] io_out_write_r_rdata,
  input  [1:0]  io_out_write_r_rresp,
  input         io_out_write_r_rlast,
  input         io_out_write_r_rvalid,
  output        io_out_write_r_rready,
  output [1:0]  io_irq_dmaIn,
  output [1:0]  io_irq_dmaOut
);
  wire  dmaIn_clock; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_reset; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_control_aw_awaddr; // @[AcceleratorTop.scala 37:23]
  wire [2:0] dmaIn_io_control_aw_awprot; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_aw_awvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_aw_awready; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_control_w_wdata; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_control_w_wstrb; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_w_wvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_w_wready; // @[AcceleratorTop.scala 37:23]
  wire [1:0] dmaIn_io_control_b_bresp; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_b_bvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_b_bready; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_control_ar_araddr; // @[AcceleratorTop.scala 37:23]
  wire [2:0] dmaIn_io_control_ar_arprot; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_ar_arvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_ar_arready; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_control_r_rdata; // @[AcceleratorTop.scala 37:23]
  wire [1:0] dmaIn_io_control_r_rresp; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_r_rvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_control_r_rready; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_aw_awid; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_read_aw_awaddr; // @[AcceleratorTop.scala 37:23]
  wire [7:0] dmaIn_io_read_aw_awlen; // @[AcceleratorTop.scala 37:23]
  wire [2:0] dmaIn_io_read_aw_awsize; // @[AcceleratorTop.scala 37:23]
  wire [1:0] dmaIn_io_read_aw_awburst; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_aw_awlock; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_aw_awcache; // @[AcceleratorTop.scala 37:23]
  wire [2:0] dmaIn_io_read_aw_awprot; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_aw_awqos; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_aw_awvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_aw_awready; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_read_w_wdata; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_w_wstrb; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_w_wlast; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_w_wvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_w_wready; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_b_bid; // @[AcceleratorTop.scala 37:23]
  wire [1:0] dmaIn_io_read_b_bresp; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_b_bvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_b_bready; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_ar_arid; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_read_ar_araddr; // @[AcceleratorTop.scala 37:23]
  wire [7:0] dmaIn_io_read_ar_arlen; // @[AcceleratorTop.scala 37:23]
  wire [2:0] dmaIn_io_read_ar_arsize; // @[AcceleratorTop.scala 37:23]
  wire [1:0] dmaIn_io_read_ar_arburst; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_ar_arlock; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_ar_arcache; // @[AcceleratorTop.scala 37:23]
  wire [2:0] dmaIn_io_read_ar_arprot; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_ar_arqos; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_ar_arvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_ar_arready; // @[AcceleratorTop.scala 37:23]
  wire [3:0] dmaIn_io_read_r_rid; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_read_r_rdata; // @[AcceleratorTop.scala 37:23]
  wire [1:0] dmaIn_io_read_r_rresp; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_r_rlast; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_r_rvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_read_r_rready; // @[AcceleratorTop.scala 37:23]
  wire [31:0] dmaIn_io_write_tdata; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_write_tvalid; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_write_tready; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_write_tuser; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_write_tlast; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_irq_readerDone; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_irq_writerDone; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_sync_readerSync; // @[AcceleratorTop.scala 37:23]
  wire  dmaIn_io_sync_writerSync; // @[AcceleratorTop.scala 37:23]
  wire  dmaOut_clock; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_reset; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_control_aw_awaddr; // @[AcceleratorTop.scala 38:24]
  wire [2:0] dmaOut_io_control_aw_awprot; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_aw_awvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_aw_awready; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_control_w_wdata; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_control_w_wstrb; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_w_wvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_w_wready; // @[AcceleratorTop.scala 38:24]
  wire [1:0] dmaOut_io_control_b_bresp; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_b_bvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_b_bready; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_control_ar_araddr; // @[AcceleratorTop.scala 38:24]
  wire [2:0] dmaOut_io_control_ar_arprot; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_ar_arvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_ar_arready; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_control_r_rdata; // @[AcceleratorTop.scala 38:24]
  wire [1:0] dmaOut_io_control_r_rresp; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_r_rvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_control_r_rready; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_read_tdata; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_read_tvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_read_tready; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_read_tuser; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_read_tlast; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_aw_awid; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_write_aw_awaddr; // @[AcceleratorTop.scala 38:24]
  wire [7:0] dmaOut_io_write_aw_awlen; // @[AcceleratorTop.scala 38:24]
  wire [2:0] dmaOut_io_write_aw_awsize; // @[AcceleratorTop.scala 38:24]
  wire [1:0] dmaOut_io_write_aw_awburst; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_aw_awlock; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_aw_awcache; // @[AcceleratorTop.scala 38:24]
  wire [2:0] dmaOut_io_write_aw_awprot; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_aw_awqos; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_aw_awvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_aw_awready; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_write_w_wdata; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_w_wstrb; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_w_wlast; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_w_wvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_w_wready; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_b_bid; // @[AcceleratorTop.scala 38:24]
  wire [1:0] dmaOut_io_write_b_bresp; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_b_bvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_b_bready; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_ar_arid; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_write_ar_araddr; // @[AcceleratorTop.scala 38:24]
  wire [7:0] dmaOut_io_write_ar_arlen; // @[AcceleratorTop.scala 38:24]
  wire [2:0] dmaOut_io_write_ar_arsize; // @[AcceleratorTop.scala 38:24]
  wire [1:0] dmaOut_io_write_ar_arburst; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_ar_arlock; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_ar_arcache; // @[AcceleratorTop.scala 38:24]
  wire [2:0] dmaOut_io_write_ar_arprot; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_ar_arqos; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_ar_arvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_ar_arready; // @[AcceleratorTop.scala 38:24]
  wire [3:0] dmaOut_io_write_r_rid; // @[AcceleratorTop.scala 38:24]
  wire [31:0] dmaOut_io_write_r_rdata; // @[AcceleratorTop.scala 38:24]
  wire [1:0] dmaOut_io_write_r_rresp; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_r_rlast; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_r_rvalid; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_write_r_rready; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_irq_readerDone; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_irq_writerDone; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_sync_readerSync; // @[AcceleratorTop.scala 38:24]
  wire  dmaOut_io_sync_writerSync; // @[AcceleratorTop.scala 38:24]
  wire  accelerator_clk; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_rst; // @[AcceleratorTop.scala 39:29]
  wire [31:0] accelerator_in_tdata; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_in_tvalid; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_in_tready; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_in_tuser; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_in_tlast; // @[AcceleratorTop.scala 39:29]
  wire [31:0] accelerator_out_tdata; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_out_tvalid; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_out_tready; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_out_tuser; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_out_tlast; // @[AcceleratorTop.scala 39:29]
  wire [2:0] accelerator_algorithm; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_busy; // @[AcceleratorTop.scala 39:29]
  wire [1:0] accelerator_pattern; // @[AcceleratorTop.scala 39:29]
  wire  accelerator_bgr; // @[AcceleratorTop.scala 39:29]
  wire [12:0] accelerator_cols; // @[AcceleratorTop.scala 39:29]
  wire [12:0] accelerator_rows; // @[AcceleratorTop.scala 39:29]
  wire  accd_clock; // @[AcceleratorTop.scala 40:22]
  wire  accd_reset; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlIn_aw_awaddr; // @[AcceleratorTop.scala 40:22]
  wire [2:0] accd_io_controlIn_aw_awprot; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_aw_awvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_aw_awready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlIn_w_wdata; // @[AcceleratorTop.scala 40:22]
  wire [3:0] accd_io_controlIn_w_wstrb; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_w_wvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_w_wready; // @[AcceleratorTop.scala 40:22]
  wire [1:0] accd_io_controlIn_b_bresp; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_b_bvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_b_bready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlIn_ar_araddr; // @[AcceleratorTop.scala 40:22]
  wire [2:0] accd_io_controlIn_ar_arprot; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_ar_arvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_ar_arready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlIn_r_rdata; // @[AcceleratorTop.scala 40:22]
  wire [1:0] accd_io_controlIn_r_rresp; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_r_rvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlIn_r_rready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlOut_aw_awaddr; // @[AcceleratorTop.scala 40:22]
  wire [2:0] accd_io_controlOut_aw_awprot; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_aw_awvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_aw_awready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlOut_w_wdata; // @[AcceleratorTop.scala 40:22]
  wire [3:0] accd_io_controlOut_w_wstrb; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_w_wvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_w_wready; // @[AcceleratorTop.scala 40:22]
  wire [1:0] accd_io_controlOut_b_bresp; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_b_bvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_b_bready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlOut_ar_araddr; // @[AcceleratorTop.scala 40:22]
  wire [2:0] accd_io_controlOut_ar_arprot; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_ar_arvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_ar_arready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlOut_r_rdata; // @[AcceleratorTop.scala 40:22]
  wire [1:0] accd_io_controlOut_r_rresp; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_r_rvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlOut_r_rready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlAcc_aw_awaddr; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_aw_awvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_aw_awready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlAcc_w_wdata; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_w_wvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_w_wready; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_b_bvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_b_bready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlAcc_ar_araddr; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_ar_arvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_ar_arready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_controlAcc_r_rdata; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_r_rvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_controlAcc_r_rready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_control_aw_awaddr; // @[AcceleratorTop.scala 40:22]
  wire [2:0] accd_io_control_aw_awprot; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_aw_awvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_aw_awready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_control_w_wdata; // @[AcceleratorTop.scala 40:22]
  wire [3:0] accd_io_control_w_wstrb; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_w_wvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_w_wready; // @[AcceleratorTop.scala 40:22]
  wire [1:0] accd_io_control_b_bresp; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_b_bvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_b_bready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_control_ar_araddr; // @[AcceleratorTop.scala 40:22]
  wire [2:0] accd_io_control_ar_arprot; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_ar_arvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_ar_arready; // @[AcceleratorTop.scala 40:22]
  wire [31:0] accd_io_control_r_rdata; // @[AcceleratorTop.scala 40:22]
  wire [1:0] accd_io_control_r_rresp; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_r_rvalid; // @[AcceleratorTop.scala 40:22]
  wire  accd_io_control_r_rready; // @[AcceleratorTop.scala 40:22]
  wire  csrBus_clock; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_reset; // @[AcceleratorTop.scala 42:24]
  wire [7:0] csrBus_io_ctl_aw_awaddr; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_aw_awvalid; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_aw_awready; // @[AcceleratorTop.scala 42:24]
  wire [31:0] csrBus_io_ctl_w_wdata; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_w_wvalid; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_w_wready; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_b_bvalid; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_b_bready; // @[AcceleratorTop.scala 42:24]
  wire [7:0] csrBus_io_ctl_ar_araddr; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_ar_arvalid; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_ar_arready; // @[AcceleratorTop.scala 42:24]
  wire [31:0] csrBus_io_ctl_r_rdata; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_r_rvalid; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_ctl_r_rready; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_bus_ready; // @[AcceleratorTop.scala 42:24]
  wire [5:0] csrBus_io_bus_addr; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_bus_reg_read; // @[AcceleratorTop.scala 42:24]
  wire [31:0] csrBus_io_bus_reg_dataOut; // @[AcceleratorTop.scala 42:24]
  wire  csrBus_io_bus_reg_write; // @[AcceleratorTop.scala 42:24]
  wire [31:0] csrBus_io_bus_reg_dataIn; // @[AcceleratorTop.scala 42:24]
  wire  csrWrapper_clock; // @[AcceleratorTop.scala 43:28]
  wire  csrWrapper_reset; // @[AcceleratorTop.scala 43:28]
  wire  csrWrapper_io_bus_ready; // @[AcceleratorTop.scala 43:28]
  wire [5:0] csrWrapper_io_bus_addr; // @[AcceleratorTop.scala 43:28]
  wire  csrWrapper_io_bus_reg_read; // @[AcceleratorTop.scala 43:28]
  wire [31:0] csrWrapper_io_bus_reg_dataOut; // @[AcceleratorTop.scala 43:28]
  wire  csrWrapper_io_bus_reg_write; // @[AcceleratorTop.scala 43:28]
  wire [31:0] csrWrapper_io_bus_reg_dataIn; // @[AcceleratorTop.scala 43:28]
  wire [2:0] csrWrapper_io_algorithm; // @[AcceleratorTop.scala 43:28]
  wire [1:0] csrWrapper_io_pattern; // @[AcceleratorTop.scala 43:28]
  wire  csrWrapper_io_bgr; // @[AcceleratorTop.scala 43:28]
  wire [12:0] csrWrapper_io_cols; // @[AcceleratorTop.scala 43:28]
  wire [12:0] csrWrapper_io_rows; // @[AcceleratorTop.scala 43:28]
  wire  irq_in_1 = dmaIn_io_irq_writerDone; // @[AcceleratorTop.scala 34:25 56:15]
  wire  irq_in_0 = dmaIn_io_irq_readerDone; // @[AcceleratorTop.scala 34:25 55:15]
  wire  irq_out_1 = dmaOut_io_irq_writerDone; // @[AcceleratorTop.scala 35:26 59:16]
  wire  irq_out_0 = dmaOut_io_irq_readerDone; // @[AcceleratorTop.scala 35:26 58:16]
  DMATopAXI_AXIL_AXIS dmaIn ( // @[AcceleratorTop.scala 37:23]
    .clock(dmaIn_clock),
    .reset(dmaIn_reset),
    .io_control_aw_awaddr(dmaIn_io_control_aw_awaddr),
    .io_control_aw_awprot(dmaIn_io_control_aw_awprot),
    .io_control_aw_awvalid(dmaIn_io_control_aw_awvalid),
    .io_control_aw_awready(dmaIn_io_control_aw_awready),
    .io_control_w_wdata(dmaIn_io_control_w_wdata),
    .io_control_w_wstrb(dmaIn_io_control_w_wstrb),
    .io_control_w_wvalid(dmaIn_io_control_w_wvalid),
    .io_control_w_wready(dmaIn_io_control_w_wready),
    .io_control_b_bresp(dmaIn_io_control_b_bresp),
    .io_control_b_bvalid(dmaIn_io_control_b_bvalid),
    .io_control_b_bready(dmaIn_io_control_b_bready),
    .io_control_ar_araddr(dmaIn_io_control_ar_araddr),
    .io_control_ar_arprot(dmaIn_io_control_ar_arprot),
    .io_control_ar_arvalid(dmaIn_io_control_ar_arvalid),
    .io_control_ar_arready(dmaIn_io_control_ar_arready),
    .io_control_r_rdata(dmaIn_io_control_r_rdata),
    .io_control_r_rresp(dmaIn_io_control_r_rresp),
    .io_control_r_rvalid(dmaIn_io_control_r_rvalid),
    .io_control_r_rready(dmaIn_io_control_r_rready),
    .io_read_aw_awid(dmaIn_io_read_aw_awid),
    .io_read_aw_awaddr(dmaIn_io_read_aw_awaddr),
    .io_read_aw_awlen(dmaIn_io_read_aw_awlen),
    .io_read_aw_awsize(dmaIn_io_read_aw_awsize),
    .io_read_aw_awburst(dmaIn_io_read_aw_awburst),
    .io_read_aw_awlock(dmaIn_io_read_aw_awlock),
    .io_read_aw_awcache(dmaIn_io_read_aw_awcache),
    .io_read_aw_awprot(dmaIn_io_read_aw_awprot),
    .io_read_aw_awqos(dmaIn_io_read_aw_awqos),
    .io_read_aw_awvalid(dmaIn_io_read_aw_awvalid),
    .io_read_aw_awready(dmaIn_io_read_aw_awready),
    .io_read_w_wdata(dmaIn_io_read_w_wdata),
    .io_read_w_wstrb(dmaIn_io_read_w_wstrb),
    .io_read_w_wlast(dmaIn_io_read_w_wlast),
    .io_read_w_wvalid(dmaIn_io_read_w_wvalid),
    .io_read_w_wready(dmaIn_io_read_w_wready),
    .io_read_b_bid(dmaIn_io_read_b_bid),
    .io_read_b_bresp(dmaIn_io_read_b_bresp),
    .io_read_b_bvalid(dmaIn_io_read_b_bvalid),
    .io_read_b_bready(dmaIn_io_read_b_bready),
    .io_read_ar_arid(dmaIn_io_read_ar_arid),
    .io_read_ar_araddr(dmaIn_io_read_ar_araddr),
    .io_read_ar_arlen(dmaIn_io_read_ar_arlen),
    .io_read_ar_arsize(dmaIn_io_read_ar_arsize),
    .io_read_ar_arburst(dmaIn_io_read_ar_arburst),
    .io_read_ar_arlock(dmaIn_io_read_ar_arlock),
    .io_read_ar_arcache(dmaIn_io_read_ar_arcache),
    .io_read_ar_arprot(dmaIn_io_read_ar_arprot),
    .io_read_ar_arqos(dmaIn_io_read_ar_arqos),
    .io_read_ar_arvalid(dmaIn_io_read_ar_arvalid),
    .io_read_ar_arready(dmaIn_io_read_ar_arready),
    .io_read_r_rid(dmaIn_io_read_r_rid),
    .io_read_r_rdata(dmaIn_io_read_r_rdata),
    .io_read_r_rresp(dmaIn_io_read_r_rresp),
    .io_read_r_rlast(dmaIn_io_read_r_rlast),
    .io_read_r_rvalid(dmaIn_io_read_r_rvalid),
    .io_read_r_rready(dmaIn_io_read_r_rready),
    .io_write_tdata(dmaIn_io_write_tdata),
    .io_write_tvalid(dmaIn_io_write_tvalid),
    .io_write_tready(dmaIn_io_write_tready),
    .io_write_tuser(dmaIn_io_write_tuser),
    .io_write_tlast(dmaIn_io_write_tlast),
    .io_irq_readerDone(dmaIn_io_irq_readerDone),
    .io_irq_writerDone(dmaIn_io_irq_writerDone),
    .io_sync_readerSync(dmaIn_io_sync_readerSync),
    .io_sync_writerSync(dmaIn_io_sync_writerSync)
  );
  DMATopAXIS_AXIL_AXI dmaOut ( // @[AcceleratorTop.scala 38:24]
    .clock(dmaOut_clock),
    .reset(dmaOut_reset),
    .io_control_aw_awaddr(dmaOut_io_control_aw_awaddr),
    .io_control_aw_awprot(dmaOut_io_control_aw_awprot),
    .io_control_aw_awvalid(dmaOut_io_control_aw_awvalid),
    .io_control_aw_awready(dmaOut_io_control_aw_awready),
    .io_control_w_wdata(dmaOut_io_control_w_wdata),
    .io_control_w_wstrb(dmaOut_io_control_w_wstrb),
    .io_control_w_wvalid(dmaOut_io_control_w_wvalid),
    .io_control_w_wready(dmaOut_io_control_w_wready),
    .io_control_b_bresp(dmaOut_io_control_b_bresp),
    .io_control_b_bvalid(dmaOut_io_control_b_bvalid),
    .io_control_b_bready(dmaOut_io_control_b_bready),
    .io_control_ar_araddr(dmaOut_io_control_ar_araddr),
    .io_control_ar_arprot(dmaOut_io_control_ar_arprot),
    .io_control_ar_arvalid(dmaOut_io_control_ar_arvalid),
    .io_control_ar_arready(dmaOut_io_control_ar_arready),
    .io_control_r_rdata(dmaOut_io_control_r_rdata),
    .io_control_r_rresp(dmaOut_io_control_r_rresp),
    .io_control_r_rvalid(dmaOut_io_control_r_rvalid),
    .io_control_r_rready(dmaOut_io_control_r_rready),
    .io_read_tdata(dmaOut_io_read_tdata),
    .io_read_tvalid(dmaOut_io_read_tvalid),
    .io_read_tready(dmaOut_io_read_tready),
    .io_read_tuser(dmaOut_io_read_tuser),
    .io_read_tlast(dmaOut_io_read_tlast),
    .io_write_aw_awid(dmaOut_io_write_aw_awid),
    .io_write_aw_awaddr(dmaOut_io_write_aw_awaddr),
    .io_write_aw_awlen(dmaOut_io_write_aw_awlen),
    .io_write_aw_awsize(dmaOut_io_write_aw_awsize),
    .io_write_aw_awburst(dmaOut_io_write_aw_awburst),
    .io_write_aw_awlock(dmaOut_io_write_aw_awlock),
    .io_write_aw_awcache(dmaOut_io_write_aw_awcache),
    .io_write_aw_awprot(dmaOut_io_write_aw_awprot),
    .io_write_aw_awqos(dmaOut_io_write_aw_awqos),
    .io_write_aw_awvalid(dmaOut_io_write_aw_awvalid),
    .io_write_aw_awready(dmaOut_io_write_aw_awready),
    .io_write_w_wdata(dmaOut_io_write_w_wdata),
    .io_write_w_wstrb(dmaOut_io_write_w_wstrb),
    .io_write_w_wlast(dmaOut_io_write_w_wlast),
    .io_write_w_wvalid(dmaOut_io_write_w_wvalid),
    .io_write_w_wready(dmaOut_io_write_w_wready),
    .io_write_b_bid(dmaOut_io_write_b_bid),
    .io_write_b_bresp(dmaOut_io_write_b_bresp),
    .io_write_b_bvalid(dmaOut_io_write_b_bvalid),
    .io_write_b_bready(dmaOut_io_write_b_bready),
    .io_write_ar_arid(dmaOut_io_write_ar_arid),
    .io_write_ar_araddr(dmaOut_io_write_ar_araddr),
    .io_write_ar_arlen(dmaOut_io_write_ar_arlen),
    .io_write_ar_arsize(dmaOut_io_write_ar_arsize),
    .io_write_ar_arburst(dmaOut_io_write_ar_arburst),
    .io_write_ar_arlock(dmaOut_io_write_ar_arlock),
    .io_write_ar_arcache(dmaOut_io_write_ar_arcache),
    .io_write_ar_arprot(dmaOut_io_write_ar_arprot),
    .io_write_ar_arqos(dmaOut_io_write_ar_arqos),
    .io_write_ar_arvalid(dmaOut_io_write_ar_arvalid),
    .io_write_ar_arready(dmaOut_io_write_ar_arready),
    .io_write_r_rid(dmaOut_io_write_r_rid),
    .io_write_r_rdata(dmaOut_io_write_r_rdata),
    .io_write_r_rresp(dmaOut_io_write_r_rresp),
    .io_write_r_rlast(dmaOut_io_write_r_rlast),
    .io_write_r_rvalid(dmaOut_io_write_r_rvalid),
    .io_write_r_rready(dmaOut_io_write_r_rready),
    .io_irq_readerDone(dmaOut_io_irq_readerDone),
    .io_irq_writerDone(dmaOut_io_irq_writerDone),
    .io_sync_readerSync(dmaOut_io_sync_readerSync),
    .io_sync_writerSync(dmaOut_io_sync_writerSync)
  );
  AcceleratorIntegration accelerator ( // @[AcceleratorTop.scala 39:29]
    .clk(accelerator_clk),
    .rst(accelerator_rst),
    .in_tdata(accelerator_in_tdata),
    .in_tvalid(accelerator_in_tvalid),
    .in_tready(accelerator_in_tready),
    .in_tuser(accelerator_in_tuser),
    .in_tlast(accelerator_in_tlast),
    .out_tdata(accelerator_out_tdata),
    .out_tvalid(accelerator_out_tvalid),
    .out_tready(accelerator_out_tready),
    .out_tuser(accelerator_out_tuser),
    .out_tlast(accelerator_out_tlast),
    .algorithm(accelerator_algorithm),
    .busy(accelerator_busy),
    .pattern(accelerator_pattern),
    .bgr(accelerator_bgr),
    .cols(accelerator_cols),
    .rows(accelerator_rows)
  );
  AcceleratorDecoder accd ( // @[AcceleratorTop.scala 40:22]
    .clock(accd_clock),
    .reset(accd_reset),
    .io_controlIn_aw_awaddr(accd_io_controlIn_aw_awaddr),
    .io_controlIn_aw_awprot(accd_io_controlIn_aw_awprot),
    .io_controlIn_aw_awvalid(accd_io_controlIn_aw_awvalid),
    .io_controlIn_aw_awready(accd_io_controlIn_aw_awready),
    .io_controlIn_w_wdata(accd_io_controlIn_w_wdata),
    .io_controlIn_w_wstrb(accd_io_controlIn_w_wstrb),
    .io_controlIn_w_wvalid(accd_io_controlIn_w_wvalid),
    .io_controlIn_w_wready(accd_io_controlIn_w_wready),
    .io_controlIn_b_bresp(accd_io_controlIn_b_bresp),
    .io_controlIn_b_bvalid(accd_io_controlIn_b_bvalid),
    .io_controlIn_b_bready(accd_io_controlIn_b_bready),
    .io_controlIn_ar_araddr(accd_io_controlIn_ar_araddr),
    .io_controlIn_ar_arprot(accd_io_controlIn_ar_arprot),
    .io_controlIn_ar_arvalid(accd_io_controlIn_ar_arvalid),
    .io_controlIn_ar_arready(accd_io_controlIn_ar_arready),
    .io_controlIn_r_rdata(accd_io_controlIn_r_rdata),
    .io_controlIn_r_rresp(accd_io_controlIn_r_rresp),
    .io_controlIn_r_rvalid(accd_io_controlIn_r_rvalid),
    .io_controlIn_r_rready(accd_io_controlIn_r_rready),
    .io_controlOut_aw_awaddr(accd_io_controlOut_aw_awaddr),
    .io_controlOut_aw_awprot(accd_io_controlOut_aw_awprot),
    .io_controlOut_aw_awvalid(accd_io_controlOut_aw_awvalid),
    .io_controlOut_aw_awready(accd_io_controlOut_aw_awready),
    .io_controlOut_w_wdata(accd_io_controlOut_w_wdata),
    .io_controlOut_w_wstrb(accd_io_controlOut_w_wstrb),
    .io_controlOut_w_wvalid(accd_io_controlOut_w_wvalid),
    .io_controlOut_w_wready(accd_io_controlOut_w_wready),
    .io_controlOut_b_bresp(accd_io_controlOut_b_bresp),
    .io_controlOut_b_bvalid(accd_io_controlOut_b_bvalid),
    .io_controlOut_b_bready(accd_io_controlOut_b_bready),
    .io_controlOut_ar_araddr(accd_io_controlOut_ar_araddr),
    .io_controlOut_ar_arprot(accd_io_controlOut_ar_arprot),
    .io_controlOut_ar_arvalid(accd_io_controlOut_ar_arvalid),
    .io_controlOut_ar_arready(accd_io_controlOut_ar_arready),
    .io_controlOut_r_rdata(accd_io_controlOut_r_rdata),
    .io_controlOut_r_rresp(accd_io_controlOut_r_rresp),
    .io_controlOut_r_rvalid(accd_io_controlOut_r_rvalid),
    .io_controlOut_r_rready(accd_io_controlOut_r_rready),
    .io_controlAcc_aw_awaddr(accd_io_controlAcc_aw_awaddr),
    .io_controlAcc_aw_awvalid(accd_io_controlAcc_aw_awvalid),
    .io_controlAcc_aw_awready(accd_io_controlAcc_aw_awready),
    .io_controlAcc_w_wdata(accd_io_controlAcc_w_wdata),
    .io_controlAcc_w_wvalid(accd_io_controlAcc_w_wvalid),
    .io_controlAcc_w_wready(accd_io_controlAcc_w_wready),
    .io_controlAcc_b_bvalid(accd_io_controlAcc_b_bvalid),
    .io_controlAcc_b_bready(accd_io_controlAcc_b_bready),
    .io_controlAcc_ar_araddr(accd_io_controlAcc_ar_araddr),
    .io_controlAcc_ar_arvalid(accd_io_controlAcc_ar_arvalid),
    .io_controlAcc_ar_arready(accd_io_controlAcc_ar_arready),
    .io_controlAcc_r_rdata(accd_io_controlAcc_r_rdata),
    .io_controlAcc_r_rvalid(accd_io_controlAcc_r_rvalid),
    .io_controlAcc_r_rready(accd_io_controlAcc_r_rready),
    .io_control_aw_awaddr(accd_io_control_aw_awaddr),
    .io_control_aw_awprot(accd_io_control_aw_awprot),
    .io_control_aw_awvalid(accd_io_control_aw_awvalid),
    .io_control_aw_awready(accd_io_control_aw_awready),
    .io_control_w_wdata(accd_io_control_w_wdata),
    .io_control_w_wstrb(accd_io_control_w_wstrb),
    .io_control_w_wvalid(accd_io_control_w_wvalid),
    .io_control_w_wready(accd_io_control_w_wready),
    .io_control_b_bresp(accd_io_control_b_bresp),
    .io_control_b_bvalid(accd_io_control_b_bvalid),
    .io_control_b_bready(accd_io_control_b_bready),
    .io_control_ar_araddr(accd_io_control_ar_araddr),
    .io_control_ar_arprot(accd_io_control_ar_arprot),
    .io_control_ar_arvalid(accd_io_control_ar_arvalid),
    .io_control_ar_arready(accd_io_control_ar_arready),
    .io_control_r_rdata(accd_io_control_r_rdata),
    .io_control_r_rresp(accd_io_control_r_rresp),
    .io_control_r_rvalid(accd_io_control_r_rvalid),
    .io_control_r_rready(accd_io_control_r_rready)
  );
  AXI4LiteCustomCSR csrBus ( // @[AcceleratorTop.scala 42:24]
    .clock(csrBus_clock),
    .reset(csrBus_reset),
    .io_ctl_aw_awaddr(csrBus_io_ctl_aw_awaddr),
    .io_ctl_aw_awvalid(csrBus_io_ctl_aw_awvalid),
    .io_ctl_aw_awready(csrBus_io_ctl_aw_awready),
    .io_ctl_w_wdata(csrBus_io_ctl_w_wdata),
    .io_ctl_w_wvalid(csrBus_io_ctl_w_wvalid),
    .io_ctl_w_wready(csrBus_io_ctl_w_wready),
    .io_ctl_b_bvalid(csrBus_io_ctl_b_bvalid),
    .io_ctl_b_bready(csrBus_io_ctl_b_bready),
    .io_ctl_ar_araddr(csrBus_io_ctl_ar_araddr),
    .io_ctl_ar_arvalid(csrBus_io_ctl_ar_arvalid),
    .io_ctl_ar_arready(csrBus_io_ctl_ar_arready),
    .io_ctl_r_rdata(csrBus_io_ctl_r_rdata),
    .io_ctl_r_rvalid(csrBus_io_ctl_r_rvalid),
    .io_ctl_r_rready(csrBus_io_ctl_r_rready),
    .io_bus_ready(csrBus_io_bus_ready),
    .io_bus_addr(csrBus_io_bus_addr),
    .io_bus_reg_read(csrBus_io_bus_reg_read),
    .io_bus_reg_dataOut(csrBus_io_bus_reg_dataOut),
    .io_bus_reg_write(csrBus_io_bus_reg_write),
    .io_bus_reg_dataIn(csrBus_io_bus_reg_dataIn)
  );
  CustomCSRWrapper csrWrapper ( // @[AcceleratorTop.scala 43:28]
    .clock(csrWrapper_clock),
    .reset(csrWrapper_reset),
    .io_bus_ready(csrWrapper_io_bus_ready),
    .io_bus_addr(csrWrapper_io_bus_addr),
    .io_bus_reg_read(csrWrapper_io_bus_reg_read),
    .io_bus_reg_dataOut(csrWrapper_io_bus_reg_dataOut),
    .io_bus_reg_write(csrWrapper_io_bus_reg_write),
    .io_bus_reg_dataIn(csrWrapper_io_bus_reg_dataIn),
    .io_algorithm(csrWrapper_io_algorithm),
    .io_pattern(csrWrapper_io_pattern),
    .io_bgr(csrWrapper_io_bgr),
    .io_cols(csrWrapper_io_cols),
    .io_rows(csrWrapper_io_rows)
  );
  assign io_in_read_aw_awid = dmaIn_io_read_aw_awid; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awaddr = dmaIn_io_read_aw_awaddr; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awlen = dmaIn_io_read_aw_awlen; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awsize = dmaIn_io_read_aw_awsize; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awburst = dmaIn_io_read_aw_awburst; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awlock = dmaIn_io_read_aw_awlock; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awcache = dmaIn_io_read_aw_awcache; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awprot = dmaIn_io_read_aw_awprot; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awqos = dmaIn_io_read_aw_awqos; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_aw_awvalid = dmaIn_io_read_aw_awvalid; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_w_wdata = dmaIn_io_read_w_wdata; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_w_wstrb = dmaIn_io_read_w_wstrb; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_w_wlast = dmaIn_io_read_w_wlast; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_w_wvalid = dmaIn_io_read_w_wvalid; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_b_bready = dmaIn_io_read_b_bready; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arid = dmaIn_io_read_ar_arid; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_araddr = dmaIn_io_read_ar_araddr; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arlen = dmaIn_io_read_ar_arlen; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arsize = dmaIn_io_read_ar_arsize; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arburst = dmaIn_io_read_ar_arburst; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arlock = dmaIn_io_read_ar_arlock; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arcache = dmaIn_io_read_ar_arcache; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arprot = dmaIn_io_read_ar_arprot; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arqos = dmaIn_io_read_ar_arqos; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_ar_arvalid = dmaIn_io_read_ar_arvalid; // @[AcceleratorTop.scala 74:16]
  assign io_in_read_r_rready = dmaIn_io_read_r_rready; // @[AcceleratorTop.scala 74:16]
  assign io_control_aw_awready = accd_io_control_aw_awready; // @[AcceleratorTop.scala 78:16]
  assign io_control_w_wready = accd_io_control_w_wready; // @[AcceleratorTop.scala 78:16]
  assign io_control_b_bresp = accd_io_control_b_bresp; // @[AcceleratorTop.scala 78:16]
  assign io_control_b_bvalid = accd_io_control_b_bvalid; // @[AcceleratorTop.scala 78:16]
  assign io_control_ar_arready = accd_io_control_ar_arready; // @[AcceleratorTop.scala 78:16]
  assign io_control_r_rdata = accd_io_control_r_rdata; // @[AcceleratorTop.scala 78:16]
  assign io_control_r_rresp = accd_io_control_r_rresp; // @[AcceleratorTop.scala 78:16]
  assign io_control_r_rvalid = accd_io_control_r_rvalid; // @[AcceleratorTop.scala 78:16]
  assign io_out_write_aw_awid = dmaOut_io_write_aw_awid; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awaddr = dmaOut_io_write_aw_awaddr; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awlen = dmaOut_io_write_aw_awlen; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awsize = dmaOut_io_write_aw_awsize; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awburst = dmaOut_io_write_aw_awburst; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awlock = dmaOut_io_write_aw_awlock; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awcache = dmaOut_io_write_aw_awcache; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awprot = dmaOut_io_write_aw_awprot; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awqos = dmaOut_io_write_aw_awqos; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_aw_awvalid = dmaOut_io_write_aw_awvalid; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_w_wdata = dmaOut_io_write_w_wdata; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_w_wstrb = dmaOut_io_write_w_wstrb; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_w_wlast = dmaOut_io_write_w_wlast; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_w_wvalid = dmaOut_io_write_w_wvalid; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_b_bready = dmaOut_io_write_b_bready; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arid = dmaOut_io_write_ar_arid; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_araddr = dmaOut_io_write_ar_araddr; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arlen = dmaOut_io_write_ar_arlen; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arsize = dmaOut_io_write_ar_arsize; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arburst = dmaOut_io_write_ar_arburst; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arlock = dmaOut_io_write_ar_arlock; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arcache = dmaOut_io_write_ar_arcache; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arprot = dmaOut_io_write_ar_arprot; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arqos = dmaOut_io_write_ar_arqos; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_ar_arvalid = dmaOut_io_write_ar_arvalid; // @[AcceleratorTop.scala 75:18]
  assign io_out_write_r_rready = dmaOut_io_write_r_rready; // @[AcceleratorTop.scala 75:18]
  assign io_irq_dmaIn = {irq_in_1,irq_in_0}; // @[AcceleratorTop.scala 57:28]
  assign io_irq_dmaOut = {irq_out_1,irq_out_0}; // @[AcceleratorTop.scala 60:30]
  assign dmaIn_clock = clock; // @[AcceleratorTop.scala 68:20]
  assign dmaIn_reset = reset; // @[AcceleratorTop.scala 69:20]
  assign dmaIn_io_control_aw_awaddr = accd_io_controlIn_aw_awaddr; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_aw_awprot = accd_io_controlIn_aw_awprot; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_aw_awvalid = accd_io_controlIn_aw_awvalid; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_w_wdata = accd_io_controlIn_w_wdata; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_w_wstrb = accd_io_controlIn_w_wstrb; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_w_wvalid = accd_io_controlIn_w_wvalid; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_b_bready = accd_io_controlIn_b_bready; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_ar_araddr = accd_io_controlIn_ar_araddr; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_ar_arprot = accd_io_controlIn_ar_arprot; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_ar_arvalid = accd_io_controlIn_ar_arvalid; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_control_r_rready = accd_io_controlIn_r_rready; // @[AcceleratorTop.scala 76:23]
  assign dmaIn_io_read_aw_awready = io_in_read_aw_awready; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_w_wready = io_in_read_w_wready; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_b_bid = io_in_read_b_bid; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_b_bresp = io_in_read_b_bresp; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_b_bvalid = io_in_read_b_bvalid; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_ar_arready = io_in_read_ar_arready; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_r_rid = io_in_read_r_rid; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_r_rdata = io_in_read_r_rdata; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_r_rresp = io_in_read_r_rresp; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_r_rlast = io_in_read_r_rlast; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_read_r_rvalid = io_in_read_r_rvalid; // @[AcceleratorTop.scala 74:16]
  assign dmaIn_io_write_tready = accelerator_in_tready; // @[AcceleratorTop.scala 63:23]
  assign dmaOut_clock = clock; // @[AcceleratorTop.scala 71:21]
  assign dmaOut_reset = reset; // @[AcceleratorTop.scala 72:21]
  assign dmaOut_io_control_aw_awaddr = accd_io_controlOut_aw_awaddr; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_aw_awprot = accd_io_controlOut_aw_awprot; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_aw_awvalid = accd_io_controlOut_aw_awvalid; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_w_wdata = accd_io_controlOut_w_wdata; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_w_wstrb = accd_io_controlOut_w_wstrb; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_w_wvalid = accd_io_controlOut_w_wvalid; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_b_bready = accd_io_controlOut_b_bready; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_ar_araddr = accd_io_controlOut_ar_araddr; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_ar_arprot = accd_io_controlOut_ar_arprot; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_ar_arvalid = accd_io_controlOut_ar_arvalid; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_control_r_rready = accd_io_controlOut_r_rready; // @[AcceleratorTop.scala 77:24]
  assign dmaOut_io_read_tdata = accelerator_out_tdata; // @[AcceleratorTop.scala 62:24]
  assign dmaOut_io_read_tvalid = accelerator_out_tvalid; // @[AcceleratorTop.scala 62:24]
  assign dmaOut_io_read_tuser = accelerator_out_tuser; // @[AcceleratorTop.scala 62:24]
  assign dmaOut_io_read_tlast = accelerator_out_tlast; // @[AcceleratorTop.scala 62:24]
  assign dmaOut_io_write_aw_awready = io_out_write_aw_awready; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_w_wready = io_out_write_w_wready; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_b_bid = io_out_write_b_bid; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_b_bresp = io_out_write_b_bresp; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_b_bvalid = io_out_write_b_bvalid; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_ar_arready = io_out_write_ar_arready; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_r_rid = io_out_write_r_rid; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_r_rdata = io_out_write_r_rdata; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_r_rresp = io_out_write_r_rresp; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_r_rlast = io_out_write_r_rlast; // @[AcceleratorTop.scala 75:18]
  assign dmaOut_io_write_r_rvalid = io_out_write_r_rvalid; // @[AcceleratorTop.scala 75:18]
  assign accelerator_clk = clock; // @[AcceleratorTop.scala 65:24]
  assign accelerator_rst = reset; // @[AcceleratorTop.scala 66:24]
  assign accelerator_in_tdata = dmaIn_io_write_tdata; // @[AcceleratorTop.scala 63:23]
  assign accelerator_in_tvalid = dmaIn_io_write_tvalid; // @[AcceleratorTop.scala 63:23]
  assign accelerator_in_tuser = dmaIn_io_write_tuser; // @[AcceleratorTop.scala 63:23]
  assign accelerator_in_tlast = dmaIn_io_write_tlast; // @[AcceleratorTop.scala 63:23]
  assign accelerator_out_tready = dmaOut_io_read_tready; // @[AcceleratorTop.scala 62:24]
  assign accelerator_algorithm = csrWrapper_io_algorithm; // @[AcceleratorTop.scala 46:30]
  assign accelerator_pattern = csrWrapper_io_pattern; // @[AcceleratorTop.scala 47:28]
  assign accelerator_bgr = csrWrapper_io_bgr; // @[AcceleratorTop.scala 48:24]
  assign accelerator_cols = csrWrapper_io_cols; // @[AcceleratorTop.scala 49:25]
  assign accelerator_rows = csrWrapper_io_rows; // @[AcceleratorTop.scala 50:25]
  assign accd_clock = clock;
  assign accd_reset = reset;
  assign accd_io_controlIn_aw_awready = dmaIn_io_control_aw_awready; // @[AcceleratorTop.scala 76:23]
  assign accd_io_controlIn_w_wready = dmaIn_io_control_w_wready; // @[AcceleratorTop.scala 76:23]
  assign accd_io_controlIn_b_bresp = dmaIn_io_control_b_bresp; // @[AcceleratorTop.scala 76:23]
  assign accd_io_controlIn_b_bvalid = dmaIn_io_control_b_bvalid; // @[AcceleratorTop.scala 76:23]
  assign accd_io_controlIn_ar_arready = dmaIn_io_control_ar_arready; // @[AcceleratorTop.scala 76:23]
  assign accd_io_controlIn_r_rdata = dmaIn_io_control_r_rdata; // @[AcceleratorTop.scala 76:23]
  assign accd_io_controlIn_r_rresp = dmaIn_io_control_r_rresp; // @[AcceleratorTop.scala 76:23]
  assign accd_io_controlIn_r_rvalid = dmaIn_io_control_r_rvalid; // @[AcceleratorTop.scala 76:23]
  assign accd_io_controlOut_aw_awready = dmaOut_io_control_aw_awready; // @[AcceleratorTop.scala 77:24]
  assign accd_io_controlOut_w_wready = dmaOut_io_control_w_wready; // @[AcceleratorTop.scala 77:24]
  assign accd_io_controlOut_b_bresp = dmaOut_io_control_b_bresp; // @[AcceleratorTop.scala 77:24]
  assign accd_io_controlOut_b_bvalid = dmaOut_io_control_b_bvalid; // @[AcceleratorTop.scala 77:24]
  assign accd_io_controlOut_ar_arready = dmaOut_io_control_ar_arready; // @[AcceleratorTop.scala 77:24]
  assign accd_io_controlOut_r_rdata = dmaOut_io_control_r_rdata; // @[AcceleratorTop.scala 77:24]
  assign accd_io_controlOut_r_rresp = dmaOut_io_control_r_rresp; // @[AcceleratorTop.scala 77:24]
  assign accd_io_controlOut_r_rvalid = dmaOut_io_control_r_rvalid; // @[AcceleratorTop.scala 77:24]
  assign accd_io_controlAcc_aw_awready = csrBus_io_ctl_aw_awready; // @[AcceleratorTop.scala 52:19]
  assign accd_io_controlAcc_w_wready = csrBus_io_ctl_w_wready; // @[AcceleratorTop.scala 52:19]
  assign accd_io_controlAcc_b_bvalid = csrBus_io_ctl_b_bvalid; // @[AcceleratorTop.scala 52:19]
  assign accd_io_controlAcc_ar_arready = csrBus_io_ctl_ar_arready; // @[AcceleratorTop.scala 52:19]
  assign accd_io_controlAcc_r_rdata = csrBus_io_ctl_r_rdata; // @[AcceleratorTop.scala 52:19]
  assign accd_io_controlAcc_r_rvalid = csrBus_io_ctl_r_rvalid; // @[AcceleratorTop.scala 52:19]
  assign accd_io_control_aw_awaddr = io_control_aw_awaddr; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_aw_awprot = io_control_aw_awprot; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_aw_awvalid = io_control_aw_awvalid; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_w_wdata = io_control_w_wdata; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_w_wstrb = io_control_w_wstrb; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_w_wvalid = io_control_w_wvalid; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_b_bready = io_control_b_bready; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_ar_araddr = io_control_ar_araddr; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_ar_arprot = io_control_ar_arprot; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_ar_arvalid = io_control_ar_arvalid; // @[AcceleratorTop.scala 78:16]
  assign accd_io_control_r_rready = io_control_r_rready; // @[AcceleratorTop.scala 78:16]
  assign csrBus_clock = clock;
  assign csrBus_reset = reset;
  assign csrBus_io_ctl_aw_awaddr = accd_io_controlAcc_aw_awaddr[7:0]; // @[AcceleratorTop.scala 52:19]
  assign csrBus_io_ctl_aw_awvalid = accd_io_controlAcc_aw_awvalid; // @[AcceleratorTop.scala 52:19]
  assign csrBus_io_ctl_w_wdata = accd_io_controlAcc_w_wdata; // @[AcceleratorTop.scala 52:19]
  assign csrBus_io_ctl_w_wvalid = accd_io_controlAcc_w_wvalid; // @[AcceleratorTop.scala 52:19]
  assign csrBus_io_ctl_b_bready = accd_io_controlAcc_b_bready; // @[AcceleratorTop.scala 52:19]
  assign csrBus_io_ctl_ar_araddr = accd_io_controlAcc_ar_araddr[7:0]; // @[AcceleratorTop.scala 52:19]
  assign csrBus_io_ctl_ar_arvalid = accd_io_controlAcc_ar_arvalid; // @[AcceleratorTop.scala 52:19]
  assign csrBus_io_ctl_r_rready = accd_io_controlAcc_r_rready; // @[AcceleratorTop.scala 52:19]
  assign csrBus_io_bus_ready = csrWrapper_io_bus_ready; // @[AcceleratorTop.scala 53:23]
  assign csrBus_io_bus_reg_dataIn = csrWrapper_io_bus_reg_dataIn; // @[AcceleratorTop.scala 53:23]
  assign csrWrapper_clock = clock;
  assign csrWrapper_reset = reset;
  assign csrWrapper_io_bus_addr = csrBus_io_bus_addr; // @[AcceleratorTop.scala 53:23]
  assign csrWrapper_io_bus_reg_read = csrBus_io_bus_reg_read; // @[AcceleratorTop.scala 53:23]
  assign csrWrapper_io_bus_reg_dataOut = csrBus_io_bus_reg_dataOut; // @[AcceleratorTop.scala 53:23]
  assign csrWrapper_io_bus_reg_write = csrBus_io_bus_reg_write; // @[AcceleratorTop.scala 53:23]
endmodule
