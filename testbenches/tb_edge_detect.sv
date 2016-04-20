// $Id: $
// File name:   tb_mealy.sv
// Created:     2/10/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 
// Test Bench for Mealy Machine 1101 Detector

`timescale 1ns / 100ps

module tb_edge_detect();

   localparam CLK_PERIOD = 10;

   reg tb_clk;
   reg tb_n_rst;
   reg tb_d_plus;
   reg tb_d_edge;

   always begin : CLK_GEN
	tb_clk = 1'b0;
	#(CLK_PERIOD/2);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2);
   end
   
   edge_detect DUT(.clk(tb_clk), .n_rst(tb_n_rst), .d_plus(tb_d_plus), .d_edge(tb_d_edge));
   
   initial
     begin 
	#1;
	tb_n_rst = 1'b0;
	tb_d_plus = 0;
	@(negedge tb_clk);
	#1;
	tb_n_rst = 1'b1;
	tb_d_plus = 0;
	@(negedge tb_clk);
	
	#1;
	tb_d_plus = 1;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	#1;
	tb_d_plus = 0;
	@(negedge tb_clk);
	#1;
	tb_n_rst = 1'b0;
	@(negedge tb_clk);
	#1;
	tb_n_rst = 1'b1;
	tb_d_plus = 1;
	@(negedge tb_clk);
	
	
     end // initial begin
endmodule // tb_edge_detect

