module ddr5_usp_phy
        #(
            parameter integer A_DQ_BITSLICE_LANES[32],
            parameter integer A_DQS_BITSLICE_LANES[8],
            parameter integer B_DQ_BITSLICE_LANES[32],
            parameter integer B_DQS_BITSLICE_LANES[8],
            parameter integer A_CB_BITSLICE_LANES[8],
            parameter integer B_CB_BITSLICE_LANES[8],
            parameter integer A_DQSB_BITSLICE_LANES[2],
            parameter integer B_DQSB_BITSLICE_LANES[2],
            parameter integer A_CC_BITSLICE_LANES[10],
            parameter integer B_CC_BITSLICE_LANES[10],
            parameter integer CK_BITSLICE_LANE
        )
        (
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
                output wire [9:0]B_cc_pads, // CA, PAR and CS_c
                output wire ck_t_pad,
                output wire ck_c_pad
        );

        // DQ bytes
        genvar i;
        generate
                for (i = 0; i < 4; i = i + 1) begin
                        ddr5_usp_phy_nibble #(
                            .DQ_BITSLICE_LANES(A_DQ_BITSLICE_LANES[i*8+0:i*8+3]),
                            .DQS_BITSLICE_LANE(A_DQS_BITSLICE_LANES[i])
                        )
                        phy_nibble_A_dq_low_inst(
                                .sys_clk(sys_clk),
                                .dq_pads(A_dq_pads[i*8+3:i*8+0]),
                                .dqs_t_pad(A_dqs_t_pads[i]),
                                .dqs_c_pad(A_dqs_c_pads[i])
                        );
                        ddr5_usp_phy_nibble #(
                            .DQ_BITSLICE_LANES(A_DQ_BITSLICE_LANES[i*8+4:i*8+7]),
                            .DQS_BITSLICE_LANE(A_DQS_BITSLICE_LANES[i+4])
                        )
                        phy_nibble_A_dq_up_inst(
                                .sys_clk(sys_clk),
                                .dq_pads(A_dq_pads[i*8+7:i*8+4]),
                                .dqs_t_pad(A_dqs_t_pads[i+4]),
                                .dqs_c_pad(A_dqs_c_pads[i+4])
                        );

                        ddr5_usp_phy_nibble #(
                            .DQ_BITSLICE_LANES(B_DQ_BITSLICE_LANES[i*8+0:i*8+3]),
                            .DQS_BITSLICE_LANE(B_DQS_BITSLICE_LANES[i])
                        )
                        phy_nibble_B_dq_low_inst(
                                .sys_clk(sys_clk),
                                .dq_pads(B_dq_pads[i*8+3:i*8+0]),
                                .dqs_t_pad(B_dqs_t_pads[i]),
                                .dqs_c_pad(B_dqs_c_pads[i])
                        );
                        ddr5_usp_phy_nibble #(
                            .DQ_BITSLICE_LANES(B_DQ_BITSLICE_LANES[i*8+4:i*8+7]),
                            .DQS_BITSLICE_LANE(B_DQS_BITSLICE_LANES[i+4])
                        )
                        phy_nibble_B_dq_up_inst(
                                .sys_clk(sys_clk),
                                .dq_pads(B_dq_pads[i*8+7:i*8+4]),
                                .dqs_t_pad(B_dqs_t_pads[i+4]),
                                .dqs_c_pad(B_dqs_c_pads[i+4])
                        );
                end
        endgenerate

        // CB byte
        ddr5_usp_phy_nibble #(
            .DQ_BITSLICE_LANES(A_CB_BITSLICE_LANES[0:3]),
            .DQS_BITSLICE_LANE(A_DQSB_BITSLICE_LANES[0])
        )
        phy_nibble_A_cb_low_inst(
                .sys_clk(sys_clk),
                .dq_pads(A_cb_pads[3:0]),
                .dqs_t_pad(A_dqsb_t_pads[0]),
                .dqs_c_pad(A_dqsb_c_pads[0])
        );
        ddr5_usp_phy_nibble #(
            .DQ_BITSLICE_LANES(A_CB_BITSLICE_LANES[4:7]),
            .DQS_BITSLICE_LANE(A_DQSB_BITSLICE_LANES[1])
        )
        phy_nibble_A_cb_up_inst(
                .sys_clk(sys_clk),
                .dq_pads(A_cb_pads[7:4]),
                .dqs_t_pad(A_dqsb_t_pads[1]),
                .dqs_c_pad(A_dqsb_c_pads[1])
        );

        ddr5_usp_phy_nibble #(
            .DQ_BITSLICE_LANES(B_CB_BITSLICE_LANES[0:3]),
            .DQS_BITSLICE_LANE(B_DQSB_BITSLICE_LANES[0])
        )
        phy_nibble_B_cb_low_inst(
                .sys_clk(sys_clk),
                .dq_pads(B_cb_pads[3:0]),
                .dqs_t_pad(B_dqsb_t_pads[0]),
                .dqs_c_pad(B_dqsb_c_pads[0])
        );
        ddr5_usp_phy_nibble #(
            .DQ_BITSLICE_LANES(B_CB_BITSLICE_LANES[4:7]),
            .DQS_BITSLICE_LANE(B_DQSB_BITSLICE_LANES[1])
        )
        phy_nibble_B_cb_up_inst(
                .sys_clk(sys_clk),
                .dq_pads(B_cb_pads[7:4]),
                .dqs_t_pad(B_dqsb_t_pads[1]),
                .dqs_c_pad(B_dqsb_c_pads[1])
        );

        // Command & control
        ddr5_usp_phy_cc #(
                .A_CC_BITSLICE_LANES(A_CC_BITSLICE_LANES),
                .B_CC_BITSLICE_LANES(B_CC_BITSLICE_LANES),
                .CK_BITSLICE_LANE(CK_BITSLICE_LANE)
        )
        phy_A_cc_inst(
                .sys_clk(sys_clk),
                .A_cc_pads(A_cc_pads),
                .B_cc_pads(B_cc_pads),
                .ck_t_pad(ck_t_pad),
                .ck_c_pad(ck_c_pad)
        );

endmodule

// Command & control PHY
// BITSLICE lanes need to be defined for each signal
// BITSLICE lane are numbered as follows:
// Byte 0 lower nibble  6:0
// Byte 0 upper nibble 13:7
// Byte 1 lower nibble 20:14
// Byte 1 upper nibble 27:21
module ddr5_usp_phy_cc
        #(
            parameter integer A_CC_BITSLICE_LANES[10],
            parameter integer B_CC_BITSLICE_LANES[10],
            parameter integer CK_BITSLICE_LANE
        )
        (
                input wire sys_clk,
                output wire [9:0]A_cc_pads, // CA, PAR and CS_c
                output wire [9:0]B_cc_pads,
                output wire ck_t_pad,
                output wire ck_c_pad
        );

        wire [9:0]o_A_cc;
        wire [9:0]t_A_cc;

        wire [9:0]o_B_cc;
        wire [9:0]t_B_cc;

        wire o_ck;
        wire t_ck;

        wire tri_out[28];

        wire [39:0]rx_bit_ctrl_out[28];
        wire [39:0]tx_bit_ctrl_out[28];
        wire [39:0]rx_bit_ctrl_in[28];
        wire [39:0]tx_bit_ctrl_in[28];

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
                .RX_BIT_CTRL_OUT(rx_bit_ctrl_in[CK_BITSLICE_LANE]),
                .TX_BIT_CTRL_OUT(tx_bit_ctrl_in[CK_BITSLICE_LANE]),
                .T_OUT(t_ck),
                .RX_BIT_CTRL_IN(rx_bit_ctrl_out[CK_BITSLICE_LANE]),
                .TBYTE_IN(tri_out[CK_BITSLICE_LANE]),
                .TX_BIT_CTRL_IN(tx_bit_ctrl_out[CK_BITSLICE_LANE])
        );

        // CC bits
        genvar i;
        generate
            for (i = 0; i < 10; i = i + 1) begin

                    OBUFT OBUFT_A_inst (
                            .O(A_cc_pads[i]),
                            .I(o_A_cc[i]),
                            .T(t_A_cc[i])
                    );

                    TX_BITSLICE #(
                            .DATA_WIDTH(4),
                            .DELAY_FORMAT("TIME"),
                            .DELAY_TYPE("VARIABLE"),
                            .REFCLK_FREQUENCY(2667.0),
                            .SIM_DEVICE("ULTRASCALE_PLUS")
                    )
                    TX_BITSLICE_A_cc_inst (
                            .O(o_A_cc[i]),
                            .RX_BIT_CTRL_OUT(rx_bit_ctrl_in[A_CC_BITSLICE_LANES[i]]),
                            .TX_BIT_CTRL_OUT(tx_bit_ctrl_in[A_CC_BITSLICE_LANES[i]]),
                            .T_OUT(t_A_cc[i]),
                            .RX_BIT_CTRL_IN(rx_bit_ctrl_out[A_CC_BITSLICE_LANES[i]]),
                            .TBYTE_IN(tri_out[A_CC_BITSLICE_LANES[i]]),
                            .TX_BIT_CTRL_IN(tx_bit_ctrl_out[A_CC_BITSLICE_LANES[i]])
                    );

                    OBUFT OBUFT_B_inst (
                            .O(B_cc_pads[i]),
                            .I(o_B_cc[i]),
                            .T(t_B_cc[i])
                    );

                    TX_BITSLICE #(
                            .DATA_WIDTH(4),
                            .DELAY_FORMAT("TIME"),
                            .DELAY_TYPE("VARIABLE"),
                            .REFCLK_FREQUENCY(2667.0),
                            .SIM_DEVICE("ULTRASCALE_PLUS")
                    )
                    TX_BITSLICE_B_cc_inst (
                            .O(o_B_cc[i]),
                            .RX_BIT_CTRL_OUT(rx_bit_ctrl_in[B_CC_BITSLICE_LANES[i]]),
                            .TX_BIT_CTRL_OUT(tx_bit_ctrl_in[B_CC_BITSLICE_LANES[i]]),
                            .T_OUT(t_B_cc[i]),
                            .RX_BIT_CTRL_IN(rx_bit_ctrl_out[B_CC_BITSLICE_LANES[i]]),
                            .TBYTE_IN(tri_out[B_CC_BITSLICE_LANES[i]]),
                            .TX_BIT_CTRL_IN(tx_bit_ctrl_out[B_CC_BITSLICE_LANES[i]])
                    );

            end
        endgenerate

        // BITSLICE controls

        wire [39:0]tri_bit_ctrl_out[4];
        wire [39:0]tri_bit_ctrl_in[4];
        wire tri_out_raw[4];

        generate
            for (i = 0; i < 4; i = i + 1) begin
                BITSLICE_CONTROL #(
                        .DIV_MODE("DIV2"),
                        .RX_GATING("ENABLE"),
                        .TX_GATING("ENABLE"),
                        .SIM_DEVICE("ULTRASCALE_PLUS")
                )
                BITSLICE_CONTROL_cc_inst (
                        .RX_BIT_CTRL_OUT0(rx_bit_ctrl_out[7*i+0]),
                        .RX_BIT_CTRL_OUT1(rx_bit_ctrl_out[7*i+1]),
                        .RX_BIT_CTRL_OUT2(rx_bit_ctrl_out[7*i+2]),
                        .RX_BIT_CTRL_OUT3(rx_bit_ctrl_out[7*i+3]),
                        .RX_BIT_CTRL_OUT4(rx_bit_ctrl_out[7*i+4]),
                        .RX_BIT_CTRL_OUT5(rx_bit_ctrl_out[7*i+5]),
                        .RX_BIT_CTRL_OUT6(rx_bit_ctrl_out[7*i+6]),
                        .TX_BIT_CTRL_OUT0(tx_bit_ctrl_out[7*i+0]),
                        .TX_BIT_CTRL_OUT1(tx_bit_ctrl_out[7*i+1]),
                        .TX_BIT_CTRL_OUT2(tx_bit_ctrl_out[7*i+2]),
                        .TX_BIT_CTRL_OUT3(tx_bit_ctrl_out[7*i+3]),
                        .TX_BIT_CTRL_OUT4(tx_bit_ctrl_out[7*i+4]),
                        .TX_BIT_CTRL_OUT5(tx_bit_ctrl_out[7*i+5]),
                        .TX_BIT_CTRL_OUT6(tx_bit_ctrl_out[7*i+6]),
                        .TX_BIT_CTRL_OUT_TRI(tri_bit_ctrl_out[i]),
                        .RIU_CLK(sys_clk),
                        .RX_BIT_CTRL_IN0(rx_bit_ctrl_in[7*i+0]),
                        .RX_BIT_CTRL_IN1(rx_bit_ctrl_in[7*i+1]),
                        .RX_BIT_CTRL_IN2(rx_bit_ctrl_in[7*i+2]),
                        .RX_BIT_CTRL_IN3(rx_bit_ctrl_in[7*i+3]),
                        .RX_BIT_CTRL_IN4(rx_bit_ctrl_in[7*i+4]),
                        .RX_BIT_CTRL_IN5(rx_bit_ctrl_in[7*i+5]),
                        .RX_BIT_CTRL_IN6(rx_bit_ctrl_in[7*i+6]),
                        //.TBYTE_IN(TBYTE_IN),
                        .TX_BIT_CTRL_IN0(tx_bit_ctrl_in[7*i+0]),
                        .TX_BIT_CTRL_IN1(tx_bit_ctrl_in[7*i+1]),
                        .TX_BIT_CTRL_IN2(tx_bit_ctrl_in[7*i+2]),
                        .TX_BIT_CTRL_IN3(tx_bit_ctrl_in[7*i+3]),
                        .TX_BIT_CTRL_IN4(tx_bit_ctrl_in[7*i+4]),
                        .TX_BIT_CTRL_IN5(tx_bit_ctrl_in[7*i+5]),
                        .TX_BIT_CTRL_IN6(tx_bit_ctrl_in[7*i+6]),
                        .TX_BIT_CTRL_IN_TRI(tri_bit_ctrl_in[i])
                );

                assign tri_out[7*i+6:7*i] = '{7{tri_out_raw[i]}};

                TX_BITSLICE_TRI #(
                        .DATA_WIDTH(4),
                        .DELAY_FORMAT("TIME"),
                        .DELAY_TYPE("VARIABLE"),
                        .REFCLK_FREQUENCY(2667.0),
                        .SIM_DEVICE("ULTRASCALE_PLUS")
                )
                TX_BITSLICE_TRI_inst (
                        .BIT_CTRL_OUT(tri_bit_ctrl_in[i]),
                        .TRI_OUT(tri_out_raw[i]),
                        .BIT_CTRL_IN(tri_bit_ctrl_out[i])
                );
            end
        endgenerate
endmodule

// DQ/CB nibble PHY
// BITSLICE lanes need to be defined for each signal
// BITSLICE lanes are numered from 0 to 6 for each nibble 
// Lane 0 is typically used by DQS while lanes 2 to 5 by DQ signals
module ddr5_usp_phy_nibble
        #(
            parameter integer DQ_BITSLICE_LANES[4] = {2, 3, 4, 5},
            parameter integer DQS_BITSLICE_LANE = 0
        )
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

        wire [39:0]rx_bit_ctrl_in[7];
        wire [39:0]rx_bit_ctrl_out[7];
        wire [39:0]tx_bit_ctrl_in[7];
        wire [39:0]tx_bit_ctrl_out[7];

        wire [39:0]tri_bit_ctrl_out;
        wire [39:0]tri_bit_ctrl_in;
        wire tri_out;

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
                                .RX_BIT_CTRL_OUT(rx_bit_ctrl_in[DQ_BITSLICE_LANES[i]]),
                                .TX_BIT_CTRL_OUT(tx_bit_ctrl_in[DQ_BITSLICE_LANES[i]]),
                                .T_OUT(t_dq[i]),
                                .DATAIN(i_dq[i]),
                                .RX_BIT_CTRL_IN(rx_bit_ctrl_out[DQ_BITSLICE_LANES[i]]),
                                .TBYTE_IN(tri_out),
                                .TX_BIT_CTRL_IN(tx_bit_ctrl_out[DQ_BITSLICE_LANES[i]])
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
                .RX_BIT_CTRL_OUT(rx_bit_ctrl_in[DQS_BITSLICE_LANE]),
                .TX_BIT_CTRL_OUT(tx_bit_ctrl_in[DQS_BITSLICE_LANE]),
                .T_OUT(t_dqs),
                .DATAIN(i_dqs),
                .RX_BIT_CTRL_IN(rx_bit_ctrl_out[DQS_BITSLICE_LANE]),
                .TBYTE_IN(tri_out),
                .TX_BIT_CTRL_IN(tx_bit_ctrl_out[DQS_BITSLICE_LANE])
        );


        // Bitslice control

        BITSLICE_CONTROL #(
                .DIV_MODE("DIV2"),
                .RX_GATING("ENABLE"),
                .TX_GATING("ENABLE"),
                .SIM_DEVICE("ULTRASCALE_PLUS")
        )
        BITSLICE_CONTROL_phy_nibble_inst (
                .RX_BIT_CTRL_OUT0(rx_bit_ctrl_out[0]),
                .RX_BIT_CTRL_OUT1(rx_bit_ctrl_out[1]),
                .RX_BIT_CTRL_OUT2(rx_bit_ctrl_out[2]),
                .RX_BIT_CTRL_OUT3(rx_bit_ctrl_out[3]),
                .RX_BIT_CTRL_OUT4(rx_bit_ctrl_out[4]),
                .RX_BIT_CTRL_OUT5(rx_bit_ctrl_out[5]),
                .RX_BIT_CTRL_OUT6(rx_bit_ctrl_out[6]),
                .TX_BIT_CTRL_OUT0(tx_bit_ctrl_out[0]),
                .TX_BIT_CTRL_OUT1(tx_bit_ctrl_out[1]),
                .TX_BIT_CTRL_OUT2(tx_bit_ctrl_out[2]),
                .TX_BIT_CTRL_OUT3(tx_bit_ctrl_out[3]),
                .TX_BIT_CTRL_OUT4(tx_bit_ctrl_out[4]),
                .TX_BIT_CTRL_OUT5(tx_bit_ctrl_out[5]),
                .TX_BIT_CTRL_OUT6(tx_bit_ctrl_out[6]),
                .TX_BIT_CTRL_OUT_TRI(tri_bit_ctrl_out),
                .RIU_CLK(sys_clk),
                .RX_BIT_CTRL_IN0(rx_bit_ctrl_in[0]),
                .RX_BIT_CTRL_IN1(rx_bit_ctrl_in[1]),
                .RX_BIT_CTRL_IN2(rx_bit_ctrl_in[2]),
                .RX_BIT_CTRL_IN3(rx_bit_ctrl_in[3]),
                .RX_BIT_CTRL_IN4(rx_bit_ctrl_in[4]),
                .RX_BIT_CTRL_IN5(rx_bit_ctrl_in[5]),
                .RX_BIT_CTRL_IN6(rx_bit_ctrl_in[6]),
                //.TBYTE_IN(TBYTE_IN),
                .TX_BIT_CTRL_IN0(tx_bit_ctrl_in[0]),
                .TX_BIT_CTRL_IN1(tx_bit_ctrl_in[1]),
                .TX_BIT_CTRL_IN2(tx_bit_ctrl_in[2]),
                .TX_BIT_CTRL_IN3(tx_bit_ctrl_in[3]),
                .TX_BIT_CTRL_IN4(tx_bit_ctrl_in[4]),
                .TX_BIT_CTRL_IN5(tx_bit_ctrl_in[5]),
                .TX_BIT_CTRL_IN6(tx_bit_ctrl_in[6]),
                .TX_BIT_CTRL_IN_TRI(tri_bit_ctrl_in)
        );

        TX_BITSLICE_TRI #(
                .DATA_WIDTH(4),
                .DELAY_FORMAT("TIME"),
                .DELAY_TYPE("VARIABLE"),
                .REFCLK_FREQUENCY(2667.0),
                .SIM_DEVICE("ULTRASCALE_PLUS")
        )
        TX_BITSLICE_TRI_inst (
                .BIT_CTRL_OUT(tri_bit_ctrl_in),
                .TRI_OUT(tri_out),
                .BIT_CTRL_IN(tri_bit_ctrl_out)
        );

endmodule

