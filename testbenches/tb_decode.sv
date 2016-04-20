// $Id: $
// File name:   tb_mealy.sv
// Created:     2/10/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 
// Test Bench for Mealy Machine 1101 Detector

`timescale 1ns / 100ps

module tb_decode();
   
   localparam CLK_PERIOD = 10;

   reg tb_clk;
   reg tb_n_rst;
   reg tb_d_plus;
   reg tb_shift_enable;
   reg tb_eop;
   reg tb_d_orig;
   
   always begin : CLK_GEN
	tb_clk = 1'b0;
	#(CLK_PERIOD/2);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2);
   end

   decode decoder(.clk(tb_clk), .n_rst(tb_n_rst), .d_plus(tb_d_plus), .shift_enable(tb_shift_enable), .eop(tb_eop), .d_orig(tb_d_orig));
   
   initial
     begin 
	tb_n_rst = 0;
	tb_d_plus = 0;
	tb_shift_enable = 0;
	tb_eop = 0;
	#1;
	@(negedge tb_clk);
	tb_n_rst = 1;
	tb_shift_enable = 1;
	#1;
	@(negedge tb_clk);
	tb_d_plus = 1;
	#1;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_eop = 1;
	#1;
	@(negedge tb_clk);
	tb_d_plus = 0;
	tb_eop = 0;
	#1;
	@(negedge tb_clk);
	tb_d_plus = 1;
	tb_eop = 0;
	#1;
	@(negedge tb_clk);
	tb_d_plus = 0;
	tb_eop = 1;
	#1;
	@(negedge tb_clk);
	tb_shift_enable = 0;
	tb_eop = 0;
	#1;
	@(negedge tb_clk);
	tb_eop = 1;
	#1;
	@(negedge tb_clk);
	tb_n_rst = 0;
	#1;
	@(negedge tb_clk);
	tb_shift_enable = 1;
	tb_eop = 1;
	#1;@(negedge tb_clk);
	tb_eop = 0;
	tb_d_plus = 1;
	#1;@(negedge tb_clk);
	tb_d_plus = 0;
	#1;@(negedge tb_clk);
	tb_d_plus = 1;
	#1;@(negedge tb_clk);
	tb_d_plus = 1;
	#1;@(negedge tb_clk);
	tb_d_plus = 0;
	#1;@(negedge tb_clk);
	tb_d_plus = 1;
	#1;@(negedge tb_clk);
	tb_d_plus = 0;
	#1;@(negedge tb_clk);
	tb_d_plus = 1;
	#1;@(negedge tb_clk);
	tb_d_plus = 0;
	#1;@(negedge tb_clk);
	tb_d_plus = 1;
	#1;@(negedge tb_clk);
	tb_eop = 1;
	tb_d_plus = 0;
	tb_shift_enable = 0;
	#1;@(negedge tb_clk);
	#1;@(negedge tb_clk);

     end // initial begin
endmodule // tb_edge_detect

