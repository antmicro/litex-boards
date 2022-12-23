module AcceleratorIntegration(
    input         clk,
    input         rst,
    input  [31:0] in_tdata,
    input         in_tvalid,
    output        in_tready,
    input         in_tuser,
    input         in_tlast,
    output [31:0] out_tdata,
    output        out_tvalid,
    input         out_tready,
    output        out_tuser,
    output        out_tlast,

    input  [2:0]  algorithm,
    output        busy,
    input  [1:0]  pattern,
    input         bgr,
 
    input  [12:0] cols,
    input  [12:0] rows
);

wire [31:0] fpga_isp_raw_payload_data;
wire fpga_isp_raw_valid;
wire fpga_isp_raw_ready;
wire fpga_isp_raw_first;
wire fpga_isp_raw_last;
wire [31:0] fpga_isp_rgb_payload_data;
wire fpga_isp_rgb_valid;
wire fpga_isp_rgb_ready;
wire fpga_isp_rgb_first;
wire fpga_isp_rgb_last;
wire clk_1;
wire rst_1;
wire [2:0] fpga_isp_algorithm;
wire fpga_isp_busy;
wire [1:0] fpga_isp_pattern;
wire fpga_isp_bgr;
wire [12:0] fpga_isp_cols;
wire [12:0] fpga_isp_rows;

assign fpga_isp_raw_payload_data = in_tdata;
assign fpga_isp_raw_valid = in_tvalid;
assign in_tready = fpga_isp_raw_ready;
assign fpga_isp_raw_first = in_tuser;
assign fpga_isp_raw_last = in_tlast;
assign out_tdata = fpga_isp_rgb_payload_data;
assign out_tvalid = fpga_isp_rgb_valid;
assign fpga_isp_rgb_ready = out_tready;
assign out_tuser = fpga_isp_rgb_first;
assign out_tlast = fpga_isp_rgb_last;
assign clk_1 = clk;
assign rst_1 = rst;
assign fpga_isp_algorithm = algorithm;
assign busy = fpga_isp_busy;
assign fpga_isp_pattern = pattern;
assign fpga_isp_bgr = bgr;
assign fpga_isp_cols = cols;
assign fpga_isp_rows = rows;

fpga_isp fpga_isp(
    .sys_clk(clk_1),
    .sys_rst(rst_1),
    .raw_payload_data(fpga_isp_raw_payload_data),
    .raw_valid(fpga_isp_raw_valid),
    .raw_ready(fpga_isp_raw_ready),
    .raw_first(fpga_isp_raw_first),
    .raw_last(fpga_isp_raw_last),
    .rgb_payload_data(fpga_isp_rgb_payload_data),
    .rgb_valid(fpga_isp_rgb_valid),
    .rgb_ready(fpga_isp_rgb_ready),
    .rgb_first(fpga_isp_rgb_first),
    .rgb_last(fpga_isp_rgb_last),
    .algorithm(fpga_isp_algorithm),
    .busy(fpga_isp_busy),
    .pattern(fpga_isp_pattern),
    .bgr(fpga_isp_bgr),
    .cols(fpga_isp_cols),
    .rows(fpga_isp_rows)
);
endmodule
    