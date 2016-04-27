// $Id: $
// File name:   tb_aes_control.sv
// Created:     4/26/2016
// Author:      Alexander Dunker
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test bench for testing the AES controller

`timescale 1ns / 10ps

module tb_aes_control
	();

	localparam CLK_PERIOD = 2.5;
	localparam CHECK_DELAY = 1;

	reg tb_clk;
	reg tb_n_rst;
	logic tb_ready;
	logic [0:127] tb_data_in;
	logic tb_complete;
	logic [0:127] tb_data_out;

	aes_control controller (.clk(tb_clk), .n_rst(tb_n_rst), .ready(tb_ready), .data_in(tb_data_in), .complete(tb_complete), .data_out(tb_data_out));

	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	initial
	begin
		@(posedge tb_clk);
		tb_n_rst = 0;
		tb_ready = 0;
		@(posedge tb_clk);
		tb_n_rst = 1;
		@(posedge tb_clk);
		//tb_data_in = 128'h2b7e151628aed2a6abf7158809cf4f3c; // from NIST
		tb_data_in = 128'h616172647661726b616172647661726b;
		tb_ready = 1;
		@(posedge tb_clk);
		tb_ready = 0;
		@(posedge tb_clk);
		//tb_data_in = 128'h3243f6a8885a308d313198a2e0370734; // from NIST
		tb_data_in = 128'h61646a6163656e746163746976617465; // expected = b1e9645c3fc771108b4ce598d2896ee5 
		tb_ready = 1;
		@(posedge tb_clk);
		tb_ready = 0;
		@(posedge tb_clk);
		@(posedge tb_clk);
		tb_data_in = 128'h626564736f7265736265646672616d65; // expected = 36b8bd11fb127be91568ba69c370cbe5
		tb_ready = 1;
		@(posedge tb_clk);
		tb_ready = 0;
		@(posedge tb_clk);
	end

endmodule