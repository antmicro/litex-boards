module ddr5_usp_phy(
		input wire sys_clk,
		inout wire [31:0]A_dq_pads,
		inout wire [7:0]A_dqs_t_pads,
		inout wire [7:0]A_dqs_c_pads,

		inout wire [7:0]A_cb_pads,
		inout wire [1:0]A_dqsb_t_pads,
		inout wire [1:0]A_dqsb_c_pads,

		inout wire [31:0]B_dq_pads,
		inout wire [7:0]B_dqs_t_pads,
		inout wire [7:0]B_dqs_c_pads,

		inout wire [7:0]B_cb_pads,
		inout wire [1:0]B_dqsb_t_pads,
		inout wire [1:0]B_dqsb_c_pads,

		output wire [9:0]A_cc_pads, // CA, PAR and CS_c
		//output wire [9:0]B_cc_pads, // CA, PAR and CS_c
		output wire ck_t_pad,
		output wire ck_c_pad
	);

	// DQ bytes
	genvar i;
	generate
		for (i = 0; i < 4; i = i + 1) begin
			ddr5_usp_phy_nibble phy_nibble_A_dq_low_inst(
				.sys_clk(sys_clk),
				.dq_pads(A_dq_pads[i*8+3:i*8+0]),
				.dqs_t_pad(A_dqs_t_pads[i]),
				.dqs_c_pad(A_dqs_c_pads[i])
			);	
			ddr5_usp_phy_nibble phy_nibble_A_dq_up_inst(
				.sys_clk(sys_clk),
				.dq_pads(A_dq_pads[i*8+7:i*8+4]),
				.dqs_t_pad(A_dqs_t_pads[i+4]),
				.dqs_c_pad(A_dqs_c_pads[i+4])
			);	

			ddr5_usp_phy_nibble phy_nibble_B_dq_low_inst( 
				.sys_clk(sys_clk),
				.dq_pads(B_dq_pads[i*8+3:i*8+0]),
				.dqs_t_pad(B_dqs_t_pads[i]),
				.dqs_c_pad(B_dqs_c_pads[i])
			);	
			ddr5_usp_phy_nibble phy_nibble_B_dq_up_inst(
				.sys_clk(sys_clk),
				.dq_pads(B_dq_pads[i*8+7:i*8+4]),
				.dqs_t_pad(B_dqs_t_pads[i+4]),
				.dqs_c_pad(B_dqs_c_pads[i+4])
			);	
		end
	endgenerate

	// CB byte
	ddr5_usp_phy_nibble phy_nibble_A_cb_low_inst( 
		.sys_clk(sys_clk),
		.dq_pads(A_cb_pads[3:0]),
		.dqs_t_pad(A_dqsb_t_pads[0]),
		.dqs_c_pad(A_dqsb_c_pads[0])
	);	
	ddr5_usp_phy_nibble phy_nibble_A_cb_up_inst(
		.sys_clk(sys_clk),
		.dq_pads(A_cb_pads[7:4]),
		.dqs_t_pad(A_dqsb_t_pads[1]),
		.dqs_c_pad(A_dqsb_c_pads[1])
	);	

	ddr5_usp_phy_nibble phy_nibble_B_cb_low_inst( 
		.sys_clk(sys_clk),
		.dq_pads(B_cb_pads[3:0]),
		.dqs_t_pad(B_dqsb_t_pads[0]),
		.dqs_c_pad(B_dqsb_c_pads[0])
	);	
	ddr5_usp_phy_nibble phy_nibble_B_cb_up_inst(
		.sys_clk(sys_clk),
		.dq_pads(B_cb_pads[7:4]),
		.dqs_t_pad(B_dqsb_t_pads[1]),
		.dqs_c_pad(B_dqsb_c_pads[1])
	);	

	// Command & control
	ddr5_usp_phy_cc phy_A_cc_inst(
		.sys_clk(sys_clk),
		.cc_pads(A_cc_pads),
		.ck_t_pad(ck_t_pad),
		.ck_c_pad(ck_c_pad)
	);

endmodule

// Command & control PHY
module ddr5_usp_phy_cc
	(
		input wire sys_clk,
		output wire [9:0]cc_pads, // CA, PAR and CS_c
		output wire ck_t_pad,
		output wire ck_c_pad
	);

	wire [9:0]o_cc;
	wire [9:0]t_cc;

	wire o_ck;
	wire t_ck;

	// Ordered by CC bit not ctrl number
	wire [39:0] rx_bit_ctrl_out_cc[10];
	wire [39:0] tx_bit_ctrl_out_cc[10];
	wire [39:0] rx_bit_ctrl_in_cc[10];
	wire [39:0] tx_bit_ctrl_in_cc[10];

	wire [39:0] rx_bit_ctrl_out_ck;
	wire [39:0] tx_bit_ctrl_out_ck;
	wire [39:0] rx_bit_ctrl_in_ck;
	wire [39:0] tx_bit_ctrl_in_ck;

	// CC bits
	genvar i;
	generate
		for (i = 0; i < 10; i = i + 1) begin
			OBUFT OBUFT_inst (
			   .O(cc_pads[i]),
			   .I(o_cc[i]),
			   .T(t_cc[i])
			);

			TX_BITSLICE #(
			   .DATA_WIDTH(4),
			   .DELAY_FORMAT("TIME"),
			   .DELAY_TYPE("VARIABLE"),
			   .REFCLK_FREQUENCY(2667.0),
			   .SIM_DEVICE("ULTRASCALE_PLUS")
			)
			TX_BITSLICE_cc_inst (
			   .CNTVALUEOUT(CNTVALUEOUT),
			   .O(o_cc[i]),
			   .RX_BIT_CTRL_OUT(rx_bit_ctrl_in_cc[i]),
			   .TX_BIT_CTRL_OUT(tx_bit_ctrl_in_cc[i]),
			   .T_OUT(t_cc[i]),
			   .RX_BIT_CTRL_IN(rx_bit_ctrl_out_cc[i]),
			   //.TBYTE_IN(TBYTE_IN),
			   .TX_BIT_CTRL_IN(tx_bit_ctrl_out_cc[i])
			);

		end
	endgenerate


	// Ck
	OBUFTDS OBUFTDS_inst (
	   .O(ck_t_pad),
	   .OB(ck_c_pad),
	   .I(o_ck),
	   .T(t_ck)
	);

	TX_BITSLICE #(
	   .DATA_WIDTH(4),
	   .DELAY_FORMAT("TIME"),
	   .DELAY_TYPE("VARIABLE"),
	   .REFCLK_FREQUENCY(2667.0),
	   .SIM_DEVICE("ULTRASCALE_PLUS")
	)
	TX_BITSLICE_ck_inst (
	   .O(o_ck),                         
	   .RX_BIT_CTRL_OUT(rx_bit_ctrl_in_ck), 
	   .TX_BIT_CTRL_OUT(tx_bit_ctrl_in_ck), 
	   .T_OUT(t_ck),                     
	   .RX_BIT_CTRL_IN(rx_bit_ctrl_out_ck),   
	   //.TBYTE_IN(TBYTE_IN),               
	   .TX_BIT_CTRL_IN(tx_bit_ctrl_out_ck)   
	);

	
	BITSLICE_CONTROL #(
	   .DIV_MODE("DIV2"),
	   .RX_GATING("ENABLE"),
	   .TX_GATING("ENABLE"),
	   .SIM_DEVICE("ULTRASCALE_PLUS")
	)
	BITSLICE_CONTROL_cc_up (
	   .RX_BIT_CTRL_OUT0(rx_bit_ctrl_out_ck),
	   //.RX_BIT_CTRL_OUT1(),
	   .RX_BIT_CTRL_OUT2(rx_bit_ctrl_out_cc[6]),
	   .RX_BIT_CTRL_OUT3(rx_bit_ctrl_out_cc[7]),
	   .RX_BIT_CTRL_OUT4(rx_bit_ctrl_out_cc[8]),
	   .RX_BIT_CTRL_OUT5(rx_bit_ctrl_out_cc[9]),
	   //.RX_BIT_CTRL_OUT6(),
	   .TX_BIT_CTRL_OUT0(tx_bit_ctrl_out_ck),
	   //.TX_BIT_CTRL_OUT1(),
	   .TX_BIT_CTRL_OUT2(tx_bit_ctrl_out_cc[6]),
	   .TX_BIT_CTRL_OUT3(tx_bit_ctrl_out_cc[7]),
	   .TX_BIT_CTRL_OUT4(tx_bit_ctrl_out_cc[8]),
	   .TX_BIT_CTRL_OUT5(tx_bit_ctrl_out_cc[9]),
	   //.TX_BIT_CTRL_OUT6(),
	   .RIU_CLK(sys_clk),
	   .RX_BIT_CTRL_IN0(rx_bit_ctrl_in_ck),
	   //.RX_BIT_CTRL_IN1(),
	   .RX_BIT_CTRL_IN2(rx_bit_ctrl_in_cc[6]),
	   .RX_BIT_CTRL_IN3(rx_bit_ctrl_in_cc[7]),
	   .RX_BIT_CTRL_IN4(rx_bit_ctrl_in_cc[8]),
	   .RX_BIT_CTRL_IN5(rx_bit_ctrl_in_cc[9]),
	   //.RX_BIT_CTRL_IN6(),
	   //.TBYTE_IN(TBYTE_IN),
	   .TX_BIT_CTRL_IN0(tx_bit_ctrl_in_ck),
	   //.TX_BIT_CTRL_IN1(),
	   .TX_BIT_CTRL_IN2(tx_bit_ctrl_in_cc[6]),
	   .TX_BIT_CTRL_IN3(tx_bit_ctrl_in_cc[7]),
	   .TX_BIT_CTRL_IN4(tx_bit_ctrl_in_cc[8]),
	   .TX_BIT_CTRL_IN5(tx_bit_ctrl_in_cc[9])
	   //.TX_BIT_CTRL_IN6(),
	   //.TX_BIT_CTRL_IN_TRI(TX_BIT_CTRL_IN_TRI)
	);
	

	BITSLICE_CONTROL #(
	   .DIV_MODE("DIV2"),
	   .RX_GATING("ENABLE"),
	   .TX_GATING("ENABLE"),
	   .SIM_DEVICE("ULTRASCALE_PLUS")
	)
	BITSLICE_CONTROL_cc_low (
	   .RX_BIT_CTRL_OUT0(rx_bit_ctrl_out_cc[0]),
	   .RX_BIT_CTRL_OUT1(rx_bit_ctrl_out_cc[1]),
	   .RX_BIT_CTRL_OUT2(rx_bit_ctrl_out_cc[2]),
	   .RX_BIT_CTRL_OUT3(rx_bit_ctrl_out_cc[3]),
	   .RX_BIT_CTRL_OUT4(rx_bit_ctrl_out_cc[4]),
	   .RX_BIT_CTRL_OUT5(rx_bit_ctrl_out_cc[5]),
	   //.RX_BIT_CTRL_OUT6(),
	   .TX_BIT_CTRL_OUT0(tx_bit_ctrl_out_cc[0]),
	   .TX_BIT_CTRL_OUT1(tx_bit_ctrl_out_cc[1]),
	   .TX_BIT_CTRL_OUT2(tx_bit_ctrl_out_cc[2]),
	   .TX_BIT_CTRL_OUT3(tx_bit_ctrl_out_cc[3]),
	   .TX_BIT_CTRL_OUT4(tx_bit_ctrl_out_cc[4]),
	   .TX_BIT_CTRL_OUT5(tx_bit_ctrl_out_cc[5]),
	   //.TX_BIT_CTRL_OUT6(),
	   .RIU_CLK(sys_clk),
	   .RX_BIT_CTRL_IN0(rx_bit_ctrl_in_cc[0]),
	   .RX_BIT_CTRL_IN1(rx_bit_ctrl_in_cc[1]),
	   .RX_BIT_CTRL_IN2(rx_bit_ctrl_in_cc[2]),
	   .RX_BIT_CTRL_IN3(rx_bit_ctrl_in_cc[3]),
	   .RX_BIT_CTRL_IN4(rx_bit_ctrl_in_cc[4]),
	   .RX_BIT_CTRL_IN5(rx_bit_ctrl_in_cc[5]),
	   //.RX_BIT_CTRL_IN6(),
	   //.TBYTE_IN(TBYTE_IN),
	   .TX_BIT_CTRL_IN0(tx_bit_ctrl_in_cc[0]),
	   .TX_BIT_CTRL_IN1(tx_bit_ctrl_in_cc[1]),
	   .TX_BIT_CTRL_IN2(tx_bit_ctrl_in_cc[2]),
	   .TX_BIT_CTRL_IN3(tx_bit_ctrl_in_cc[3]),
	   .TX_BIT_CTRL_IN4(tx_bit_ctrl_in_cc[4]),
	   .TX_BIT_CTRL_IN5(tx_bit_ctrl_in_cc[5])
	   //.TX_BIT_CTRL_IN6()
	   //.TX_BIT_CTRL_IN_TRI(TX_BIT_CTRL_IN_TRI)
	);

endmodule

// DQ/CB nibble PHY
module ddr5_usp_phy_nibble
	(
		input wire sys_clk,
		inout wire [3:0]dq_pads,
		inout wire dqs_t_pad,
		inout wire dqs_c_pad
	);


	wire [3:0]i_dq;
	wire [3:0]o_dq;
	wire [3:0]t_dq;

	wire i_dqs;
	wire o_dqs;
	wire t_dqs;

	wire [39:0]rx_bit_ctrl_in  [7];
	wire [39:0]rx_bit_ctrl_out [7];
	wire [39:0]tx_bit_ctrl_in  [7];
	wire [39:0]tx_bit_ctrl_out [7];

	// DQ bits
	genvar i;
	generate
		for (i = 0; i < 4; i = i + 1) begin

			IOBUF_DCIEN #(
			   .SIM_DEVICE("ULTRASCALE"), 
			   .USE_IBUFDISABLE("False")  
			)
			IOBUF_DCIEN_inst (
			   .O(i_dq[i]),               
			   .DCITERMDISABLE(1'b1),	
			   .I(o_dq[i]),                 
			   //.IBUFDISABLE(IBUFDISABLE), 
			   .IO(dq_pads[i]),             
			   .T(t_dq[i])                  
			);

			RXTX_BITSLICE #(
			   .RX_DATA_TYPE("DATA"),      
			   .RX_DATA_WIDTH(4),
			   .RX_DELAY_TYPE("VARIABLE"),    
			   .RX_REFCLK_FREQUENCY(2667.0), 
			   .SIM_DEVICE("ULTRASCALE_PLUS"),
			   .TX_DATA_WIDTH(4),
			   .TX_DELAY_TYPE("VARIABLE"),   
			   .TX_REFCLK_FREQUENCY(2667.0) 
			)
			RXTX_BITSLICE_phy_nibble_inst (
			   .O(o_dq[i]),                  
			   .RX_BIT_CTRL_OUT(rx_bit_ctrl_in[i+2]), // DQS is bitslice 0 and 1 so we start from 2 for DQ
			   .TX_BIT_CTRL_OUT(tx_bit_ctrl_in[i+2]),
			   .T_OUT(t_dq[i]),                    
			   .DATAIN(i_dq[i]),                  
			   .RX_BIT_CTRL_IN(rx_bit_ctrl_out[i+2]),  
			   //.TBYTE_IN(TBYTE_IN),              
			   .TX_BIT_CTRL_IN(tx_bit_ctrl_out[i+2])
			);
		end
	endgenerate

	// DQS signal
	IOBUFDS_DCIEN #(
	   .SIM_DEVICE("ULTRASCALE"),
	   .USE_IBUFDISABLE("FALSE")  
	)
	IOBUFDS_DCIEN_inst (
	   .O(i_dqs),                  
	   .DCITERMDISABLE(1'b0),      
	   .I(o_dqs),                  
	   //.IBUFDISABLE(IBUFDISABLE),
	   .IO(dqs_t_pad),              
	   .IOB(dqs_c_pad),             
	   .T(t_dqs)                    
	);


	RXTX_BITSLICE #(
	   .RX_DATA_TYPE("DATA_AND_CLOCK"),
	   .RX_DATA_WIDTH(4),
	   .RX_DELAY_TYPE("VARIABLE"),  
	   .RX_REFCLK_FREQUENCY(2667.0), 
	   .SIM_DEVICE("ULTRASCALE_PLUS"),
	   .TX_DATA_WIDTH(4),
	   .TX_DELAY_TYPE("VARIABLE"),    
	   .TX_REFCLK_FREQUENCY(2667.0)   
	)
	RXTX_BITSLICE_dqs_inst (
	   .O(o_dqs),                          
	   .RX_BIT_CTRL_OUT(rx_bit_ctrl_in[0]), // Clock is always 1st BITSLICE in nibble
	   .TX_BIT_CTRL_OUT(tx_bit_ctrl_in[0]),
	   .T_OUT(t_dqs),                     
	   .DATAIN(i_dqs),                   
	   .RX_BIT_CTRL_IN(rx_bit_ctrl_out[0]),
	   //.TBYTE_IN(TBYTE_IN),             
	   .TX_BIT_CTRL_IN(tx_bit_ctrl_out[0]) 
	);


	// Bitslice control
	
	BITSLICE_CONTROL #(
	   .DIV_MODE("DIV2"),               // Controller DIV2/DIV4 mode (DIV2, DIV4)
	   .RX_GATING("ENABLE"),            // ENABLE/DISABLE read DQS gating
	   .TX_GATING("ENABLE"),             // ENABLE/DISABLE clock gating in WClkgen
	   .SIM_DEVICE("ULTRASCALE_PLUS")
	)
	BITSLICE_CONTROL_phy_nibble_inst (
	   .RX_BIT_CTRL_OUT0(rx_bit_ctrl_out[0]),       // 40-bit output: Output bus to Bitslice 0
	   .RX_BIT_CTRL_OUT1(rx_bit_ctrl_out[1]),       // 40-bit output: Output bus to Bitslice 1
	   .RX_BIT_CTRL_OUT2(rx_bit_ctrl_out[2]),       // 40-bit output: Output bus to Bitslice 2
	   .RX_BIT_CTRL_OUT3(rx_bit_ctrl_out[3]),       // 40-bit output: Output bus to Bitslice 3
	   .RX_BIT_CTRL_OUT4(rx_bit_ctrl_out[4]),       // 40-bit output: Output bus to Bitslice 4
	   .RX_BIT_CTRL_OUT5(rx_bit_ctrl_out[5]),       // 40-bit output: Output bus to Bitslice 5
	   .RX_BIT_CTRL_OUT6(rx_bit_ctrl_out[6]),       // 40-bit output: Output bus to Bitslice 6
	   .TX_BIT_CTRL_OUT0(tx_bit_ctrl_out[0]),       // 40-bit output: Output bus to Bitslice 0
	   .TX_BIT_CTRL_OUT1(tx_bit_ctrl_out[1]),       // 40-bit output: Output bus to Bitslice 1
	   .TX_BIT_CTRL_OUT2(tx_bit_ctrl_out[2]),       // 40-bit output: Output bus to Bitslice 2
	   .TX_BIT_CTRL_OUT3(tx_bit_ctrl_out[3]),       // 40-bit output: Output bus to Bitslice 3
	   .TX_BIT_CTRL_OUT4(tx_bit_ctrl_out[4]),       // 40-bit output: Output bus to Bitslice 4
	   .TX_BIT_CTRL_OUT5(tx_bit_ctrl_out[5]),       // 40-bit output: Output bus to Bitslice 5
	   .TX_BIT_CTRL_OUT6(tx_bit_ctrl_out[6]),       // 40-bit output: Output bus to Bitslice 6
	   .RIU_CLK(sys_clk),                           // 1-bit input: System clock from fabric for RIU access
	   .RX_BIT_CTRL_IN0(rx_bit_ctrl_in[0]),         // 40-bit input: Input bus from Bitslice 0
	   .RX_BIT_CTRL_IN1(rx_bit_ctrl_in[1]),         // 40-bit input: Input bus from Bitslice 1
	   .RX_BIT_CTRL_IN2(rx_bit_ctrl_in[2]),         // 40-bit input: Input bus from Bitslice 2
	   .RX_BIT_CTRL_IN3(rx_bit_ctrl_in[3]),         // 40-bit input: Input bus from Bitslice 3
	   .RX_BIT_CTRL_IN4(rx_bit_ctrl_in[4]),         // 40-bit input: Input bus from Bitslice 4
	   .RX_BIT_CTRL_IN5(rx_bit_ctrl_in[5]),         // 40-bit input: Input bus from Bitslice 5
	   .RX_BIT_CTRL_IN6(rx_bit_ctrl_in[6]),         // 40-bit input: Input bus from Bitslice 6
	   //.TBYTE_IN(TBYTE_IN),                       // 4-bit input: Output enable for 3-state control
	   .TX_BIT_CTRL_IN0(tx_bit_ctrl_in[0]),         // 40-bit input: Input bus from Bitslice 0
	   .TX_BIT_CTRL_IN1(tx_bit_ctrl_in[1]),         // 40-bit input: Input bus from Bitslice 1
	   .TX_BIT_CTRL_IN2(tx_bit_ctrl_in[2]),         // 40-bit input: Input bus from Bitslice 2
	   .TX_BIT_CTRL_IN3(tx_bit_ctrl_in[3]),         // 40-bit input: Input bus from Bitslice 3
	   .TX_BIT_CTRL_IN4(tx_bit_ctrl_in[4]),         // 40-bit input: Input bus from Bitslice 4
	   .TX_BIT_CTRL_IN5(tx_bit_ctrl_in[5]),         // 40-bit input: Input bus from Bitslice 5
	   .TX_BIT_CTRL_IN6(tx_bit_ctrl_in[6])         // 40-bit input: Input bus from Bitslice 6
	   //.TX_BIT_CTRL_IN_TRI(TX_BIT_CTRL_IN_TRI)    // 40-bit input: Input bus from 3-state TX_BITSLICE_TRI
	);

	// End of BITSLICE_CONTROL_inst instantiation


endmodule

