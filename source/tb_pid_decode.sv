// $Id: $
// File name:   tb_pid_decode.sv
// Created:     4/25/2016
// Author:      Dan Suciu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: test benching for pid decode block

`timescale 1ns / 100ps

module tb_pid_decode();

reg [7:0] tb_rcv_data;
reg tb_n_rst, tb_w_enable, tb_enable_pad, tb_enable_data, tb_enable_pid, tb_enable_nondata;

// BEGIN CLK GEN
reg tb_clk;
localparam CLK_PERIOD = 10;
always begin : CLK_GEN
	tb_clk = 1'b0;
	#(CLK_PERIOD/2);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2);
end
// END CLK GEN 

pid_decode DUT(.clk(tb_clk), .n_rst(tb_n_rst), .w_enable(tb_w_enable), .rcv_data(tb_rcv_data), .enable_pad(tb_enable_pad), .enable_data(tb_enable_data), .enable_pid(tb_enable_pid), .enable_nondata(tb_enable_nondata));

initial begin
	tb_n_rst = 1;
	tb_rcv_data = 8'b00000000;
	@(negedge tb_clk);
	tb_n_rst = 0;
	@(negedge tb_clk);
	tb_n_rst = 1;
	@(negedge tb_clk);
	tb_rcv_data = 8'b11110000; //data PID
	@(negedge tb_clk);
	tb_w_enable = 1;
	@(negedge tb_clk);
	tb_w_enable = 0;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_rcv_data = 8'b10101010; //random data packet
	@(negedge tb_clk);
	tb_w_enable = 1;
	@(negedge tb_clk);
	tb_w_enable = 0;
	@(negedge tb_clk);
	tb_rcv_data = 8'b00000000; //crc packets (2)
	@(negedge tb_clk);
	tb_w_enable = 1;
	@(negedge tb_clk);
	tb_w_enable = 0;
	@(negedge tb_clk);
	tb_w_enable = 1;
	@(negedge tb_clk);
	tb_w_enable = 0;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_rcv_data = 8'b00011110; //token PID
	@(negedge tb_clk);
	tb_w_enable = 1;
	@(negedge tb_clk);
	tb_w_enable = 0;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_rcv_data = 8'b11001100; //random non-data packet
	@(negedge tb_clk);
	tb_w_enable = 1;
	@(negedge tb_clk);
	tb_w_enable = 0;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_rcv_data = 8'b00110011; //random non-data packet
	@(negedge tb_clk);
	tb_w_enable = 1;
	@(negedge tb_clk);
	tb_w_enable = 0;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_rcv_data = 8'b00000000; //invalid PID
	@(negedge tb_clk);
	tb_w_enable = 1;
	@(negedge tb_clk);
	tb_w_enable = 0;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
end

endmodule
