module AXI4LiteCSRAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  input  [31:0] io_ctl_aw_awaddr,
  input         io_ctl_aw_awvalid,
  output        io_ctl_aw_awready,
  input  [31:0] io_ctl_w_wdata,
  input         io_ctl_w_wvalid,
  output        io_ctl_w_wready,
  output        io_ctl_b_bvalid,
  input         io_ctl_b_bready,
  input  [31:0] io_ctl_ar_araddr,
  input         io_ctl_ar_arvalid,
  output        io_ctl_ar_arready,
  output [31:0] io_ctl_r_rdata,
  output        io_ctl_r_rvalid,
  input         io_ctl_r_rready,
  output [3:0]  io_bus_addr,
  output [31:0] io_bus_dataOut,
  input  [31:0] io_bus_dataIn,
  output        io_bus_write,
  output        io_bus_read
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
  reg [2:0] state; // @[AXI4LiteCSR.scala 31:22]
  reg  awready; // @[AXI4LiteCSR.scala 33:24]
  reg  wready; // @[AXI4LiteCSR.scala 34:23]
  reg  bvalid; // @[AXI4LiteCSR.scala 35:23]
  reg  arready; // @[AXI4LiteCSR.scala 38:24]
  reg  rvalid; // @[AXI4LiteCSR.scala 39:23]
  reg [31:0] addr; // @[AXI4LiteCSR.scala 42:21]
  wire  _io_bus_read_T = io_ctl_r_rready & rvalid; // @[AXI4LiteCSR.scala 56:34]
  wire  _io_bus_write_T = io_ctl_w_wvalid & wready; // @[AXI4LiteCSR.scala 57:35]
  wire  _GEN_2 = io_ctl_ar_arvalid | arready; // @[AXI4LiteCSR.scala 67:36 70:17 38:24]
  wire  _GEN_5 = io_ctl_aw_awvalid | awready; // @[AXI4LiteCSR.scala 62:30 65:17 33:24]
  wire  _GEN_9 = io_ctl_ar_arvalid & arready | rvalid; // @[AXI4LiteCSR.scala 74:41 77:16 39:23]
  wire [2:0] _GEN_10 = _io_bus_read_T ? 3'h0 : state; // @[AXI4LiteCSR.scala 81:38 82:15 31:22]
  wire  _GEN_11 = _io_bus_read_T ? 1'h0 : rvalid; // @[AXI4LiteCSR.scala 81:38 83:16 39:23]
  wire [2:0] _GEN_12 = io_ctl_aw_awvalid & awready ? 3'h4 : state; // @[AXI4LiteCSR.scala 87:41 88:15 31:22]
  wire  _GEN_13 = io_ctl_aw_awvalid & awready ? 1'h0 : awready; // @[AXI4LiteCSR.scala 87:41 89:17 33:24]
  wire  _GEN_14 = io_ctl_aw_awvalid & awready | wready; // @[AXI4LiteCSR.scala 87:41 90:16 34:23]
  wire [2:0] _GEN_15 = _io_bus_write_T ? 3'h5 : state; // @[AXI4LiteCSR.scala 94:38 95:15 31:22]
  wire  _GEN_16 = _io_bus_write_T ? 1'h0 : wready; // @[AXI4LiteCSR.scala 94:38 96:16 34:23]
  wire  _GEN_17 = _io_bus_write_T | bvalid; // @[AXI4LiteCSR.scala 94:38 97:16 35:23]
  wire [2:0] _GEN_18 = io_ctl_b_bready & bvalid ? 3'h0 : state; // @[AXI4LiteCSR.scala 101:38 102:15 31:22]
  wire  _GEN_19 = io_ctl_b_bready & bvalid ? 1'h0 : bvalid; // @[AXI4LiteCSR.scala 101:38 103:16 35:23]
  wire [2:0] _GEN_20 = 3'h5 == state ? _GEN_18 : state; // @[AXI4LiteCSR.scala 60:16 31:22]
  wire  _GEN_21 = 3'h5 == state ? _GEN_19 : bvalid; // @[AXI4LiteCSR.scala 60:16 35:23]
  wire [2:0] _GEN_22 = 3'h4 == state ? _GEN_15 : _GEN_20; // @[AXI4LiteCSR.scala 60:16]
  wire  _GEN_23 = 3'h4 == state ? _GEN_16 : wready; // @[AXI4LiteCSR.scala 60:16 34:23]
  wire  _GEN_24 = 3'h4 == state ? _GEN_17 : _GEN_21; // @[AXI4LiteCSR.scala 60:16]
  wire [2:0] _GEN_25 = 3'h3 == state ? _GEN_12 : _GEN_22; // @[AXI4LiteCSR.scala 60:16]
  wire  _GEN_26 = 3'h3 == state ? _GEN_13 : awready; // @[AXI4LiteCSR.scala 60:16 33:24]
  wire  _GEN_27 = 3'h3 == state ? _GEN_14 : _GEN_23; // @[AXI4LiteCSR.scala 60:16]
  wire  _GEN_28 = 3'h3 == state ? bvalid : _GEN_24; // @[AXI4LiteCSR.scala 60:16 35:23]
  assign io_ctl_aw_awready = awready; // @[AXI4LiteCSR.scala 47:21]
  assign io_ctl_w_wready = wready & io_bus_write; // @[AXI4LiteCSR.scala 48:29]
  assign io_ctl_b_bvalid = bvalid; // @[AXI4LiteCSR.scala 49:19]
  assign io_ctl_ar_arready = arready; // @[AXI4LiteCSR.scala 52:21]
  assign io_ctl_r_rdata = io_bus_dataIn; // @[AXI4LiteCSR.scala 44:18]
  assign io_ctl_r_rvalid = rvalid & io_bus_read; // @[AXI4LiteCSR.scala 53:29]
  assign io_bus_addr = addr[3:0]; // @[AXI4LiteCSR.scala 58:15]
  assign io_bus_dataOut = io_ctl_w_wdata; // @[AXI4LiteCSR.scala 45:18]
  assign io_bus_write = io_ctl_w_wvalid & wready; // @[AXI4LiteCSR.scala 57:35]
  assign io_bus_read = io_ctl_r_rready & rvalid; // @[AXI4LiteCSR.scala 56:34]
  always @(posedge clock) begin
    if (reset) begin // @[AXI4LiteCSR.scala 31:22]
      state <= 3'h0; // @[AXI4LiteCSR.scala 31:22]
    end else if (3'h0 == state) begin // @[AXI4LiteCSR.scala 60:16]
      if (io_ctl_aw_awvalid) begin // @[AXI4LiteCSR.scala 62:30]
        state <= 3'h3; // @[AXI4LiteCSR.scala 63:15]
      end else if (io_ctl_ar_arvalid) begin // @[AXI4LiteCSR.scala 67:36]
        state <= 3'h1; // @[AXI4LiteCSR.scala 68:15]
      end
    end else if (3'h1 == state) begin // @[AXI4LiteCSR.scala 60:16]
      if (io_ctl_ar_arvalid & arready) begin // @[AXI4LiteCSR.scala 74:41]
        state <= 3'h2; // @[AXI4LiteCSR.scala 75:15]
      end
    end else if (3'h2 == state) begin // @[AXI4LiteCSR.scala 60:16]
      state <= _GEN_10;
    end else begin
      state <= _GEN_25;
    end
    if (reset) begin // @[AXI4LiteCSR.scala 33:24]
      awready <= 1'h0; // @[AXI4LiteCSR.scala 33:24]
    end else if (3'h0 == state) begin // @[AXI4LiteCSR.scala 60:16]
      awready <= _GEN_5;
    end else if (!(3'h1 == state)) begin // @[AXI4LiteCSR.scala 60:16]
      if (!(3'h2 == state)) begin // @[AXI4LiteCSR.scala 60:16]
        awready <= _GEN_26;
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 34:23]
      wready <= 1'h0; // @[AXI4LiteCSR.scala 34:23]
    end else if (!(3'h0 == state)) begin // @[AXI4LiteCSR.scala 60:16]
      if (!(3'h1 == state)) begin // @[AXI4LiteCSR.scala 60:16]
        if (!(3'h2 == state)) begin // @[AXI4LiteCSR.scala 60:16]
          wready <= _GEN_27;
        end
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 35:23]
      bvalid <= 1'h0; // @[AXI4LiteCSR.scala 35:23]
    end else if (!(3'h0 == state)) begin // @[AXI4LiteCSR.scala 60:16]
      if (!(3'h1 == state)) begin // @[AXI4LiteCSR.scala 60:16]
        if (!(3'h2 == state)) begin // @[AXI4LiteCSR.scala 60:16]
          bvalid <= _GEN_28;
        end
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 38:24]
      arready <= 1'h0; // @[AXI4LiteCSR.scala 38:24]
    end else if (3'h0 == state) begin // @[AXI4LiteCSR.scala 60:16]
      if (!(io_ctl_aw_awvalid)) begin // @[AXI4LiteCSR.scala 62:30]
        arready <= _GEN_2;
      end
    end else if (3'h1 == state) begin // @[AXI4LiteCSR.scala 60:16]
      if (io_ctl_ar_arvalid & arready) begin // @[AXI4LiteCSR.scala 74:41]
        arready <= 1'h0; // @[AXI4LiteCSR.scala 76:17]
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 39:23]
      rvalid <= 1'h0; // @[AXI4LiteCSR.scala 39:23]
    end else if (!(3'h0 == state)) begin // @[AXI4LiteCSR.scala 60:16]
      if (3'h1 == state) begin // @[AXI4LiteCSR.scala 60:16]
        rvalid <= _GEN_9;
      end else if (3'h2 == state) begin // @[AXI4LiteCSR.scala 60:16]
        rvalid <= _GEN_11;
      end
    end
    if (reset) begin // @[AXI4LiteCSR.scala 42:21]
      addr <= 32'h0; // @[AXI4LiteCSR.scala 42:21]
    end else if (3'h0 == state) begin // @[AXI4LiteCSR.scala 60:16]
      if (io_ctl_aw_awvalid) begin // @[AXI4LiteCSR.scala 62:30]
        addr <= {{28'd0}, io_ctl_aw_awaddr[5:2]}; // @[AXI4LiteCSR.scala 64:14]
      end else if (io_ctl_ar_arvalid) begin // @[AXI4LiteCSR.scala 67:36]
        addr <= {{28'd0}, io_ctl_ar_araddr[5:2]}; // @[AXI4LiteCSR.scala 69:14]
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
  addr = _RAND_6[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AXI4ReaderAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  output [31:0] io_bus_ar_araddr,
  output [7:0]  io_bus_ar_arlen,
  output        io_bus_ar_arvalid,
  input         io_bus_ar_arready,
  input  [31:0] io_bus_r_rdata,
  input         io_bus_r_rlast,
  input         io_bus_r_rvalid,
  output        io_bus_r_rready,
  input         io_dataIO_ready,
  output        io_dataIO_valid,
  output [31:0] io_dataIO_bits,
  output        io_xfer_done,
  input  [31:0] io_xfer_address,
  input  [31:0] io_xfer_length,
  input         io_xfer_valid
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[AXI4Reader.scala 34:22]
  reg  done; // @[AXI4Reader.scala 36:21]
  reg  enable; // @[AXI4Reader.scala 37:23]
  reg [31:0] araddr; // @[AXI4Reader.scala 39:23]
  reg [7:0] arlen; // @[AXI4Reader.scala 40:22]
  reg  arvalid; // @[AXI4Reader.scala 41:24]
  wire  ready = io_dataIO_ready & enable; // @[AXI4Reader.scala 44:40]
  wire  valid = io_bus_r_rvalid & enable; // @[AXI4Reader.scala 45:40]
  wire [31:0] _arlen_T_1 = io_xfer_length - 32'h1; // @[AXI4Reader.scala 64:33]
  wire  _GEN_1 = io_xfer_valid | arvalid; // @[AXI4Reader.scala 60:26 62:17 41:24]
  wire [31:0] _GEN_3 = io_xfer_valid ? _arlen_T_1 : {{24'd0}, arlen}; // @[AXI4Reader.scala 60:26 64:15 40:22]
  wire  _GEN_6 = arvalid & io_bus_ar_arready | enable; // @[AXI4Reader.scala 68:41 71:16 37:23]
  wire [1:0] _GEN_7 = io_bus_r_rlast ? 2'h3 : state; // @[AXI4Reader.scala 76:29 77:17 34:22]
  wire  _GEN_8 = io_bus_r_rlast ? 1'h0 : enable; // @[AXI4Reader.scala 76:29 78:18 37:23]
  wire [1:0] _GEN_9 = ready & valid ? _GEN_7 : state; // @[AXI4Reader.scala 34:22 75:27]
  wire  _GEN_10 = ready & valid ? _GEN_8 : enable; // @[AXI4Reader.scala 37:23 75:27]
  wire  _GEN_11 = 2'h3 == state | done; // @[AXI4Reader.scala 57:16 83:12 36:21]
  wire [1:0] _GEN_12 = 2'h3 == state ? 2'h0 : state; // @[AXI4Reader.scala 57:16 84:13 34:22]
  wire [31:0] _GEN_24 = 2'h0 == state ? _GEN_3 : {{24'd0}, arlen}; // @[AXI4Reader.scala 57:16 40:22]
  wire [31:0] _GEN_26 = reset ? 32'h0 : _GEN_24; // @[AXI4Reader.scala 40:{22,22}]
  assign io_bus_ar_araddr = araddr; // @[AXI4.scala 127:18 134:15]
  assign io_bus_ar_arlen = arlen; // @[AXI4.scala 127:18 135:14]
  assign io_bus_ar_arvalid = arvalid; // @[AXI4.scala 127:18 137:16]
  assign io_bus_r_rready = io_dataIO_ready & enable; // @[AXI4Reader.scala 44:40]
  assign io_dataIO_valid = io_bus_r_rvalid & enable; // @[AXI4Reader.scala 45:40]
  assign io_dataIO_bits = io_bus_r_rdata; // @[AXI4Reader.scala 54:18]
  assign io_xfer_done = done; // @[AXI4Reader.scala 55:16]
  always @(posedge clock) begin
    if (reset) begin // @[AXI4Reader.scala 34:22]
      state <= 2'h0; // @[AXI4Reader.scala 34:22]
    end else if (2'h0 == state) begin // @[AXI4Reader.scala 57:16]
      if (io_xfer_valid) begin // @[AXI4Reader.scala 60:26]
        state <= 2'h1; // @[AXI4Reader.scala 61:15]
      end
    end else if (2'h1 == state) begin // @[AXI4Reader.scala 57:16]
      if (arvalid & io_bus_ar_arready) begin // @[AXI4Reader.scala 68:41]
        state <= 2'h2; // @[AXI4Reader.scala 69:15]
      end
    end else if (2'h2 == state) begin // @[AXI4Reader.scala 57:16]
      state <= _GEN_9;
    end else begin
      state <= _GEN_12;
    end
    if (reset) begin // @[AXI4Reader.scala 36:21]
      done <= 1'h0; // @[AXI4Reader.scala 36:21]
    end else if (2'h0 == state) begin // @[AXI4Reader.scala 57:16]
      done <= 1'h0; // @[AXI4Reader.scala 59:12]
    end else if (!(2'h1 == state)) begin // @[AXI4Reader.scala 57:16]
      if (!(2'h2 == state)) begin // @[AXI4Reader.scala 57:16]
        done <= _GEN_11;
      end
    end
    if (reset) begin // @[AXI4Reader.scala 37:23]
      enable <= 1'h0; // @[AXI4Reader.scala 37:23]
    end else if (!(2'h0 == state)) begin // @[AXI4Reader.scala 57:16]
      if (2'h1 == state) begin // @[AXI4Reader.scala 57:16]
        enable <= _GEN_6;
      end else if (2'h2 == state) begin // @[AXI4Reader.scala 57:16]
        enable <= _GEN_10;
      end
    end
    if (reset) begin // @[AXI4Reader.scala 39:23]
      araddr <= 32'h0; // @[AXI4Reader.scala 39:23]
    end else if (2'h0 == state) begin // @[AXI4Reader.scala 57:16]
      if (io_xfer_valid) begin // @[AXI4Reader.scala 60:26]
        araddr <= io_xfer_address; // @[AXI4Reader.scala 63:16]
      end
    end
    arlen <= _GEN_26[7:0]; // @[AXI4Reader.scala 40:{22,22}]
    if (reset) begin // @[AXI4Reader.scala 41:24]
      arvalid <= 1'h0; // @[AXI4Reader.scala 41:24]
    end else if (2'h0 == state) begin // @[AXI4Reader.scala 57:16]
      arvalid <= _GEN_1;
    end else if (2'h1 == state) begin // @[AXI4Reader.scala 57:16]
      if (arvalid & io_bus_ar_arready) begin // @[AXI4Reader.scala 68:41]
        arvalid <= 1'h0; // @[AXI4Reader.scala 70:17]
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
  state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  done = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  enable = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  araddr = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  arlen = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  arvalid = _RAND_5[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AXIStreamMasterAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  output [31:0] io_bus_tdata,
  output        io_bus_tvalid,
  input         io_bus_tready,
  output        io_bus_tuser,
  output        io_bus_tlast,
  output        io_dataIO_ready,
  input         io_dataIO_valid,
  input  [31:0] io_dataIO_bits,
  output        io_xfer_done,
  input  [31:0] io_xfer_length,
  input         io_xfer_valid,
  input         io_xfer_first
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[AXIStreamMaster.scala 34:22]
  reg  done; // @[AXIStreamMaster.scala 36:21]
  reg  enable; // @[AXIStreamMaster.scala 38:23]
  reg  user; // @[AXIStreamMaster.scala 40:21]
  reg [31:0] length; // @[AXIStreamMaster.scala 42:23]
  wire  ready = io_bus_tready & enable; // @[AXIStreamMaster.scala 44:38]
  wire  valid = io_dataIO_valid & enable; // @[AXIStreamMaster.scala 45:40]
  wire  last = length == 32'h1; // @[AXIStreamMaster.scala 56:18]
  wire [31:0] _length_T_1 = length - 32'h1; // @[AXIStreamMaster.scala 73:26]
  wire [1:0] _GEN_4 = last ? 2'h2 : state; // @[AXIStreamMaster.scala 74:29 75:17 34:22]
  wire  _GEN_5 = last ? 1'h0 : enable; // @[AXIStreamMaster.scala 74:29 76:18 38:23]
  wire  _GEN_11 = 2'h2 == state | done; // @[AXIStreamMaster.scala 58:16 82:12 36:21]
  assign io_bus_tdata = io_dataIO_bits; // @[AXIStreamMaster.scala 50:16]
  assign io_bus_tvalid = io_dataIO_valid & enable; // @[AXIStreamMaster.scala 45:40]
  assign io_bus_tuser = user; // @[AXIStreamMaster.scala 52:16]
  assign io_bus_tlast = length == 32'h1; // @[AXIStreamMaster.scala 56:18]
  assign io_dataIO_ready = io_bus_tready & enable; // @[AXIStreamMaster.scala 44:38]
  assign io_xfer_done = done; // @[AXIStreamMaster.scala 54:16]
  always @(posedge clock) begin
    if (reset) begin // @[AXIStreamMaster.scala 34:22]
      state <= 2'h0; // @[AXIStreamMaster.scala 34:22]
    end else if (2'h0 == state) begin // @[AXIStreamMaster.scala 58:16]
      if (io_xfer_valid) begin // @[AXIStreamMaster.scala 63:26]
        state <= 2'h1; // @[AXIStreamMaster.scala 65:15]
      end
    end else if (2'h1 == state) begin // @[AXIStreamMaster.scala 58:16]
      if (ready & valid) begin // @[AXIStreamMaster.scala 71:27]
        state <= _GEN_4;
      end
    end else if (2'h2 == state) begin // @[AXIStreamMaster.scala 58:16]
      state <= 2'h0; // @[AXIStreamMaster.scala 81:13]
    end
    if (reset) begin // @[AXIStreamMaster.scala 36:21]
      done <= 1'h0; // @[AXIStreamMaster.scala 36:21]
    end else if (2'h0 == state) begin // @[AXIStreamMaster.scala 58:16]
      done <= 1'h0; // @[AXIStreamMaster.scala 60:12]
    end else if (!(2'h1 == state)) begin // @[AXIStreamMaster.scala 58:16]
      done <= _GEN_11;
    end
    if (reset) begin // @[AXIStreamMaster.scala 38:23]
      enable <= 1'h0; // @[AXIStreamMaster.scala 38:23]
    end else if (2'h0 == state) begin // @[AXIStreamMaster.scala 58:16]
      enable <= io_xfer_valid;
    end else if (2'h1 == state) begin // @[AXIStreamMaster.scala 58:16]
      if (ready & valid) begin // @[AXIStreamMaster.scala 71:27]
        enable <= _GEN_5;
      end
    end
    if (reset) begin // @[AXIStreamMaster.scala 40:21]
      user <= 1'h0; // @[AXIStreamMaster.scala 40:21]
    end else if (2'h0 == state) begin // @[AXIStreamMaster.scala 58:16]
      if (io_xfer_valid) begin // @[AXIStreamMaster.scala 63:26]
        user <= io_xfer_first; // @[AXIStreamMaster.scala 64:14]
      end
    end else if (2'h1 == state) begin // @[AXIStreamMaster.scala 58:16]
      if (ready & valid) begin // @[AXIStreamMaster.scala 71:27]
        user <= 1'h0; // @[AXIStreamMaster.scala 72:14]
      end
    end
    if (reset) begin // @[AXIStreamMaster.scala 42:23]
      length <= 32'h0; // @[AXIStreamMaster.scala 42:23]
    end else if (2'h0 == state) begin // @[AXIStreamMaster.scala 58:16]
      if (io_xfer_valid) begin // @[AXIStreamMaster.scala 63:26]
        length <= io_xfer_length; // @[AXIStreamMaster.scala 66:16]
      end
    end else if (2'h1 == state) begin // @[AXIStreamMaster.scala 58:16]
      if (ready & valid) begin // @[AXIStreamMaster.scala 71:27]
        length <= _length_T_1; // @[AXIStreamMaster.scala 73:16]
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
  state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  done = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  enable = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  user = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  length = _RAND_4[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CSRAXI_AXIL_AXIS(
  output [31:0] io_csr_0_dataOut,
  output        io_csr_0_dataWrite,
  input  [31:0] io_csr_0_dataIn,
  input  [31:0] io_csr_1_dataIn,
  output [31:0] io_csr_2_dataOut,
  output        io_csr_2_dataWrite,
  input  [31:0] io_csr_2_dataIn,
  output [31:0] io_csr_3_dataOut,
  output        io_csr_3_dataWrite,
  input  [31:0] io_csr_3_dataIn,
  output [31:0] io_csr_4_dataOut,
  output        io_csr_4_dataWrite,
  input  [31:0] io_csr_4_dataIn,
  output [31:0] io_csr_5_dataOut,
  output        io_csr_5_dataWrite,
  input  [31:0] io_csr_5_dataIn,
  output [31:0] io_csr_6_dataOut,
  output        io_csr_6_dataWrite,
  input  [31:0] io_csr_6_dataIn,
  output [31:0] io_csr_7_dataOut,
  output        io_csr_7_dataWrite,
  input  [31:0] io_csr_7_dataIn,
  output [31:0] io_csr_8_dataOut,
  output        io_csr_8_dataWrite,
  input  [31:0] io_csr_8_dataIn,
  output [31:0] io_csr_9_dataOut,
  output        io_csr_9_dataWrite,
  input  [31:0] io_csr_9_dataIn,
  output [31:0] io_csr_10_dataOut,
  output        io_csr_10_dataWrite,
  input  [31:0] io_csr_10_dataIn,
  output [31:0] io_csr_11_dataOut,
  output        io_csr_11_dataWrite,
  input  [31:0] io_csr_11_dataIn,
  input  [31:0] io_csr_12_dataIn,
  input  [31:0] io_csr_13_dataIn,
  output [31:0] io_csr_14_dataOut,
  output        io_csr_14_dataWrite,
  input  [31:0] io_csr_14_dataIn,
  output [31:0] io_csr_15_dataOut,
  output        io_csr_15_dataWrite,
  input  [31:0] io_csr_15_dataIn,
  input  [3:0]  io_bus_addr,
  input  [31:0] io_bus_dataOut,
  output [31:0] io_bus_dataIn,
  input         io_bus_write,
  input         io_bus_read
);
  wire  _T = io_bus_addr == 4'h0; // @[CSR.scala 32:22]
  wire [31:0] _GEN_0 = io_bus_addr == 4'h0 & io_bus_read ? io_csr_0_dataIn : 32'h0; // @[CSR.scala 32:45 33:12]
  wire [31:0] _GEN_4 = io_bus_addr == 4'h1 & io_bus_read ? io_csr_1_dataIn : _GEN_0; // @[CSR.scala 32:45 33:12]
  wire  _T_8 = io_bus_addr == 4'h2; // @[CSR.scala 32:22]
  wire [31:0] _GEN_8 = io_bus_addr == 4'h2 & io_bus_read ? io_csr_2_dataIn : _GEN_4; // @[CSR.scala 32:45 33:12]
  wire  _T_12 = io_bus_addr == 4'h3; // @[CSR.scala 32:22]
  wire [31:0] _GEN_12 = io_bus_addr == 4'h3 & io_bus_read ? io_csr_3_dataIn : _GEN_8; // @[CSR.scala 32:45 33:12]
  wire  _T_16 = io_bus_addr == 4'h4; // @[CSR.scala 32:22]
  wire [31:0] _GEN_16 = io_bus_addr == 4'h4 & io_bus_read ? io_csr_4_dataIn : _GEN_12; // @[CSR.scala 32:45 33:12]
  wire  _T_20 = io_bus_addr == 4'h5; // @[CSR.scala 32:22]
  wire [31:0] _GEN_20 = io_bus_addr == 4'h5 & io_bus_read ? io_csr_5_dataIn : _GEN_16; // @[CSR.scala 32:45 33:12]
  wire  _T_24 = io_bus_addr == 4'h6; // @[CSR.scala 32:22]
  wire [31:0] _GEN_24 = io_bus_addr == 4'h6 & io_bus_read ? io_csr_6_dataIn : _GEN_20; // @[CSR.scala 32:45 33:12]
  wire  _T_28 = io_bus_addr == 4'h7; // @[CSR.scala 32:22]
  wire [31:0] _GEN_28 = io_bus_addr == 4'h7 & io_bus_read ? io_csr_7_dataIn : _GEN_24; // @[CSR.scala 32:45 33:12]
  wire  _T_32 = io_bus_addr == 4'h8; // @[CSR.scala 32:22]
  wire [31:0] _GEN_32 = io_bus_addr == 4'h8 & io_bus_read ? io_csr_8_dataIn : _GEN_28; // @[CSR.scala 32:45 33:12]
  wire  _T_36 = io_bus_addr == 4'h9; // @[CSR.scala 32:22]
  wire [31:0] _GEN_36 = io_bus_addr == 4'h9 & io_bus_read ? io_csr_9_dataIn : _GEN_32; // @[CSR.scala 32:45 33:12]
  wire  _T_40 = io_bus_addr == 4'ha; // @[CSR.scala 32:22]
  wire [31:0] _GEN_40 = io_bus_addr == 4'ha & io_bus_read ? io_csr_10_dataIn : _GEN_36; // @[CSR.scala 32:45 33:12]
  wire  _T_44 = io_bus_addr == 4'hb; // @[CSR.scala 32:22]
  wire [31:0] _GEN_44 = io_bus_addr == 4'hb & io_bus_read ? io_csr_11_dataIn : _GEN_40; // @[CSR.scala 32:45 33:12]
  wire [31:0] _GEN_48 = io_bus_addr == 4'hc & io_bus_read ? io_csr_12_dataIn : _GEN_44; // @[CSR.scala 32:45 33:12]
  wire [31:0] _GEN_52 = io_bus_addr == 4'hd & io_bus_read ? io_csr_13_dataIn : _GEN_48; // @[CSR.scala 32:45 33:12]
  wire  _T_56 = io_bus_addr == 4'he; // @[CSR.scala 32:22]
  wire [31:0] _GEN_56 = io_bus_addr == 4'he & io_bus_read ? io_csr_14_dataIn : _GEN_52; // @[CSR.scala 32:45 33:12]
  wire  _T_60 = io_bus_addr == 4'hf; // @[CSR.scala 32:22]
  assign io_csr_0_dataOut = _T & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_0_dataWrite = _T & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_2_dataOut = _T_8 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_2_dataWrite = _T_8 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_3_dataOut = _T_12 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_3_dataWrite = _T_12 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_4_dataOut = _T_16 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_4_dataWrite = _T_16 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_5_dataOut = _T_20 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_5_dataWrite = _T_20 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_6_dataOut = _T_24 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_6_dataWrite = _T_24 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_7_dataOut = _T_28 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_7_dataWrite = _T_28 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_8_dataOut = _T_32 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_8_dataWrite = _T_32 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_9_dataOut = _T_36 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_9_dataWrite = _T_36 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_10_dataOut = _T_40 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_10_dataWrite = _T_40 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_11_dataOut = _T_44 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_11_dataWrite = _T_44 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_14_dataOut = _T_56 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_14_dataWrite = _T_56 & io_bus_write; // @[CSR.scala 39:30]
  assign io_csr_15_dataOut = _T_60 & io_bus_write ? io_bus_dataOut : 32'h0; // @[CSR.scala 39:46 40:25 44:25]
  assign io_csr_15_dataWrite = _T_60 & io_bus_write; // @[CSR.scala 39:30]
  assign io_bus_dataIn = io_bus_addr == 4'hf & io_bus_read ? io_csr_15_dataIn : _GEN_56; // @[CSR.scala 32:45 33:12]
endmodule
module AddressGeneratorAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  input         io_ctl_start,
  output        io_ctl_busy,
  input  [31:0] io_ctl_startAddress,
  input  [31:0] io_ctl_lineLength,
  input  [31:0] io_ctl_lineCount,
  input  [31:0] io_ctl_lineGap,
  input         io_xfer_done,
  output [31:0] io_xfer_address,
  output [31:0] io_xfer_length,
  output        io_xfer_valid,
  output        io_xfer_first
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[AddressGenerator.scala 29:22]
  reg [31:0] lineCount; // @[AddressGenerator.scala 31:26]
  reg [31:0] lineGap; // @[AddressGenerator.scala 32:24]
  reg [31:0] address_o; // @[AddressGenerator.scala 34:26]
  reg [31:0] address_i; // @[AddressGenerator.scala 35:26]
  reg [31:0] length_o; // @[AddressGenerator.scala 36:25]
  reg [31:0] length_i; // @[AddressGenerator.scala 37:25]
  reg  valid; // @[AddressGenerator.scala 38:22]
  reg  first; // @[AddressGenerator.scala 39:22]
  reg  busy; // @[AddressGenerator.scala 40:21]
  wire [31:0] _GEN_2 = io_ctl_start ? io_ctl_startAddress : address_i; // @[AddressGenerator.scala 56:25 59:19 35:26]
  wire  _GEN_6 = io_ctl_start | first; // @[AddressGenerator.scala 56:25 63:15 39:22]
  wire [34:0] _address_i_T = length_i * 3'h4; // @[AddressGenerator.scala 71:42]
  wire [34:0] _GEN_28 = {{3'd0}, address_i}; // @[AddressGenerator.scala 71:30]
  wire [34:0] _address_i_T_2 = _GEN_28 + _address_i_T; // @[AddressGenerator.scala 71:30]
  wire [34:0] _address_i_T_3 = lineGap * 3'h4; // @[AddressGenerator.scala 71:74]
  wire [34:0] _address_i_T_5 = _address_i_T_2 + _address_i_T_3; // @[AddressGenerator.scala 71:63]
  wire [31:0] _lineCount_T_1 = lineCount - 32'h1; // @[AddressGenerator.scala 73:30]
  wire [1:0] _GEN_7 = lineCount > 32'h0 ? 2'h1 : 2'h0; // @[AddressGenerator.scala 80:30 81:17 83:17]
  wire [1:0] _GEN_8 = io_xfer_done ? _GEN_7 : state; // @[AddressGenerator.scala 29:22 79:25]
  wire  _GEN_9 = 2'h2 == state ? 1'h0 : valid; // @[AddressGenerator.scala 54:16 77:13 38:22]
  wire  _GEN_12 = 2'h1 == state | _GEN_9; // @[AddressGenerator.scala 54:16 68:13]
  wire [34:0] _GEN_15 = 2'h1 == state ? _address_i_T_5 : {{3'd0}, address_i}; // @[AddressGenerator.scala 54:16 71:17 35:26]
  wire [34:0] _GEN_20 = 2'h0 == state ? {{3'd0}, _GEN_2} : _GEN_15; // @[AddressGenerator.scala 54:16]
  wire [34:0] _GEN_29 = reset ? 35'h0 : _GEN_20; // @[AddressGenerator.scala 35:{26,26}]
  assign io_ctl_busy = busy; // @[AddressGenerator.scala 46:15]
  assign io_xfer_address = address_o; // @[AddressGenerator.scala 42:19]
  assign io_xfer_length = length_o; // @[AddressGenerator.scala 43:18]
  assign io_xfer_valid = valid; // @[AddressGenerator.scala 44:17]
  assign io_xfer_first = first; // @[AddressGenerator.scala 45:17]
  always @(posedge clock) begin
    if (reset) begin // @[AddressGenerator.scala 29:22]
      state <= 2'h0; // @[AddressGenerator.scala 29:22]
    end else if (2'h0 == state) begin // @[AddressGenerator.scala 54:16]
      if (io_ctl_start) begin // @[AddressGenerator.scala 56:25]
        state <= 2'h1; // @[AddressGenerator.scala 57:15]
      end
    end else if (2'h1 == state) begin // @[AddressGenerator.scala 54:16]
      state <= 2'h2; // @[AddressGenerator.scala 74:13]
    end else if (2'h2 == state) begin // @[AddressGenerator.scala 54:16]
      state <= _GEN_8;
    end
    if (reset) begin // @[AddressGenerator.scala 31:26]
      lineCount <= 32'h0; // @[AddressGenerator.scala 31:26]
    end else if (2'h0 == state) begin // @[AddressGenerator.scala 54:16]
      if (io_ctl_start) begin // @[AddressGenerator.scala 56:25]
        lineCount <= io_ctl_lineCount; // @[AddressGenerator.scala 61:19]
      end
    end else if (2'h1 == state) begin // @[AddressGenerator.scala 54:16]
      lineCount <= _lineCount_T_1; // @[AddressGenerator.scala 73:17]
    end
    if (reset) begin // @[AddressGenerator.scala 32:24]
      lineGap <= 32'h0; // @[AddressGenerator.scala 32:24]
    end else if (2'h0 == state) begin // @[AddressGenerator.scala 54:16]
      if (io_ctl_start) begin // @[AddressGenerator.scala 56:25]
        lineGap <= io_ctl_lineGap; // @[AddressGenerator.scala 62:17]
      end
    end
    if (reset) begin // @[AddressGenerator.scala 34:26]
      address_o <= 32'h0; // @[AddressGenerator.scala 34:26]
    end else if (!(2'h0 == state)) begin // @[AddressGenerator.scala 54:16]
      if (2'h1 == state) begin // @[AddressGenerator.scala 54:16]
        address_o <= address_i; // @[AddressGenerator.scala 69:17]
      end
    end
    address_i <= _GEN_29[31:0]; // @[AddressGenerator.scala 35:{26,26}]
    if (reset) begin // @[AddressGenerator.scala 36:25]
      length_o <= 32'h0; // @[AddressGenerator.scala 36:25]
    end else if (!(2'h0 == state)) begin // @[AddressGenerator.scala 54:16]
      if (2'h1 == state) begin // @[AddressGenerator.scala 54:16]
        length_o <= length_i; // @[AddressGenerator.scala 70:16]
      end
    end
    if (reset) begin // @[AddressGenerator.scala 37:25]
      length_i <= 32'h0; // @[AddressGenerator.scala 37:25]
    end else if (2'h0 == state) begin // @[AddressGenerator.scala 54:16]
      if (io_ctl_start) begin // @[AddressGenerator.scala 56:25]
        length_i <= io_ctl_lineLength; // @[AddressGenerator.scala 60:18]
      end
    end
    if (reset) begin // @[AddressGenerator.scala 38:22]
      valid <= 1'h0; // @[AddressGenerator.scala 38:22]
    end else if (!(2'h0 == state)) begin // @[AddressGenerator.scala 54:16]
      valid <= _GEN_12;
    end
    if (reset) begin // @[AddressGenerator.scala 39:22]
      first <= 1'h0; // @[AddressGenerator.scala 39:22]
    end else if (2'h0 == state) begin // @[AddressGenerator.scala 54:16]
      first <= _GEN_6;
    end else if (!(2'h1 == state)) begin // @[AddressGenerator.scala 54:16]
      if (2'h2 == state) begin // @[AddressGenerator.scala 54:16]
        first <= 1'h0; // @[AddressGenerator.scala 78:13]
      end
    end
    if (reset) begin // @[AddressGenerator.scala 40:21]
      busy <= 1'h0; // @[AddressGenerator.scala 40:21]
    end else if (state == 2'h0) begin // @[AddressGenerator.scala 48:24]
      busy <= 1'h0; // @[AddressGenerator.scala 49:10]
    end else begin
      busy <= 1'h1; // @[AddressGenerator.scala 51:10]
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
  state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  lineCount = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  lineGap = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  address_o = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  address_i = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  length_o = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  length_i = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  valid = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  first = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  busy = _RAND_9[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module TransferSplitterAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  output        io_xferIn_done,
  input  [31:0] io_xferIn_address,
  input  [31:0] io_xferIn_length,
  input         io_xferIn_valid,
  input         io_xferOut_done,
  output [31:0] io_xferOut_address,
  output [31:0] io_xferOut_length,
  output        io_xferOut_valid
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
  reg [31:0] address_i; // @[TransferSplitter.scala 35:28]
  reg [31:0] length_i; // @[TransferSplitter.scala 36:27]
  reg [31:0] address_o; // @[TransferSplitter.scala 38:28]
  reg [31:0] length_o; // @[TransferSplitter.scala 39:27]
  reg  done; // @[TransferSplitter.scala 44:23]
  reg  valid; // @[TransferSplitter.scala 45:24]
  reg [1:0] state; // @[TransferSplitter.scala 47:24]
  wire [31:0] _GEN_0 = io_xferIn_valid ? io_xferIn_address : address_i; // @[TransferSplitter.scala 60:31 61:21 35:28]
  wire [31:0] _length_i_T_1 = length_i - 32'h100; // @[TransferSplitter.scala 76:34]
  wire [11:0] _address_i_T = 9'h100 * 3'h4; // @[TransferSplitter.scala 77:50]
  wire [31:0] _GEN_33 = {{20'd0}, _address_i_T}; // @[TransferSplitter.scala 77:36]
  wire [31:0] _address_i_T_2 = address_i + _GEN_33; // @[TransferSplitter.scala 77:36]
  wire [34:0] _address_i_T_3 = length_i * 3'h4; // @[TransferSplitter.scala 95:47]
  wire [34:0] _GEN_34 = {{3'd0}, address_i}; // @[TransferSplitter.scala 95:36]
  wire [34:0] _address_i_T_5 = _GEN_34 + _address_i_T_3; // @[TransferSplitter.scala 95:36]
  wire [34:0] _GEN_6 = length_i > 32'h100 ? {{3'd0}, _address_i_T_2} : _address_i_T_5; // @[TransferSplitter.scala 73:38 77:23 95:23]
  wire [1:0] _GEN_7 = length_i > 32'h0 ? 2'h1 : 2'h0; // @[TransferSplitter.scala 114:32 115:19 117:19]
  wire  _GEN_8 = length_i > 32'h0 ? done : 1'h1; // @[TransferSplitter.scala 114:32 118:18 44:23]
  wire [1:0] _GEN_9 = io_xferOut_done ? _GEN_7 : state; // @[TransferSplitter.scala 113:31 47:24]
  wire  _GEN_10 = io_xferOut_done ? _GEN_8 : done; // @[TransferSplitter.scala 113:31 44:23]
  wire  _GEN_11 = 2'h2 == state ? 1'h0 : valid; // @[TransferSplitter.scala 111:15 56:19 45:24]
  wire  _GEN_17 = 2'h1 == state | _GEN_11; // @[TransferSplitter.scala 56:19 70:15]
  wire [34:0] _GEN_21 = 2'h1 == state ? _GEN_6 : {{3'd0}, address_i}; // @[TransferSplitter.scala 56:19 35:28]
  wire [34:0] _GEN_25 = 2'h0 == state ? {{3'd0}, _GEN_0} : _GEN_21; // @[TransferSplitter.scala 56:19]
  wire [34:0] _GEN_35 = reset ? 35'h0 : _GEN_25; // @[TransferSplitter.scala 35:{28,28}]
  assign io_xferIn_done = done; // @[TransferSplitter.scala 49:20]
  assign io_xferOut_address = address_o; // @[TransferSplitter.scala 53:24]
  assign io_xferOut_length = length_o; // @[TransferSplitter.scala 54:23]
  assign io_xferOut_valid = valid; // @[TransferSplitter.scala 50:22]
  always @(posedge clock) begin
    address_i <= _GEN_35[31:0]; // @[TransferSplitter.scala 35:{28,28}]
    if (reset) begin // @[TransferSplitter.scala 36:27]
      length_i <= 32'h0; // @[TransferSplitter.scala 36:27]
    end else if (2'h0 == state) begin // @[TransferSplitter.scala 56:19]
      if (io_xferIn_valid) begin // @[TransferSplitter.scala 60:31]
        length_i <= io_xferIn_length; // @[TransferSplitter.scala 62:20]
      end
    end else if (2'h1 == state) begin // @[TransferSplitter.scala 56:19]
      if (length_i > 32'h100) begin // @[TransferSplitter.scala 73:38]
        length_i <= _length_i_T_1; // @[TransferSplitter.scala 76:22]
      end else begin
        length_i <= 32'h0; // @[TransferSplitter.scala 94:22]
      end
    end
    if (reset) begin // @[TransferSplitter.scala 38:28]
      address_o <= 32'h0; // @[TransferSplitter.scala 38:28]
    end else if (!(2'h0 == state)) begin // @[TransferSplitter.scala 56:19]
      if (2'h1 == state) begin // @[TransferSplitter.scala 56:19]
        address_o <= address_i; // @[TransferSplitter.scala 68:19]
      end
    end
    if (reset) begin // @[TransferSplitter.scala 39:27]
      length_o <= 32'h0; // @[TransferSplitter.scala 39:27]
    end else if (!(2'h0 == state)) begin // @[TransferSplitter.scala 56:19]
      if (2'h1 == state) begin // @[TransferSplitter.scala 56:19]
        if (length_i > 32'h100) begin // @[TransferSplitter.scala 73:38]
          length_o <= 32'h100; // @[TransferSplitter.scala 75:22]
        end else begin
          length_o <= length_i; // @[TransferSplitter.scala 93:22]
        end
      end
    end
    if (reset) begin // @[TransferSplitter.scala 44:23]
      done <= 1'h0; // @[TransferSplitter.scala 44:23]
    end else if (2'h0 == state) begin // @[TransferSplitter.scala 56:19]
      done <= 1'h0; // @[TransferSplitter.scala 58:14]
    end else if (!(2'h1 == state)) begin // @[TransferSplitter.scala 56:19]
      if (2'h2 == state) begin // @[TransferSplitter.scala 56:19]
        done <= _GEN_10;
      end
    end
    if (reset) begin // @[TransferSplitter.scala 45:24]
      valid <= 1'h0; // @[TransferSplitter.scala 45:24]
    end else if (!(2'h0 == state)) begin // @[TransferSplitter.scala 56:19]
      valid <= _GEN_17;
    end
    if (reset) begin // @[TransferSplitter.scala 47:24]
      state <= 2'h0; // @[TransferSplitter.scala 47:24]
    end else if (2'h0 == state) begin // @[TransferSplitter.scala 56:19]
      if (io_xferIn_valid) begin // @[TransferSplitter.scala 60:31]
        state <= 2'h1; // @[TransferSplitter.scala 64:17]
      end
    end else if (2'h1 == state) begin // @[TransferSplitter.scala 56:19]
      state <= 2'h2; // @[TransferSplitter.scala 71:15]
    end else if (2'h2 == state) begin // @[TransferSplitter.scala 56:19]
      state <= _GEN_9;
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
  address_i = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  length_i = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  address_o = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  length_o = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  done = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  valid = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  state = _RAND_6[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module TransferSplitterAXI_AXIL_AXIS_1(
  output        io_xferIn_done,
  input  [31:0] io_xferIn_length,
  input         io_xferIn_valid,
  input         io_xferIn_first,
  input         io_xferOut_done,
  output [31:0] io_xferOut_length,
  output        io_xferOut_valid,
  output        io_xferOut_first
);
  assign io_xferIn_done = io_xferOut_done; // @[TransferSplitter.scala 124:16]
  assign io_xferOut_length = io_xferIn_length; // @[TransferSplitter.scala 124:16]
  assign io_xferOut_valid = io_xferIn_valid; // @[TransferSplitter.scala 124:16]
  assign io_xferOut_first = io_xferIn_first; // @[TransferSplitter.scala 124:16]
endmodule
module ClearCSRAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  input  [31:0] io_csr_dataOut,
  input         io_csr_dataWrite,
  output [31:0] io_csr_dataIn,
  output [31:0] io_value,
  input  [31:0] io_clear
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] reg_; // @[ClearCSR.scala 28:20]
  wire [31:0] _reg_T = ~io_clear; // @[ClearCSR.scala 36:19]
  wire [31:0] _reg_T_1 = reg_ & _reg_T; // @[ClearCSR.scala 36:16]
  assign io_csr_dataIn = reg_; // @[ClearCSR.scala 30:17]
  assign io_value = reg_; // @[ClearCSR.scala 31:12]
  always @(posedge clock) begin
    if (reset) begin // @[ClearCSR.scala 28:20]
      reg_ <= 32'h0; // @[ClearCSR.scala 28:20]
    end else if (io_csr_dataWrite) begin // @[ClearCSR.scala 33:25]
      reg_ <= io_csr_dataOut; // @[ClearCSR.scala 34:9]
    end else begin
      reg_ <= _reg_T_1; // @[ClearCSR.scala 36:9]
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
  reg_ = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module StatusCSRAXI_AXIL_AXIS(
  input         clock,
  output [31:0] io_csr_dataIn,
  input  [31:0] io_value
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] reg_; // @[StatusCSR.scala 27:20]
  assign io_csr_dataIn = reg_; // @[StatusCSR.scala 29:17]
  always @(posedge clock) begin
    reg_ <= io_value; // @[StatusCSR.scala 27:20]
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
  reg_ = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SimpleCSRAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  input  [31:0] io_csr_dataOut,
  input         io_csr_dataWrite,
  output [31:0] io_csr_dataIn,
  output [31:0] io_value
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] reg_; // @[SimpleCSR.scala 27:20]
  assign io_csr_dataIn = reg_; // @[SimpleCSR.scala 29:17]
  assign io_value = reg_; // @[SimpleCSR.scala 30:12]
  always @(posedge clock) begin
    if (reset) begin // @[SimpleCSR.scala 27:20]
      reg_ <= 32'h0; // @[SimpleCSR.scala 27:20]
    end else if (io_csr_dataWrite) begin // @[SimpleCSR.scala 32:25]
      reg_ <= io_csr_dataOut; // @[SimpleCSR.scala 33:9]
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
  reg_ = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SetCSRAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  input  [31:0] io_csr_dataOut,
  input         io_csr_dataWrite,
  output [31:0] io_csr_dataIn,
  output [31:0] io_value,
  input  [31:0] io_set
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] reg_; // @[SetCSR.scala 28:20]
  wire [31:0] _reg_T = ~io_csr_dataOut; // @[SetCSR.scala 34:20]
  wire [31:0] _reg_T_1 = reg_ & _reg_T; // @[SetCSR.scala 34:17]
  wire [31:0] _reg_T_2 = _reg_T_1 | io_set; // @[SetCSR.scala 34:45]
  wire [31:0] _reg_T_3 = reg_ | io_set; // @[SetCSR.scala 36:16]
  assign io_csr_dataIn = reg_; // @[SetCSR.scala 30:17]
  assign io_value = reg_; // @[SetCSR.scala 31:12]
  always @(posedge clock) begin
    if (reset) begin // @[SetCSR.scala 28:20]
      reg_ <= 32'h0; // @[SetCSR.scala 28:20]
    end else if (io_csr_dataWrite) begin // @[SetCSR.scala 33:25]
      reg_ <= _reg_T_2; // @[SetCSR.scala 34:9]
    end else begin
      reg_ <= _reg_T_3; // @[SetCSR.scala 36:9]
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
  reg_ = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module InterruptControllerAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  output        io_irq_readerDone,
  output        io_irq_writerDone,
  input         io_readBusy,
  input         io_writeBusy,
  input  [31:0] io_imr_dataOut,
  input         io_imr_dataWrite,
  output [31:0] io_imr_dataIn,
  input  [31:0] io_isr_dataOut,
  input         io_isr_dataWrite,
  output [31:0] io_isr_dataIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  wire  mask_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  mask_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] mask_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  mask_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] mask_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] mask_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  isr_csr_clock; // @[SetCSR.scala 43:21]
  wire  isr_csr_reset; // @[SetCSR.scala 43:21]
  wire [31:0] isr_csr_io_csr_dataOut; // @[SetCSR.scala 43:21]
  wire  isr_csr_io_csr_dataWrite; // @[SetCSR.scala 43:21]
  wire [31:0] isr_csr_io_csr_dataIn; // @[SetCSR.scala 43:21]
  wire [31:0] isr_csr_io_value; // @[SetCSR.scala 43:21]
  wire [31:0] isr_csr_io_set; // @[SetCSR.scala 43:21]
  reg  readBusy; // @[InterruptController.scala 33:25]
  reg  readBusyOld; // @[InterruptController.scala 34:28]
  reg  writeBusy; // @[InterruptController.scala 36:26]
  reg  writeBusyOld; // @[InterruptController.scala 37:29]
  reg  writeBusyIrq; // @[InterruptController.scala 39:29]
  reg  readBusyIrq; // @[InterruptController.scala 40:28]
  wire [31:0] mask = mask_csr_io_value;
  wire [1:0] irq = {readBusyIrq,writeBusyIrq}; // @[Cat.scala 33:92]
  wire [31:0] isr = isr_csr_io_value;
  SimpleCSRAXI_AXIL_AXIS mask_csr ( // @[SimpleCSR.scala 40:21]
    .clock(mask_csr_clock),
    .reset(mask_csr_reset),
    .io_csr_dataOut(mask_csr_io_csr_dataOut),
    .io_csr_dataWrite(mask_csr_io_csr_dataWrite),
    .io_csr_dataIn(mask_csr_io_csr_dataIn),
    .io_value(mask_csr_io_value)
  );
  SetCSRAXI_AXIL_AXIS isr_csr ( // @[SetCSR.scala 43:21]
    .clock(isr_csr_clock),
    .reset(isr_csr_reset),
    .io_csr_dataOut(isr_csr_io_csr_dataOut),
    .io_csr_dataWrite(isr_csr_io_csr_dataWrite),
    .io_csr_dataIn(isr_csr_io_csr_dataIn),
    .io_value(isr_csr_io_value),
    .io_set(isr_csr_io_set)
  );
  assign io_irq_readerDone = isr[1]; // @[InterruptController.scala 50:27]
  assign io_irq_writerDone = isr[0]; // @[InterruptController.scala 49:27]
  assign io_imr_dataIn = mask_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_isr_dataIn = isr_csr_io_csr_dataIn; // @[SetCSR.scala 47:16]
  assign mask_csr_clock = clock;
  assign mask_csr_reset = reset;
  assign mask_csr_io_csr_dataOut = io_imr_dataOut; // @[SimpleCSR.scala 42:16]
  assign mask_csr_io_csr_dataWrite = io_imr_dataWrite; // @[SimpleCSR.scala 42:16]
  assign isr_csr_clock = clock;
  assign isr_csr_reset = reset;
  assign isr_csr_io_csr_dataOut = io_isr_dataOut; // @[SetCSR.scala 47:16]
  assign isr_csr_io_csr_dataWrite = io_isr_dataWrite; // @[SetCSR.scala 47:16]
  assign isr_csr_io_set = {{30'd0}, irq}; // @[SetCSR.scala 45:16]
  always @(posedge clock) begin
    readBusy <= io_readBusy; // @[InterruptController.scala 33:25]
    readBusyOld <= readBusy; // @[InterruptController.scala 34:28]
    writeBusy <= io_writeBusy; // @[InterruptController.scala 36:26]
    writeBusyOld <= writeBusy; // @[InterruptController.scala 37:29]
    if (reset) begin // @[InterruptController.scala 39:29]
      writeBusyIrq <= 1'h0; // @[InterruptController.scala 39:29]
    end else begin
      writeBusyIrq <= writeBusyOld & ~writeBusy & mask[0]; // @[InterruptController.scala 42:16]
    end
    if (reset) begin // @[InterruptController.scala 40:28]
      readBusyIrq <= 1'h0; // @[InterruptController.scala 40:28]
    end else begin
      readBusyIrq <= readBusyOld & ~readBusy & mask[1]; // @[InterruptController.scala 43:15]
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
  readBusy = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  readBusyOld = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  writeBusy = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  writeBusyOld = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  writeBusyIrq = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  readBusyIrq = _RAND_5[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module WorkerCSRWrapperAXI_AXIL_AXIS(
  input         clock,
  input         reset,
  input  [31:0] io_csr_0_dataOut,
  input         io_csr_0_dataWrite,
  output [31:0] io_csr_0_dataIn,
  output [31:0] io_csr_1_dataIn,
  input  [31:0] io_csr_2_dataOut,
  input         io_csr_2_dataWrite,
  output [31:0] io_csr_2_dataIn,
  input  [31:0] io_csr_3_dataOut,
  input         io_csr_3_dataWrite,
  output [31:0] io_csr_3_dataIn,
  input  [31:0] io_csr_4_dataOut,
  input         io_csr_4_dataWrite,
  output [31:0] io_csr_4_dataIn,
  input  [31:0] io_csr_5_dataOut,
  input         io_csr_5_dataWrite,
  output [31:0] io_csr_5_dataIn,
  input  [31:0] io_csr_6_dataOut,
  input         io_csr_6_dataWrite,
  output [31:0] io_csr_6_dataIn,
  input  [31:0] io_csr_7_dataOut,
  input         io_csr_7_dataWrite,
  output [31:0] io_csr_7_dataIn,
  input  [31:0] io_csr_8_dataOut,
  input         io_csr_8_dataWrite,
  output [31:0] io_csr_8_dataIn,
  input  [31:0] io_csr_9_dataOut,
  input         io_csr_9_dataWrite,
  output [31:0] io_csr_9_dataIn,
  input  [31:0] io_csr_10_dataOut,
  input         io_csr_10_dataWrite,
  output [31:0] io_csr_10_dataIn,
  input  [31:0] io_csr_11_dataOut,
  input         io_csr_11_dataWrite,
  output [31:0] io_csr_11_dataIn,
  output [31:0] io_csr_12_dataIn,
  output [31:0] io_csr_13_dataIn,
  input  [31:0] io_csr_14_dataOut,
  input         io_csr_14_dataWrite,
  output [31:0] io_csr_14_dataIn,
  input  [31:0] io_csr_15_dataOut,
  input         io_csr_15_dataWrite,
  output [31:0] io_csr_15_dataIn,
  output        io_irq_readerDone,
  output        io_irq_writerDone,
  input         io_sync_readerSync,
  input         io_sync_writerSync,
  input         io_xferRead_done,
  output [31:0] io_xferRead_address,
  output [31:0] io_xferRead_length,
  output        io_xferRead_valid,
  input         io_xferWrite_done,
  output [31:0] io_xferWrite_length,
  output        io_xferWrite_valid,
  output        io_xferWrite_first
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
  wire  addressGeneratorRead_clock; // @[WorkerCSRWrapper.scala 34:36]
  wire  addressGeneratorRead_reset; // @[WorkerCSRWrapper.scala 34:36]
  wire  addressGeneratorRead_io_ctl_start; // @[WorkerCSRWrapper.scala 34:36]
  wire  addressGeneratorRead_io_ctl_busy; // @[WorkerCSRWrapper.scala 34:36]
  wire [31:0] addressGeneratorRead_io_ctl_startAddress; // @[WorkerCSRWrapper.scala 34:36]
  wire [31:0] addressGeneratorRead_io_ctl_lineLength; // @[WorkerCSRWrapper.scala 34:36]
  wire [31:0] addressGeneratorRead_io_ctl_lineCount; // @[WorkerCSRWrapper.scala 34:36]
  wire [31:0] addressGeneratorRead_io_ctl_lineGap; // @[WorkerCSRWrapper.scala 34:36]
  wire  addressGeneratorRead_io_xfer_done; // @[WorkerCSRWrapper.scala 34:36]
  wire [31:0] addressGeneratorRead_io_xfer_address; // @[WorkerCSRWrapper.scala 34:36]
  wire [31:0] addressGeneratorRead_io_xfer_length; // @[WorkerCSRWrapper.scala 34:36]
  wire  addressGeneratorRead_io_xfer_valid; // @[WorkerCSRWrapper.scala 34:36]
  wire  addressGeneratorRead_io_xfer_first; // @[WorkerCSRWrapper.scala 34:36]
  wire  transferSplitterRead_clock; // @[WorkerCSRWrapper.scala 35:36]
  wire  transferSplitterRead_reset; // @[WorkerCSRWrapper.scala 35:36]
  wire  transferSplitterRead_io_xferIn_done; // @[WorkerCSRWrapper.scala 35:36]
  wire [31:0] transferSplitterRead_io_xferIn_address; // @[WorkerCSRWrapper.scala 35:36]
  wire [31:0] transferSplitterRead_io_xferIn_length; // @[WorkerCSRWrapper.scala 35:36]
  wire  transferSplitterRead_io_xferIn_valid; // @[WorkerCSRWrapper.scala 35:36]
  wire  transferSplitterRead_io_xferOut_done; // @[WorkerCSRWrapper.scala 35:36]
  wire [31:0] transferSplitterRead_io_xferOut_address; // @[WorkerCSRWrapper.scala 35:36]
  wire [31:0] transferSplitterRead_io_xferOut_length; // @[WorkerCSRWrapper.scala 35:36]
  wire  transferSplitterRead_io_xferOut_valid; // @[WorkerCSRWrapper.scala 35:36]
  wire  addressGeneratorWrite_clock; // @[WorkerCSRWrapper.scala 37:37]
  wire  addressGeneratorWrite_reset; // @[WorkerCSRWrapper.scala 37:37]
  wire  addressGeneratorWrite_io_ctl_start; // @[WorkerCSRWrapper.scala 37:37]
  wire  addressGeneratorWrite_io_ctl_busy; // @[WorkerCSRWrapper.scala 37:37]
  wire [31:0] addressGeneratorWrite_io_ctl_startAddress; // @[WorkerCSRWrapper.scala 37:37]
  wire [31:0] addressGeneratorWrite_io_ctl_lineLength; // @[WorkerCSRWrapper.scala 37:37]
  wire [31:0] addressGeneratorWrite_io_ctl_lineCount; // @[WorkerCSRWrapper.scala 37:37]
  wire [31:0] addressGeneratorWrite_io_ctl_lineGap; // @[WorkerCSRWrapper.scala 37:37]
  wire  addressGeneratorWrite_io_xfer_done; // @[WorkerCSRWrapper.scala 37:37]
  wire [31:0] addressGeneratorWrite_io_xfer_address; // @[WorkerCSRWrapper.scala 37:37]
  wire [31:0] addressGeneratorWrite_io_xfer_length; // @[WorkerCSRWrapper.scala 37:37]
  wire  addressGeneratorWrite_io_xfer_valid; // @[WorkerCSRWrapper.scala 37:37]
  wire  addressGeneratorWrite_io_xfer_first; // @[WorkerCSRWrapper.scala 37:37]
  wire  transferSplitterWrite_io_xferIn_done; // @[WorkerCSRWrapper.scala 38:37]
  wire [31:0] transferSplitterWrite_io_xferIn_length; // @[WorkerCSRWrapper.scala 38:37]
  wire  transferSplitterWrite_io_xferIn_valid; // @[WorkerCSRWrapper.scala 38:37]
  wire  transferSplitterWrite_io_xferIn_first; // @[WorkerCSRWrapper.scala 38:37]
  wire  transferSplitterWrite_io_xferOut_done; // @[WorkerCSRWrapper.scala 38:37]
  wire [31:0] transferSplitterWrite_io_xferOut_length; // @[WorkerCSRWrapper.scala 38:37]
  wire  transferSplitterWrite_io_xferOut_valid; // @[WorkerCSRWrapper.scala 38:37]
  wire  transferSplitterWrite_io_xferOut_first; // @[WorkerCSRWrapper.scala 38:37]
  wire  control_csr_clock; // @[ClearCSR.scala 42:21]
  wire  control_csr_reset; // @[ClearCSR.scala 42:21]
  wire [31:0] control_csr_io_csr_dataOut; // @[ClearCSR.scala 42:21]
  wire  control_csr_io_csr_dataWrite; // @[ClearCSR.scala 42:21]
  wire [31:0] control_csr_io_csr_dataIn; // @[ClearCSR.scala 42:21]
  wire [31:0] control_csr_io_value; // @[ClearCSR.scala 42:21]
  wire [31:0] control_csr_io_clear; // @[ClearCSR.scala 42:21]
  wire  csr_clock; // @[StatusCSR.scala 34:21]
  wire [31:0] csr_io_csr_dataIn; // @[StatusCSR.scala 34:21]
  wire [31:0] csr_io_value; // @[StatusCSR.scala 34:21]
  wire  io_irq_irqc_clock; // @[InterruptController.scala 55:22]
  wire  io_irq_irqc_reset; // @[InterruptController.scala 55:22]
  wire  io_irq_irqc_io_irq_readerDone; // @[InterruptController.scala 55:22]
  wire  io_irq_irqc_io_irq_writerDone; // @[InterruptController.scala 55:22]
  wire  io_irq_irqc_io_readBusy; // @[InterruptController.scala 55:22]
  wire  io_irq_irqc_io_writeBusy; // @[InterruptController.scala 55:22]
  wire [31:0] io_irq_irqc_io_imr_dataOut; // @[InterruptController.scala 55:22]
  wire  io_irq_irqc_io_imr_dataWrite; // @[InterruptController.scala 55:22]
  wire [31:0] io_irq_irqc_io_imr_dataIn; // @[InterruptController.scala 55:22]
  wire [31:0] io_irq_irqc_io_isr_dataOut; // @[InterruptController.scala 55:22]
  wire  io_irq_irqc_io_isr_dataWrite; // @[InterruptController.scala 55:22]
  wire [31:0] io_irq_irqc_io_isr_dataIn; // @[InterruptController.scala 55:22]
  wire  addressGeneratorRead_io_ctl_startAddress_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_startAddress_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_startAddress_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineLength_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineLength_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineLength_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineCount_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineCount_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineCount_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineGap_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineGap_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorRead_io_ctl_lineGap_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_startAddress_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_startAddress_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_startAddress_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineLength_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineLength_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineLength_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineCount_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineCount_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineCount_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineGap_csr_clock; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineGap_csr_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] addressGeneratorWrite_io_ctl_lineGap_csr_io_value; // @[SimpleCSR.scala 40:21]
  wire  csr_1_clock; // @[StatusCSR.scala 34:21]
  wire [31:0] csr_1_io_csr_dataIn; // @[StatusCSR.scala 34:21]
  wire [31:0] csr_1_io_value; // @[StatusCSR.scala 34:21]
  wire  csr_2_clock; // @[StatusCSR.scala 34:21]
  wire [31:0] csr_2_io_csr_dataIn; // @[StatusCSR.scala 34:21]
  wire [31:0] csr_2_io_value; // @[StatusCSR.scala 34:21]
  wire  csr_3_clock; // @[SimpleCSR.scala 40:21]
  wire  csr_3_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] csr_3_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  csr_3_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] csr_3_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] csr_3_io_value; // @[SimpleCSR.scala 40:21]
  wire  csr_4_clock; // @[SimpleCSR.scala 40:21]
  wire  csr_4_reset; // @[SimpleCSR.scala 40:21]
  wire [31:0] csr_4_io_csr_dataOut; // @[SimpleCSR.scala 40:21]
  wire  csr_4_io_csr_dataWrite; // @[SimpleCSR.scala 40:21]
  wire [31:0] csr_4_io_csr_dataIn; // @[SimpleCSR.scala 40:21]
  wire [31:0] csr_4_io_value; // @[SimpleCSR.scala 40:21]
  reg [1:0] status; // @[WorkerCSRWrapper.scala 40:23]
  reg  readerSync; // @[WorkerCSRWrapper.scala 42:27]
  reg  readerSyncOld; // @[WorkerCSRWrapper.scala 43:30]
  reg  writerSync; // @[WorkerCSRWrapper.scala 45:27]
  reg  writerSyncOld; // @[WorkerCSRWrapper.scala 46:30]
  reg  readerStart; // @[WorkerCSRWrapper.scala 48:28]
  reg  writerStart; // @[WorkerCSRWrapper.scala 49:28]
  wire [1:0] _clear_T = {readerStart,writerStart}; // @[Cat.scala 33:92]
  wire [31:0] control = control_csr_io_value; // @[WorkerCSRWrapper.scala 51:21 60:11]
  wire [1:0] _clear_T_3 = {control[5],control[4]}; // @[Cat.scala 33:92]
  wire [1:0] _clear_T_4 = ~_clear_T_3; // @[WorkerCSRWrapper.scala 67:44]
  wire [1:0] clear = _clear_T & _clear_T_4; // @[WorkerCSRWrapper.scala 67:42]
  AddressGeneratorAXI_AXIL_AXIS addressGeneratorRead ( // @[WorkerCSRWrapper.scala 34:36]
    .clock(addressGeneratorRead_clock),
    .reset(addressGeneratorRead_reset),
    .io_ctl_start(addressGeneratorRead_io_ctl_start),
    .io_ctl_busy(addressGeneratorRead_io_ctl_busy),
    .io_ctl_startAddress(addressGeneratorRead_io_ctl_startAddress),
    .io_ctl_lineLength(addressGeneratorRead_io_ctl_lineLength),
    .io_ctl_lineCount(addressGeneratorRead_io_ctl_lineCount),
    .io_ctl_lineGap(addressGeneratorRead_io_ctl_lineGap),
    .io_xfer_done(addressGeneratorRead_io_xfer_done),
    .io_xfer_address(addressGeneratorRead_io_xfer_address),
    .io_xfer_length(addressGeneratorRead_io_xfer_length),
    .io_xfer_valid(addressGeneratorRead_io_xfer_valid),
    .io_xfer_first(addressGeneratorRead_io_xfer_first)
  );
  TransferSplitterAXI_AXIL_AXIS transferSplitterRead ( // @[WorkerCSRWrapper.scala 35:36]
    .clock(transferSplitterRead_clock),
    .reset(transferSplitterRead_reset),
    .io_xferIn_done(transferSplitterRead_io_xferIn_done),
    .io_xferIn_address(transferSplitterRead_io_xferIn_address),
    .io_xferIn_length(transferSplitterRead_io_xferIn_length),
    .io_xferIn_valid(transferSplitterRead_io_xferIn_valid),
    .io_xferOut_done(transferSplitterRead_io_xferOut_done),
    .io_xferOut_address(transferSplitterRead_io_xferOut_address),
    .io_xferOut_length(transferSplitterRead_io_xferOut_length),
    .io_xferOut_valid(transferSplitterRead_io_xferOut_valid)
  );
  AddressGeneratorAXI_AXIL_AXIS addressGeneratorWrite ( // @[WorkerCSRWrapper.scala 37:37]
    .clock(addressGeneratorWrite_clock),
    .reset(addressGeneratorWrite_reset),
    .io_ctl_start(addressGeneratorWrite_io_ctl_start),
    .io_ctl_busy(addressGeneratorWrite_io_ctl_busy),
    .io_ctl_startAddress(addressGeneratorWrite_io_ctl_startAddress),
    .io_ctl_lineLength(addressGeneratorWrite_io_ctl_lineLength),
    .io_ctl_lineCount(addressGeneratorWrite_io_ctl_lineCount),
    .io_ctl_lineGap(addressGeneratorWrite_io_ctl_lineGap),
    .io_xfer_done(addressGeneratorWrite_io_xfer_done),
    .io_xfer_address(addressGeneratorWrite_io_xfer_address),
    .io_xfer_length(addressGeneratorWrite_io_xfer_length),
    .io_xfer_valid(addressGeneratorWrite_io_xfer_valid),
    .io_xfer_first(addressGeneratorWrite_io_xfer_first)
  );
  TransferSplitterAXI_AXIL_AXIS_1 transferSplitterWrite ( // @[WorkerCSRWrapper.scala 38:37]
    .io_xferIn_done(transferSplitterWrite_io_xferIn_done),
    .io_xferIn_length(transferSplitterWrite_io_xferIn_length),
    .io_xferIn_valid(transferSplitterWrite_io_xferIn_valid),
    .io_xferIn_first(transferSplitterWrite_io_xferIn_first),
    .io_xferOut_done(transferSplitterWrite_io_xferOut_done),
    .io_xferOut_length(transferSplitterWrite_io_xferOut_length),
    .io_xferOut_valid(transferSplitterWrite_io_xferOut_valid),
    .io_xferOut_first(transferSplitterWrite_io_xferOut_first)
  );
  ClearCSRAXI_AXIL_AXIS control_csr ( // @[ClearCSR.scala 42:21]
    .clock(control_csr_clock),
    .reset(control_csr_reset),
    .io_csr_dataOut(control_csr_io_csr_dataOut),
    .io_csr_dataWrite(control_csr_io_csr_dataWrite),
    .io_csr_dataIn(control_csr_io_csr_dataIn),
    .io_value(control_csr_io_value),
    .io_clear(control_csr_io_clear)
  );
  StatusCSRAXI_AXIL_AXIS csr ( // @[StatusCSR.scala 34:21]
    .clock(csr_clock),
    .io_csr_dataIn(csr_io_csr_dataIn),
    .io_value(csr_io_value)
  );
  InterruptControllerAXI_AXIL_AXIS io_irq_irqc ( // @[InterruptController.scala 55:22]
    .clock(io_irq_irqc_clock),
    .reset(io_irq_irqc_reset),
    .io_irq_readerDone(io_irq_irqc_io_irq_readerDone),
    .io_irq_writerDone(io_irq_irqc_io_irq_writerDone),
    .io_readBusy(io_irq_irqc_io_readBusy),
    .io_writeBusy(io_irq_irqc_io_writeBusy),
    .io_imr_dataOut(io_irq_irqc_io_imr_dataOut),
    .io_imr_dataWrite(io_irq_irqc_io_imr_dataWrite),
    .io_imr_dataIn(io_irq_irqc_io_imr_dataIn),
    .io_isr_dataOut(io_irq_irqc_io_isr_dataOut),
    .io_isr_dataWrite(io_irq_irqc_io_isr_dataWrite),
    .io_isr_dataIn(io_irq_irqc_io_isr_dataIn)
  );
  SimpleCSRAXI_AXIL_AXIS addressGeneratorRead_io_ctl_startAddress_csr ( // @[SimpleCSR.scala 40:21]
    .clock(addressGeneratorRead_io_ctl_startAddress_csr_clock),
    .reset(addressGeneratorRead_io_ctl_startAddress_csr_reset),
    .io_csr_dataOut(addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataOut),
    .io_csr_dataWrite(addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataWrite),
    .io_csr_dataIn(addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataIn),
    .io_value(addressGeneratorRead_io_ctl_startAddress_csr_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS addressGeneratorRead_io_ctl_lineLength_csr ( // @[SimpleCSR.scala 40:21]
    .clock(addressGeneratorRead_io_ctl_lineLength_csr_clock),
    .reset(addressGeneratorRead_io_ctl_lineLength_csr_reset),
    .io_csr_dataOut(addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataOut),
    .io_csr_dataWrite(addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataWrite),
    .io_csr_dataIn(addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataIn),
    .io_value(addressGeneratorRead_io_ctl_lineLength_csr_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS addressGeneratorRead_io_ctl_lineCount_csr ( // @[SimpleCSR.scala 40:21]
    .clock(addressGeneratorRead_io_ctl_lineCount_csr_clock),
    .reset(addressGeneratorRead_io_ctl_lineCount_csr_reset),
    .io_csr_dataOut(addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataOut),
    .io_csr_dataWrite(addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataWrite),
    .io_csr_dataIn(addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataIn),
    .io_value(addressGeneratorRead_io_ctl_lineCount_csr_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS addressGeneratorRead_io_ctl_lineGap_csr ( // @[SimpleCSR.scala 40:21]
    .clock(addressGeneratorRead_io_ctl_lineGap_csr_clock),
    .reset(addressGeneratorRead_io_ctl_lineGap_csr_reset),
    .io_csr_dataOut(addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataOut),
    .io_csr_dataWrite(addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataWrite),
    .io_csr_dataIn(addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataIn),
    .io_value(addressGeneratorRead_io_ctl_lineGap_csr_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS addressGeneratorWrite_io_ctl_startAddress_csr ( // @[SimpleCSR.scala 40:21]
    .clock(addressGeneratorWrite_io_ctl_startAddress_csr_clock),
    .reset(addressGeneratorWrite_io_ctl_startAddress_csr_reset),
    .io_csr_dataOut(addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataOut),
    .io_csr_dataWrite(addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataWrite),
    .io_csr_dataIn(addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataIn),
    .io_value(addressGeneratorWrite_io_ctl_startAddress_csr_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS addressGeneratorWrite_io_ctl_lineLength_csr ( // @[SimpleCSR.scala 40:21]
    .clock(addressGeneratorWrite_io_ctl_lineLength_csr_clock),
    .reset(addressGeneratorWrite_io_ctl_lineLength_csr_reset),
    .io_csr_dataOut(addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataOut),
    .io_csr_dataWrite(addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataWrite),
    .io_csr_dataIn(addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataIn),
    .io_value(addressGeneratorWrite_io_ctl_lineLength_csr_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS addressGeneratorWrite_io_ctl_lineCount_csr ( // @[SimpleCSR.scala 40:21]
    .clock(addressGeneratorWrite_io_ctl_lineCount_csr_clock),
    .reset(addressGeneratorWrite_io_ctl_lineCount_csr_reset),
    .io_csr_dataOut(addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataOut),
    .io_csr_dataWrite(addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataWrite),
    .io_csr_dataIn(addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataIn),
    .io_value(addressGeneratorWrite_io_ctl_lineCount_csr_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS addressGeneratorWrite_io_ctl_lineGap_csr ( // @[SimpleCSR.scala 40:21]
    .clock(addressGeneratorWrite_io_ctl_lineGap_csr_clock),
    .reset(addressGeneratorWrite_io_ctl_lineGap_csr_reset),
    .io_csr_dataOut(addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataOut),
    .io_csr_dataWrite(addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataWrite),
    .io_csr_dataIn(addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataIn),
    .io_value(addressGeneratorWrite_io_ctl_lineGap_csr_io_value)
  );
  StatusCSRAXI_AXIL_AXIS csr_1 ( // @[StatusCSR.scala 34:21]
    .clock(csr_1_clock),
    .io_csr_dataIn(csr_1_io_csr_dataIn),
    .io_value(csr_1_io_value)
  );
  StatusCSRAXI_AXIL_AXIS csr_2 ( // @[StatusCSR.scala 34:21]
    .clock(csr_2_clock),
    .io_csr_dataIn(csr_2_io_csr_dataIn),
    .io_value(csr_2_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS csr_3 ( // @[SimpleCSR.scala 40:21]
    .clock(csr_3_clock),
    .reset(csr_3_reset),
    .io_csr_dataOut(csr_3_io_csr_dataOut),
    .io_csr_dataWrite(csr_3_io_csr_dataWrite),
    .io_csr_dataIn(csr_3_io_csr_dataIn),
    .io_value(csr_3_io_value)
  );
  SimpleCSRAXI_AXIL_AXIS csr_4 ( // @[SimpleCSR.scala 40:21]
    .clock(csr_4_clock),
    .reset(csr_4_reset),
    .io_csr_dataOut(csr_4_io_csr_dataOut),
    .io_csr_dataWrite(csr_4_io_csr_dataWrite),
    .io_csr_dataIn(csr_4_io_csr_dataIn),
    .io_value(csr_4_io_value)
  );
  assign io_csr_0_dataIn = control_csr_io_csr_dataIn; // @[ClearCSR.scala 46:16]
  assign io_csr_1_dataIn = csr_io_csr_dataIn; // @[StatusCSR.scala 36:16]
  assign io_csr_2_dataIn = io_irq_irqc_io_imr_dataIn; // @[InterruptController.scala 60:17]
  assign io_csr_3_dataIn = io_irq_irqc_io_isr_dataIn; // @[InterruptController.scala 61:17]
  assign io_csr_4_dataIn = addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_5_dataIn = addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_6_dataIn = addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_7_dataIn = addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_8_dataIn = addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_9_dataIn = addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_10_dataIn = addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_11_dataIn = addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_12_dataIn = csr_1_io_csr_dataIn; // @[StatusCSR.scala 36:16]
  assign io_csr_13_dataIn = csr_2_io_csr_dataIn; // @[StatusCSR.scala 36:16]
  assign io_csr_14_dataIn = csr_3_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_csr_15_dataIn = csr_4_io_csr_dataIn; // @[SimpleCSR.scala 42:16]
  assign io_irq_readerDone = io_irq_irqc_io_irq_readerDone; // @[WorkerCSRWrapper.scala 64:10]
  assign io_irq_writerDone = io_irq_irqc_io_irq_writerDone; // @[WorkerCSRWrapper.scala 64:10]
  assign io_xferRead_address = transferSplitterRead_io_xferOut_address; // @[WorkerCSRWrapper.scala 92:15]
  assign io_xferRead_length = transferSplitterRead_io_xferOut_length; // @[WorkerCSRWrapper.scala 92:15]
  assign io_xferRead_valid = transferSplitterRead_io_xferOut_valid; // @[WorkerCSRWrapper.scala 92:15]
  assign io_xferWrite_length = transferSplitterWrite_io_xferOut_length; // @[WorkerCSRWrapper.scala 95:16]
  assign io_xferWrite_valid = transferSplitterWrite_io_xferOut_valid; // @[WorkerCSRWrapper.scala 95:16]
  assign io_xferWrite_first = transferSplitterWrite_io_xferOut_first; // @[WorkerCSRWrapper.scala 95:16]
  assign addressGeneratorRead_clock = clock;
  assign addressGeneratorRead_reset = reset;
  assign addressGeneratorRead_io_ctl_start = readerStart; // @[WorkerCSRWrapper.scala 72:37]
  assign addressGeneratorRead_io_ctl_startAddress = addressGeneratorRead_io_ctl_startAddress_csr_io_value; // @[WorkerCSRWrapper.scala 73:44]
  assign addressGeneratorRead_io_ctl_lineLength = addressGeneratorRead_io_ctl_lineLength_csr_io_value; // @[WorkerCSRWrapper.scala 74:42]
  assign addressGeneratorRead_io_ctl_lineCount = addressGeneratorRead_io_ctl_lineCount_csr_io_value; // @[WorkerCSRWrapper.scala 75:41]
  assign addressGeneratorRead_io_ctl_lineGap = addressGeneratorRead_io_ctl_lineGap_csr_io_value; // @[WorkerCSRWrapper.scala 76:39]
  assign addressGeneratorRead_io_xfer_done = transferSplitterRead_io_xferIn_done; // @[WorkerCSRWrapper.scala 91:34]
  assign transferSplitterRead_clock = clock;
  assign transferSplitterRead_reset = reset;
  assign transferSplitterRead_io_xferIn_address = addressGeneratorRead_io_xfer_address; // @[WorkerCSRWrapper.scala 91:34]
  assign transferSplitterRead_io_xferIn_length = addressGeneratorRead_io_xfer_length; // @[WorkerCSRWrapper.scala 91:34]
  assign transferSplitterRead_io_xferIn_valid = addressGeneratorRead_io_xfer_valid; // @[WorkerCSRWrapper.scala 91:34]
  assign transferSplitterRead_io_xferOut_done = io_xferRead_done; // @[WorkerCSRWrapper.scala 92:15]
  assign addressGeneratorWrite_clock = clock;
  assign addressGeneratorWrite_reset = reset;
  assign addressGeneratorWrite_io_ctl_start = writerStart; // @[WorkerCSRWrapper.scala 78:38]
  assign addressGeneratorWrite_io_ctl_startAddress = addressGeneratorWrite_io_ctl_startAddress_csr_io_value; // @[WorkerCSRWrapper.scala 79:45]
  assign addressGeneratorWrite_io_ctl_lineLength = addressGeneratorWrite_io_ctl_lineLength_csr_io_value; // @[WorkerCSRWrapper.scala 80:43]
  assign addressGeneratorWrite_io_ctl_lineCount = addressGeneratorWrite_io_ctl_lineCount_csr_io_value; // @[WorkerCSRWrapper.scala 81:42]
  assign addressGeneratorWrite_io_ctl_lineGap = addressGeneratorWrite_io_ctl_lineGap_csr_io_value; // @[WorkerCSRWrapper.scala 82:40]
  assign addressGeneratorWrite_io_xfer_done = transferSplitterWrite_io_xferIn_done; // @[WorkerCSRWrapper.scala 94:35]
  assign transferSplitterWrite_io_xferIn_length = addressGeneratorWrite_io_xfer_length; // @[WorkerCSRWrapper.scala 94:35]
  assign transferSplitterWrite_io_xferIn_valid = addressGeneratorWrite_io_xfer_valid; // @[WorkerCSRWrapper.scala 94:35]
  assign transferSplitterWrite_io_xferIn_first = addressGeneratorWrite_io_xfer_first; // @[WorkerCSRWrapper.scala 94:35]
  assign transferSplitterWrite_io_xferOut_done = io_xferWrite_done; // @[WorkerCSRWrapper.scala 95:16]
  assign control_csr_clock = clock;
  assign control_csr_reset = reset;
  assign control_csr_io_csr_dataOut = io_csr_0_dataOut; // @[ClearCSR.scala 46:16]
  assign control_csr_io_csr_dataWrite = io_csr_0_dataWrite; // @[ClearCSR.scala 46:16]
  assign control_csr_io_clear = {{30'd0}, clear}; // @[ClearCSR.scala 44:18]
  assign csr_clock = clock;
  assign csr_io_value = {{30'd0}, status}; // @[StatusCSR.scala 38:18]
  assign io_irq_irqc_clock = clock;
  assign io_irq_irqc_reset = reset;
  assign io_irq_irqc_io_readBusy = addressGeneratorRead_io_ctl_busy; // @[InterruptController.scala 57:22]
  assign io_irq_irqc_io_writeBusy = addressGeneratorWrite_io_ctl_busy; // @[InterruptController.scala 58:23]
  assign io_irq_irqc_io_imr_dataOut = io_csr_2_dataOut; // @[InterruptController.scala 60:17]
  assign io_irq_irqc_io_imr_dataWrite = io_csr_2_dataWrite; // @[InterruptController.scala 60:17]
  assign io_irq_irqc_io_isr_dataOut = io_csr_3_dataOut; // @[InterruptController.scala 61:17]
  assign io_irq_irqc_io_isr_dataWrite = io_csr_3_dataWrite; // @[InterruptController.scala 61:17]
  assign addressGeneratorRead_io_ctl_startAddress_csr_clock = clock;
  assign addressGeneratorRead_io_ctl_startAddress_csr_reset = reset;
  assign addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataOut = io_csr_4_dataOut; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorRead_io_ctl_startAddress_csr_io_csr_dataWrite = io_csr_4_dataWrite; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorRead_io_ctl_lineLength_csr_clock = clock;
  assign addressGeneratorRead_io_ctl_lineLength_csr_reset = reset;
  assign addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataOut = io_csr_5_dataOut; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorRead_io_ctl_lineLength_csr_io_csr_dataWrite = io_csr_5_dataWrite; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorRead_io_ctl_lineCount_csr_clock = clock;
  assign addressGeneratorRead_io_ctl_lineCount_csr_reset = reset;
  assign addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataOut = io_csr_6_dataOut; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorRead_io_ctl_lineCount_csr_io_csr_dataWrite = io_csr_6_dataWrite; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorRead_io_ctl_lineGap_csr_clock = clock;
  assign addressGeneratorRead_io_ctl_lineGap_csr_reset = reset;
  assign addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataOut = io_csr_7_dataOut; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorRead_io_ctl_lineGap_csr_io_csr_dataWrite = io_csr_7_dataWrite; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorWrite_io_ctl_startAddress_csr_clock = clock;
  assign addressGeneratorWrite_io_ctl_startAddress_csr_reset = reset;
  assign addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataOut = io_csr_8_dataOut; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorWrite_io_ctl_startAddress_csr_io_csr_dataWrite = io_csr_8_dataWrite; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorWrite_io_ctl_lineLength_csr_clock = clock;
  assign addressGeneratorWrite_io_ctl_lineLength_csr_reset = reset;
  assign addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataOut = io_csr_9_dataOut; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorWrite_io_ctl_lineLength_csr_io_csr_dataWrite = io_csr_9_dataWrite; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorWrite_io_ctl_lineCount_csr_clock = clock;
  assign addressGeneratorWrite_io_ctl_lineCount_csr_reset = reset;
  assign addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataOut = io_csr_10_dataOut; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorWrite_io_ctl_lineCount_csr_io_csr_dataWrite = io_csr_10_dataWrite; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorWrite_io_ctl_lineGap_csr_clock = clock;
  assign addressGeneratorWrite_io_ctl_lineGap_csr_reset = reset;
  assign addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataOut = io_csr_11_dataOut; // @[SimpleCSR.scala 42:16]
  assign addressGeneratorWrite_io_ctl_lineGap_csr_io_csr_dataWrite = io_csr_11_dataWrite; // @[SimpleCSR.scala 42:16]
  assign csr_1_clock = clock;
  assign csr_1_io_value = 32'h0; // @[StatusCSR.scala 38:18]
  assign csr_2_clock = clock;
  assign csr_2_io_value = 32'h12; // @[StatusCSR.scala 38:18]
  assign csr_3_clock = clock;
  assign csr_3_reset = reset;
  assign csr_3_io_csr_dataOut = io_csr_14_dataOut; // @[SimpleCSR.scala 42:16]
  assign csr_3_io_csr_dataWrite = io_csr_14_dataWrite; // @[SimpleCSR.scala 42:16]
  assign csr_4_clock = clock;
  assign csr_4_reset = reset;
  assign csr_4_io_csr_dataOut = io_csr_15_dataOut; // @[SimpleCSR.scala 42:16]
  assign csr_4_io_csr_dataWrite = io_csr_15_dataWrite; // @[SimpleCSR.scala 42:16]
  always @(posedge clock) begin
    status <= {addressGeneratorRead_io_ctl_busy,addressGeneratorWrite_io_ctl_busy}; // @[Cat.scala 33:92]
    readerSync <= io_sync_readerSync; // @[WorkerCSRWrapper.scala 42:27]
    readerSyncOld <= readerSync; // @[WorkerCSRWrapper.scala 43:30]
    writerSync <= io_sync_writerSync; // @[WorkerCSRWrapper.scala 45:27]
    writerSyncOld <= writerSync; // @[WorkerCSRWrapper.scala 46:30]
    if (reset) begin // @[WorkerCSRWrapper.scala 48:28]
      readerStart <= 1'h0; // @[WorkerCSRWrapper.scala 48:28]
    end else begin
      readerStart <= (~readerSyncOld & readerSync | control[3]) & control[1]; // @[WorkerCSRWrapper.scala 69:15]
    end
    if (reset) begin // @[WorkerCSRWrapper.scala 49:28]
      writerStart <= 1'h0; // @[WorkerCSRWrapper.scala 49:28]
    end else begin
      writerStart <= (~writerSyncOld & writerSync | control[2]) & control[0]; // @[WorkerCSRWrapper.scala 70:15]
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
  status = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  readerSync = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  readerSyncOld = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  writerSync = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  writerSyncOld = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  readerStart = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  writerStart = _RAND_6[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Queue(
  input         clock,
  input         reset,
  output        io_enq_ready,
  input         io_enq_valid,
  input  [31:0] io_enq_bits,
  input         io_deq_ready,
  output        io_deq_valid,
  output [31:0] io_deq_bits
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] ram [0:511]; // @[Decoupled.scala 275:95]
  wire  ram_io_deq_bits_MPORT_en; // @[Decoupled.scala 275:95]
  wire [8:0] ram_io_deq_bits_MPORT_addr; // @[Decoupled.scala 275:95]
  wire [31:0] ram_io_deq_bits_MPORT_data; // @[Decoupled.scala 275:95]
  wire [31:0] ram_MPORT_data; // @[Decoupled.scala 275:95]
  wire [8:0] ram_MPORT_addr; // @[Decoupled.scala 275:95]
  wire  ram_MPORT_mask; // @[Decoupled.scala 275:95]
  wire  ram_MPORT_en; // @[Decoupled.scala 275:95]
  reg [8:0] enq_ptr_value; // @[Counter.scala 61:40]
  reg [8:0] deq_ptr_value; // @[Counter.scala 61:40]
  reg  maybe_full; // @[Decoupled.scala 278:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[Decoupled.scala 279:33]
  wire  empty = ptr_match & ~maybe_full; // @[Decoupled.scala 280:25]
  wire  full = ptr_match & maybe_full; // @[Decoupled.scala 281:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[Decoupled.scala 52:35]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[Decoupled.scala 52:35]
  wire [8:0] _value_T_1 = enq_ptr_value + 9'h1; // @[Counter.scala 77:24]
  wire [8:0] _value_T_3 = deq_ptr_value + 9'h1; // @[Counter.scala 77:24]
  assign ram_io_deq_bits_MPORT_en = 1'h1;
  assign ram_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_io_deq_bits_MPORT_data = ram[ram_io_deq_bits_MPORT_addr]; // @[Decoupled.scala 275:95]
  assign ram_MPORT_data = io_enq_bits;
  assign ram_MPORT_addr = enq_ptr_value;
  assign ram_MPORT_mask = 1'h1;
  assign ram_MPORT_en = io_enq_ready & io_enq_valid;
  assign io_enq_ready = ~full; // @[Decoupled.scala 305:19]
  assign io_deq_valid = ~empty; // @[Decoupled.scala 304:19]
  assign io_deq_bits = ram_io_deq_bits_MPORT_data; // @[Decoupled.scala 312:17]
  always @(posedge clock) begin
    if (ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[Decoupled.scala 275:95]
    end
    if (reset) begin // @[Counter.scala 61:40]
      enq_ptr_value <= 9'h0; // @[Counter.scala 61:40]
    end else if (do_enq) begin // @[Decoupled.scala 288:16]
      enq_ptr_value <= _value_T_1; // @[Counter.scala 77:15]
    end
    if (reset) begin // @[Counter.scala 61:40]
      deq_ptr_value <= 9'h0; // @[Counter.scala 61:40]
    end else if (do_deq) begin // @[Decoupled.scala 292:16]
      deq_ptr_value <= _value_T_3; // @[Counter.scala 77:15]
    end
    if (reset) begin // @[Decoupled.scala 278:27]
      maybe_full <= 1'h0; // @[Decoupled.scala 278:27]
    end else if (do_enq != do_deq) begin // @[Decoupled.scala 295:27]
      maybe_full <= do_enq; // @[Decoupled.scala 296:16]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    ram[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  enq_ptr_value = _RAND_1[8:0];
  _RAND_2 = {1{`RANDOM}};
  deq_ptr_value = _RAND_2[8:0];
  _RAND_3 = {1{`RANDOM}};
  maybe_full = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module DMATopAXI_AXIL_AXIS(
  input         clock,
  input         reset,
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
  output [3:0]  io_read_aw_awid,
  output [31:0] io_read_aw_awaddr,
  output [7:0]  io_read_aw_awlen,
  output [2:0]  io_read_aw_awsize,
  output [1:0]  io_read_aw_awburst,
  output        io_read_aw_awlock,
  output [3:0]  io_read_aw_awcache,
  output [2:0]  io_read_aw_awprot,
  output [3:0]  io_read_aw_awqos,
  output        io_read_aw_awvalid,
  input         io_read_aw_awready,
  output [31:0] io_read_w_wdata,
  output [3:0]  io_read_w_wstrb,
  output        io_read_w_wlast,
  output        io_read_w_wvalid,
  input         io_read_w_wready,
  input  [3:0]  io_read_b_bid,
  input  [1:0]  io_read_b_bresp,
  input         io_read_b_bvalid,
  output        io_read_b_bready,
  output [3:0]  io_read_ar_arid,
  output [31:0] io_read_ar_araddr,
  output [7:0]  io_read_ar_arlen,
  output [2:0]  io_read_ar_arsize,
  output [1:0]  io_read_ar_arburst,
  output        io_read_ar_arlock,
  output [3:0]  io_read_ar_arcache,
  output [2:0]  io_read_ar_arprot,
  output [3:0]  io_read_ar_arqos,
  output        io_read_ar_arvalid,
  input         io_read_ar_arready,
  input  [3:0]  io_read_r_rid,
  input  [31:0] io_read_r_rdata,
  input  [1:0]  io_read_r_rresp,
  input         io_read_r_rlast,
  input         io_read_r_rvalid,
  output        io_read_r_rready,
  output [31:0] io_write_tdata,
  output        io_write_tvalid,
  input         io_write_tready,
  output        io_write_tuser,
  output        io_write_tlast,
  output        io_irq_readerDone,
  output        io_irq_writerDone,
  input         io_sync_readerSync,
  input         io_sync_writerSync
);
  wire  csrFrontend_clock; // @[DMATop.scala 38:27]
  wire  csrFrontend_reset; // @[DMATop.scala 38:27]
  wire [31:0] csrFrontend_io_ctl_aw_awaddr; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_aw_awvalid; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_aw_awready; // @[DMATop.scala 38:27]
  wire [31:0] csrFrontend_io_ctl_w_wdata; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_w_wvalid; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_w_wready; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_b_bvalid; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_b_bready; // @[DMATop.scala 38:27]
  wire [31:0] csrFrontend_io_ctl_ar_araddr; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_ar_arvalid; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_ar_arready; // @[DMATop.scala 38:27]
  wire [31:0] csrFrontend_io_ctl_r_rdata; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_r_rvalid; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_ctl_r_rready; // @[DMATop.scala 38:27]
  wire [3:0] csrFrontend_io_bus_addr; // @[DMATop.scala 38:27]
  wire [31:0] csrFrontend_io_bus_dataOut; // @[DMATop.scala 38:27]
  wire [31:0] csrFrontend_io_bus_dataIn; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_bus_write; // @[DMATop.scala 38:27]
  wire  csrFrontend_io_bus_read; // @[DMATop.scala 38:27]
  wire  readerFrontend_clock; // @[DMATop.scala 40:30]
  wire  readerFrontend_reset; // @[DMATop.scala 40:30]
  wire [31:0] readerFrontend_io_bus_ar_araddr; // @[DMATop.scala 40:30]
  wire [7:0] readerFrontend_io_bus_ar_arlen; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_bus_ar_arvalid; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_bus_ar_arready; // @[DMATop.scala 40:30]
  wire [31:0] readerFrontend_io_bus_r_rdata; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_bus_r_rlast; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_bus_r_rvalid; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_bus_r_rready; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_dataIO_ready; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_dataIO_valid; // @[DMATop.scala 40:30]
  wire [31:0] readerFrontend_io_dataIO_bits; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_xfer_done; // @[DMATop.scala 40:30]
  wire [31:0] readerFrontend_io_xfer_address; // @[DMATop.scala 40:30]
  wire [31:0] readerFrontend_io_xfer_length; // @[DMATop.scala 40:30]
  wire  readerFrontend_io_xfer_valid; // @[DMATop.scala 40:30]
  wire  writerFrontend_clock; // @[DMATop.scala 42:30]
  wire  writerFrontend_reset; // @[DMATop.scala 42:30]
  wire [31:0] writerFrontend_io_bus_tdata; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_bus_tvalid; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_bus_tready; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_bus_tuser; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_bus_tlast; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_dataIO_ready; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_dataIO_valid; // @[DMATop.scala 42:30]
  wire [31:0] writerFrontend_io_dataIO_bits; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_xfer_done; // @[DMATop.scala 42:30]
  wire [31:0] writerFrontend_io_xfer_length; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_xfer_valid; // @[DMATop.scala 42:30]
  wire  writerFrontend_io_xfer_first; // @[DMATop.scala 42:30]
  wire [31:0] csr_io_csr_0_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_0_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_0_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_1_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_2_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_2_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_2_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_3_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_3_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_3_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_4_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_4_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_4_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_5_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_5_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_5_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_6_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_6_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_6_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_7_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_7_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_7_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_8_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_8_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_8_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_9_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_9_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_9_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_10_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_10_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_10_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_11_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_11_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_11_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_12_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_13_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_14_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_14_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_14_dataIn; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_15_dataOut; // @[DMATop.scala 44:19]
  wire  csr_io_csr_15_dataWrite; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_csr_15_dataIn; // @[DMATop.scala 44:19]
  wire [3:0] csr_io_bus_addr; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_bus_dataOut; // @[DMATop.scala 44:19]
  wire [31:0] csr_io_bus_dataIn; // @[DMATop.scala 44:19]
  wire  csr_io_bus_write; // @[DMATop.scala 44:19]
  wire  csr_io_bus_read; // @[DMATop.scala 44:19]
  wire  ctl_clock; // @[DMATop.scala 46:19]
  wire  ctl_reset; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_0_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_0_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_0_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_1_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_2_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_2_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_2_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_3_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_3_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_3_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_4_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_4_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_4_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_5_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_5_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_5_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_6_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_6_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_6_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_7_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_7_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_7_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_8_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_8_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_8_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_9_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_9_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_9_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_10_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_10_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_10_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_11_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_11_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_11_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_12_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_13_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_14_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_14_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_14_dataIn; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_15_dataOut; // @[DMATop.scala 46:19]
  wire  ctl_io_csr_15_dataWrite; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_csr_15_dataIn; // @[DMATop.scala 46:19]
  wire  ctl_io_irq_readerDone; // @[DMATop.scala 46:19]
  wire  ctl_io_irq_writerDone; // @[DMATop.scala 46:19]
  wire  ctl_io_sync_readerSync; // @[DMATop.scala 46:19]
  wire  ctl_io_sync_writerSync; // @[DMATop.scala 46:19]
  wire  ctl_io_xferRead_done; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_xferRead_address; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_xferRead_length; // @[DMATop.scala 46:19]
  wire  ctl_io_xferRead_valid; // @[DMATop.scala 46:19]
  wire  ctl_io_xferWrite_done; // @[DMATop.scala 46:19]
  wire [31:0] ctl_io_xferWrite_length; // @[DMATop.scala 46:19]
  wire  ctl_io_xferWrite_valid; // @[DMATop.scala 46:19]
  wire  ctl_io_xferWrite_first; // @[DMATop.scala 46:19]
  wire  queue_clock; // @[Decoupled.scala 377:21]
  wire  queue_reset; // @[Decoupled.scala 377:21]
  wire  queue_io_enq_ready; // @[Decoupled.scala 377:21]
  wire  queue_io_enq_valid; // @[Decoupled.scala 377:21]
  wire [31:0] queue_io_enq_bits; // @[Decoupled.scala 377:21]
  wire  queue_io_deq_ready; // @[Decoupled.scala 377:21]
  wire  queue_io_deq_valid; // @[Decoupled.scala 377:21]
  wire [31:0] queue_io_deq_bits; // @[Decoupled.scala 377:21]
  AXI4LiteCSRAXI_AXIL_AXIS csrFrontend ( // @[DMATop.scala 38:27]
    .clock(csrFrontend_clock),
    .reset(csrFrontend_reset),
    .io_ctl_aw_awaddr(csrFrontend_io_ctl_aw_awaddr),
    .io_ctl_aw_awvalid(csrFrontend_io_ctl_aw_awvalid),
    .io_ctl_aw_awready(csrFrontend_io_ctl_aw_awready),
    .io_ctl_w_wdata(csrFrontend_io_ctl_w_wdata),
    .io_ctl_w_wvalid(csrFrontend_io_ctl_w_wvalid),
    .io_ctl_w_wready(csrFrontend_io_ctl_w_wready),
    .io_ctl_b_bvalid(csrFrontend_io_ctl_b_bvalid),
    .io_ctl_b_bready(csrFrontend_io_ctl_b_bready),
    .io_ctl_ar_araddr(csrFrontend_io_ctl_ar_araddr),
    .io_ctl_ar_arvalid(csrFrontend_io_ctl_ar_arvalid),
    .io_ctl_ar_arready(csrFrontend_io_ctl_ar_arready),
    .io_ctl_r_rdata(csrFrontend_io_ctl_r_rdata),
    .io_ctl_r_rvalid(csrFrontend_io_ctl_r_rvalid),
    .io_ctl_r_rready(csrFrontend_io_ctl_r_rready),
    .io_bus_addr(csrFrontend_io_bus_addr),
    .io_bus_dataOut(csrFrontend_io_bus_dataOut),
    .io_bus_dataIn(csrFrontend_io_bus_dataIn),
    .io_bus_write(csrFrontend_io_bus_write),
    .io_bus_read(csrFrontend_io_bus_read)
  );
  AXI4ReaderAXI_AXIL_AXIS readerFrontend ( // @[DMATop.scala 40:30]
    .clock(readerFrontend_clock),
    .reset(readerFrontend_reset),
    .io_bus_ar_araddr(readerFrontend_io_bus_ar_araddr),
    .io_bus_ar_arlen(readerFrontend_io_bus_ar_arlen),
    .io_bus_ar_arvalid(readerFrontend_io_bus_ar_arvalid),
    .io_bus_ar_arready(readerFrontend_io_bus_ar_arready),
    .io_bus_r_rdata(readerFrontend_io_bus_r_rdata),
    .io_bus_r_rlast(readerFrontend_io_bus_r_rlast),
    .io_bus_r_rvalid(readerFrontend_io_bus_r_rvalid),
    .io_bus_r_rready(readerFrontend_io_bus_r_rready),
    .io_dataIO_ready(readerFrontend_io_dataIO_ready),
    .io_dataIO_valid(readerFrontend_io_dataIO_valid),
    .io_dataIO_bits(readerFrontend_io_dataIO_bits),
    .io_xfer_done(readerFrontend_io_xfer_done),
    .io_xfer_address(readerFrontend_io_xfer_address),
    .io_xfer_length(readerFrontend_io_xfer_length),
    .io_xfer_valid(readerFrontend_io_xfer_valid)
  );
  AXIStreamMasterAXI_AXIL_AXIS writerFrontend ( // @[DMATop.scala 42:30]
    .clock(writerFrontend_clock),
    .reset(writerFrontend_reset),
    .io_bus_tdata(writerFrontend_io_bus_tdata),
    .io_bus_tvalid(writerFrontend_io_bus_tvalid),
    .io_bus_tready(writerFrontend_io_bus_tready),
    .io_bus_tuser(writerFrontend_io_bus_tuser),
    .io_bus_tlast(writerFrontend_io_bus_tlast),
    .io_dataIO_ready(writerFrontend_io_dataIO_ready),
    .io_dataIO_valid(writerFrontend_io_dataIO_valid),
    .io_dataIO_bits(writerFrontend_io_dataIO_bits),
    .io_xfer_done(writerFrontend_io_xfer_done),
    .io_xfer_length(writerFrontend_io_xfer_length),
    .io_xfer_valid(writerFrontend_io_xfer_valid),
    .io_xfer_first(writerFrontend_io_xfer_first)
  );
  CSRAXI_AXIL_AXIS csr ( // @[DMATop.scala 44:19]
    .io_csr_0_dataOut(csr_io_csr_0_dataOut),
    .io_csr_0_dataWrite(csr_io_csr_0_dataWrite),
    .io_csr_0_dataIn(csr_io_csr_0_dataIn),
    .io_csr_1_dataIn(csr_io_csr_1_dataIn),
    .io_csr_2_dataOut(csr_io_csr_2_dataOut),
    .io_csr_2_dataWrite(csr_io_csr_2_dataWrite),
    .io_csr_2_dataIn(csr_io_csr_2_dataIn),
    .io_csr_3_dataOut(csr_io_csr_3_dataOut),
    .io_csr_3_dataWrite(csr_io_csr_3_dataWrite),
    .io_csr_3_dataIn(csr_io_csr_3_dataIn),
    .io_csr_4_dataOut(csr_io_csr_4_dataOut),
    .io_csr_4_dataWrite(csr_io_csr_4_dataWrite),
    .io_csr_4_dataIn(csr_io_csr_4_dataIn),
    .io_csr_5_dataOut(csr_io_csr_5_dataOut),
    .io_csr_5_dataWrite(csr_io_csr_5_dataWrite),
    .io_csr_5_dataIn(csr_io_csr_5_dataIn),
    .io_csr_6_dataOut(csr_io_csr_6_dataOut),
    .io_csr_6_dataWrite(csr_io_csr_6_dataWrite),
    .io_csr_6_dataIn(csr_io_csr_6_dataIn),
    .io_csr_7_dataOut(csr_io_csr_7_dataOut),
    .io_csr_7_dataWrite(csr_io_csr_7_dataWrite),
    .io_csr_7_dataIn(csr_io_csr_7_dataIn),
    .io_csr_8_dataOut(csr_io_csr_8_dataOut),
    .io_csr_8_dataWrite(csr_io_csr_8_dataWrite),
    .io_csr_8_dataIn(csr_io_csr_8_dataIn),
    .io_csr_9_dataOut(csr_io_csr_9_dataOut),
    .io_csr_9_dataWrite(csr_io_csr_9_dataWrite),
    .io_csr_9_dataIn(csr_io_csr_9_dataIn),
    .io_csr_10_dataOut(csr_io_csr_10_dataOut),
    .io_csr_10_dataWrite(csr_io_csr_10_dataWrite),
    .io_csr_10_dataIn(csr_io_csr_10_dataIn),
    .io_csr_11_dataOut(csr_io_csr_11_dataOut),
    .io_csr_11_dataWrite(csr_io_csr_11_dataWrite),
    .io_csr_11_dataIn(csr_io_csr_11_dataIn),
    .io_csr_12_dataIn(csr_io_csr_12_dataIn),
    .io_csr_13_dataIn(csr_io_csr_13_dataIn),
    .io_csr_14_dataOut(csr_io_csr_14_dataOut),
    .io_csr_14_dataWrite(csr_io_csr_14_dataWrite),
    .io_csr_14_dataIn(csr_io_csr_14_dataIn),
    .io_csr_15_dataOut(csr_io_csr_15_dataOut),
    .io_csr_15_dataWrite(csr_io_csr_15_dataWrite),
    .io_csr_15_dataIn(csr_io_csr_15_dataIn),
    .io_bus_addr(csr_io_bus_addr),
    .io_bus_dataOut(csr_io_bus_dataOut),
    .io_bus_dataIn(csr_io_bus_dataIn),
    .io_bus_write(csr_io_bus_write),
    .io_bus_read(csr_io_bus_read)
  );
  WorkerCSRWrapperAXI_AXIL_AXIS ctl ( // @[DMATop.scala 46:19]
    .clock(ctl_clock),
    .reset(ctl_reset),
    .io_csr_0_dataOut(ctl_io_csr_0_dataOut),
    .io_csr_0_dataWrite(ctl_io_csr_0_dataWrite),
    .io_csr_0_dataIn(ctl_io_csr_0_dataIn),
    .io_csr_1_dataIn(ctl_io_csr_1_dataIn),
    .io_csr_2_dataOut(ctl_io_csr_2_dataOut),
    .io_csr_2_dataWrite(ctl_io_csr_2_dataWrite),
    .io_csr_2_dataIn(ctl_io_csr_2_dataIn),
    .io_csr_3_dataOut(ctl_io_csr_3_dataOut),
    .io_csr_3_dataWrite(ctl_io_csr_3_dataWrite),
    .io_csr_3_dataIn(ctl_io_csr_3_dataIn),
    .io_csr_4_dataOut(ctl_io_csr_4_dataOut),
    .io_csr_4_dataWrite(ctl_io_csr_4_dataWrite),
    .io_csr_4_dataIn(ctl_io_csr_4_dataIn),
    .io_csr_5_dataOut(ctl_io_csr_5_dataOut),
    .io_csr_5_dataWrite(ctl_io_csr_5_dataWrite),
    .io_csr_5_dataIn(ctl_io_csr_5_dataIn),
    .io_csr_6_dataOut(ctl_io_csr_6_dataOut),
    .io_csr_6_dataWrite(ctl_io_csr_6_dataWrite),
    .io_csr_6_dataIn(ctl_io_csr_6_dataIn),
    .io_csr_7_dataOut(ctl_io_csr_7_dataOut),
    .io_csr_7_dataWrite(ctl_io_csr_7_dataWrite),
    .io_csr_7_dataIn(ctl_io_csr_7_dataIn),
    .io_csr_8_dataOut(ctl_io_csr_8_dataOut),
    .io_csr_8_dataWrite(ctl_io_csr_8_dataWrite),
    .io_csr_8_dataIn(ctl_io_csr_8_dataIn),
    .io_csr_9_dataOut(ctl_io_csr_9_dataOut),
    .io_csr_9_dataWrite(ctl_io_csr_9_dataWrite),
    .io_csr_9_dataIn(ctl_io_csr_9_dataIn),
    .io_csr_10_dataOut(ctl_io_csr_10_dataOut),
    .io_csr_10_dataWrite(ctl_io_csr_10_dataWrite),
    .io_csr_10_dataIn(ctl_io_csr_10_dataIn),
    .io_csr_11_dataOut(ctl_io_csr_11_dataOut),
    .io_csr_11_dataWrite(ctl_io_csr_11_dataWrite),
    .io_csr_11_dataIn(ctl_io_csr_11_dataIn),
    .io_csr_12_dataIn(ctl_io_csr_12_dataIn),
    .io_csr_13_dataIn(ctl_io_csr_13_dataIn),
    .io_csr_14_dataOut(ctl_io_csr_14_dataOut),
    .io_csr_14_dataWrite(ctl_io_csr_14_dataWrite),
    .io_csr_14_dataIn(ctl_io_csr_14_dataIn),
    .io_csr_15_dataOut(ctl_io_csr_15_dataOut),
    .io_csr_15_dataWrite(ctl_io_csr_15_dataWrite),
    .io_csr_15_dataIn(ctl_io_csr_15_dataIn),
    .io_irq_readerDone(ctl_io_irq_readerDone),
    .io_irq_writerDone(ctl_io_irq_writerDone),
    .io_sync_readerSync(ctl_io_sync_readerSync),
    .io_sync_writerSync(ctl_io_sync_writerSync),
    .io_xferRead_done(ctl_io_xferRead_done),
    .io_xferRead_address(ctl_io_xferRead_address),
    .io_xferRead_length(ctl_io_xferRead_length),
    .io_xferRead_valid(ctl_io_xferRead_valid),
    .io_xferWrite_done(ctl_io_xferWrite_done),
    .io_xferWrite_length(ctl_io_xferWrite_length),
    .io_xferWrite_valid(ctl_io_xferWrite_valid),
    .io_xferWrite_first(ctl_io_xferWrite_first)
  );
  Queue queue ( // @[Decoupled.scala 377:21]
    .clock(queue_clock),
    .reset(queue_reset),
    .io_enq_ready(queue_io_enq_ready),
    .io_enq_valid(queue_io_enq_valid),
    .io_enq_bits(queue_io_enq_bits),
    .io_deq_ready(queue_io_deq_ready),
    .io_deq_valid(queue_io_deq_valid),
    .io_deq_bits(queue_io_deq_bits)
  );
  assign io_control_aw_awready = csrFrontend_io_ctl_aw_awready; // @[DMATop.scala 52:22]
  assign io_control_w_wready = csrFrontend_io_ctl_w_wready; // @[DMATop.scala 52:22]
  assign io_control_b_bresp = 2'h0; // @[DMATop.scala 52:22]
  assign io_control_b_bvalid = csrFrontend_io_ctl_b_bvalid; // @[DMATop.scala 52:22]
  assign io_control_ar_arready = csrFrontend_io_ctl_ar_arready; // @[DMATop.scala 52:22]
  assign io_control_r_rdata = csrFrontend_io_ctl_r_rdata; // @[DMATop.scala 52:22]
  assign io_control_r_rresp = 2'h0; // @[DMATop.scala 52:22]
  assign io_control_r_rvalid = csrFrontend_io_ctl_r_rvalid; // @[DMATop.scala 52:22]
  assign io_read_aw_awid = 4'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awaddr = 32'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awlen = 8'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awsize = 3'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awburst = 2'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awlock = 1'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awcache = 4'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awprot = 3'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awqos = 4'h0; // @[DMATop.scala 58:11]
  assign io_read_aw_awvalid = 1'h0; // @[DMATop.scala 58:11]
  assign io_read_w_wdata = 32'h0; // @[DMATop.scala 58:11]
  assign io_read_w_wstrb = 4'h0; // @[DMATop.scala 58:11]
  assign io_read_w_wlast = 1'h0; // @[DMATop.scala 58:11]
  assign io_read_w_wvalid = 1'h0; // @[DMATop.scala 58:11]
  assign io_read_b_bready = 1'h0; // @[DMATop.scala 58:11]
  assign io_read_ar_arid = 4'h0; // @[DMATop.scala 58:11]
  assign io_read_ar_araddr = readerFrontend_io_bus_ar_araddr; // @[DMATop.scala 58:11]
  assign io_read_ar_arlen = readerFrontend_io_bus_ar_arlen; // @[DMATop.scala 58:11]
  assign io_read_ar_arsize = 3'h2; // @[DMATop.scala 58:11]
  assign io_read_ar_arburst = 2'h1; // @[DMATop.scala 58:11]
  assign io_read_ar_arlock = 1'h0; // @[DMATop.scala 58:11]
  assign io_read_ar_arcache = 4'h2; // @[DMATop.scala 58:11]
  assign io_read_ar_arprot = 3'h0; // @[DMATop.scala 58:11]
  assign io_read_ar_arqos = 4'h0; // @[DMATop.scala 58:11]
  assign io_read_ar_arvalid = readerFrontend_io_bus_ar_arvalid; // @[DMATop.scala 58:11]
  assign io_read_r_rready = readerFrontend_io_bus_r_rready; // @[DMATop.scala 58:11]
  assign io_write_tdata = writerFrontend_io_bus_tdata; // @[DMATop.scala 59:12]
  assign io_write_tvalid = writerFrontend_io_bus_tvalid; // @[DMATop.scala 59:12]
  assign io_write_tuser = writerFrontend_io_bus_tuser; // @[DMATop.scala 59:12]
  assign io_write_tlast = writerFrontend_io_bus_tlast; // @[DMATop.scala 59:12]
  assign io_irq_readerDone = ctl_io_irq_readerDone; // @[DMATop.scala 61:10]
  assign io_irq_writerDone = ctl_io_irq_writerDone; // @[DMATop.scala 61:10]
  assign csrFrontend_clock = clock;
  assign csrFrontend_reset = reset;
  assign csrFrontend_io_ctl_aw_awaddr = io_control_aw_awaddr; // @[DMATop.scala 52:22]
  assign csrFrontend_io_ctl_aw_awvalid = io_control_aw_awvalid; // @[DMATop.scala 52:22]
  assign csrFrontend_io_ctl_w_wdata = io_control_w_wdata; // @[DMATop.scala 52:22]
  assign csrFrontend_io_ctl_w_wvalid = io_control_w_wvalid; // @[DMATop.scala 52:22]
  assign csrFrontend_io_ctl_b_bready = io_control_b_bready; // @[DMATop.scala 52:22]
  assign csrFrontend_io_ctl_ar_araddr = io_control_ar_araddr; // @[DMATop.scala 52:22]
  assign csrFrontend_io_ctl_ar_arvalid = io_control_ar_arvalid; // @[DMATop.scala 52:22]
  assign csrFrontend_io_ctl_r_rready = io_control_r_rready; // @[DMATop.scala 52:22]
  assign csrFrontend_io_bus_dataIn = csr_io_bus_dataIn; // @[DMATop.scala 53:14]
  assign readerFrontend_clock = clock;
  assign readerFrontend_reset = reset;
  assign readerFrontend_io_bus_ar_arready = io_read_ar_arready; // @[DMATop.scala 58:11]
  assign readerFrontend_io_bus_r_rdata = io_read_r_rdata; // @[DMATop.scala 58:11]
  assign readerFrontend_io_bus_r_rlast = io_read_r_rlast; // @[DMATop.scala 58:11]
  assign readerFrontend_io_bus_r_rvalid = io_read_r_rvalid; // @[DMATop.scala 58:11]
  assign readerFrontend_io_dataIO_ready = queue_io_enq_ready; // @[Decoupled.scala 381:17]
  assign readerFrontend_io_xfer_address = ctl_io_xferRead_address; // @[DMATop.scala 55:26]
  assign readerFrontend_io_xfer_length = ctl_io_xferRead_length; // @[DMATop.scala 55:26]
  assign readerFrontend_io_xfer_valid = ctl_io_xferRead_valid; // @[DMATop.scala 55:26]
  assign writerFrontend_clock = clock;
  assign writerFrontend_reset = reset;
  assign writerFrontend_io_bus_tready = io_write_tready; // @[DMATop.scala 59:12]
  assign writerFrontend_io_dataIO_valid = queue_io_deq_valid; // @[DMATop.scala 50:9]
  assign writerFrontend_io_dataIO_bits = queue_io_deq_bits; // @[DMATop.scala 50:9]
  assign writerFrontend_io_xfer_length = ctl_io_xferWrite_length; // @[DMATop.scala 56:26]
  assign writerFrontend_io_xfer_valid = ctl_io_xferWrite_valid; // @[DMATop.scala 56:26]
  assign writerFrontend_io_xfer_first = ctl_io_xferWrite_first; // @[DMATop.scala 56:26]
  assign csr_io_csr_0_dataIn = ctl_io_csr_0_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_1_dataIn = ctl_io_csr_1_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_2_dataIn = ctl_io_csr_2_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_3_dataIn = ctl_io_csr_3_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_4_dataIn = ctl_io_csr_4_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_5_dataIn = ctl_io_csr_5_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_6_dataIn = ctl_io_csr_6_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_7_dataIn = ctl_io_csr_7_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_8_dataIn = ctl_io_csr_8_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_9_dataIn = ctl_io_csr_9_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_10_dataIn = ctl_io_csr_10_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_11_dataIn = ctl_io_csr_11_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_12_dataIn = ctl_io_csr_12_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_13_dataIn = ctl_io_csr_13_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_14_dataIn = ctl_io_csr_14_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_csr_15_dataIn = ctl_io_csr_15_dataIn; // @[DMATop.scala 54:14]
  assign csr_io_bus_addr = csrFrontend_io_bus_addr; // @[DMATop.scala 53:14]
  assign csr_io_bus_dataOut = csrFrontend_io_bus_dataOut; // @[DMATop.scala 53:14]
  assign csr_io_bus_write = csrFrontend_io_bus_write; // @[DMATop.scala 53:14]
  assign csr_io_bus_read = csrFrontend_io_bus_read; // @[DMATop.scala 53:14]
  assign ctl_clock = clock;
  assign ctl_reset = reset;
  assign ctl_io_csr_0_dataOut = csr_io_csr_0_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_0_dataWrite = csr_io_csr_0_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_2_dataOut = csr_io_csr_2_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_2_dataWrite = csr_io_csr_2_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_3_dataOut = csr_io_csr_3_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_3_dataWrite = csr_io_csr_3_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_4_dataOut = csr_io_csr_4_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_4_dataWrite = csr_io_csr_4_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_5_dataOut = csr_io_csr_5_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_5_dataWrite = csr_io_csr_5_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_6_dataOut = csr_io_csr_6_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_6_dataWrite = csr_io_csr_6_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_7_dataOut = csr_io_csr_7_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_7_dataWrite = csr_io_csr_7_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_8_dataOut = csr_io_csr_8_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_8_dataWrite = csr_io_csr_8_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_9_dataOut = csr_io_csr_9_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_9_dataWrite = csr_io_csr_9_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_10_dataOut = csr_io_csr_10_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_10_dataWrite = csr_io_csr_10_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_11_dataOut = csr_io_csr_11_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_11_dataWrite = csr_io_csr_11_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_14_dataOut = csr_io_csr_14_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_14_dataWrite = csr_io_csr_14_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_csr_15_dataOut = csr_io_csr_15_dataOut; // @[DMATop.scala 54:14]
  assign ctl_io_csr_15_dataWrite = csr_io_csr_15_dataWrite; // @[DMATop.scala 54:14]
  assign ctl_io_sync_readerSync = io_sync_readerSync; // @[DMATop.scala 62:11]
  assign ctl_io_sync_writerSync = io_sync_writerSync; // @[DMATop.scala 62:11]
  assign ctl_io_xferRead_done = readerFrontend_io_xfer_done; // @[DMATop.scala 55:26]
  assign ctl_io_xferWrite_done = writerFrontend_io_xfer_done; // @[DMATop.scala 56:26]
  assign queue_clock = clock;
  assign queue_reset = reset;
  assign queue_io_enq_valid = readerFrontend_io_dataIO_valid; // @[Decoupled.scala 379:22]
  assign queue_io_enq_bits = readerFrontend_io_dataIO_bits; // @[Decoupled.scala 380:21]
  assign queue_io_deq_ready = writerFrontend_io_dataIO_ready; // @[DMATop.scala 50:9]
endmodule
