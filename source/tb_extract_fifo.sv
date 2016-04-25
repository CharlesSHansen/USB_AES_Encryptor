// $Id: $
// File name:   tb_extract_fifo.sv
// Created:     2/10/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 
// Test Bench for Mealy Machine 1101 Detector

`timescale 1ns / 100ps

module tb_extract_fifo();

   localparam CLK_PERIOD = 10;

   reg tb_clk;
   reg tb_n_rst;
   reg tb_full;
   reg [7:0] tb_data;
   reg 	     tb_ready;
   reg 	     tb_pop;
   reg [127:0] tb_out;
   integer     i;
   
   always begin : CLK_GEN
      tb_clk = 1'b0;
      #(CLK_PERIOD/2);
      tb_clk = 1'b1;
      #(CLK_PERIOD/2);
   end
   
   extract_fifo TEST(.clk(tb_clk), .n_rst(tb_n_rst), .full(tb_full), .data(tb_data), .pop(tb_pop), .ready(tb_ready), .out(tb_out));

   initial
     begin 
	tb_n_rst = 1'b0;
	tb_data = 8'b11111111;
	#1;@(negedge tb_clk);
	tb_n_rst = 1'b1;
	tb_full = 1;
	#1;@(negedge tb_clk);
	tb_full = 0;
	#1;@(negedge tb_clk);
	for(i=0; i<16; i++) begin
	   @(negedge tb_clk);
	end
	#1;@(negedge tb_clk);
	#1;@(negedge tb_clk);
	#1;@(negedge tb_clk);
	#1;@(negedge tb_clk);
	#1;@(negedge tb_clk);
     end // initial begin
endmodule // tb_edge_detect

