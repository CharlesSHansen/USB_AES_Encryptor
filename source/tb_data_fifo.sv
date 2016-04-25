// $Id: $
// File name:   tb_fifo.sv
// Created:     2/10/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 
// Test Bench for Mealy Machine 1101 Detector

`timescale 1ns / 100ps

module tb_data_fifo();

   localparam CLK_PERIOD = 10;

   reg tb_clk;
   reg tb_n_rst;
   reg tb_r_enable;
   reg tb_w_enable;
   reg [7:0] tb_w_data;
   reg [7:0] tb_r_data;
   reg 	     tb_empty;
   reg 	     tb_full;
   integer   i;
      
   always begin : CLK_GEN
	tb_clk = 1'b0;
	#(CLK_PERIOD/2);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2);
   end
   
   data_fifo DUT(.clk(tb_clk), .n_rst(tb_n_rst), .r_enable(tb_r_enable), .w_enable(tb_w_enable), .w_data(tb_w_data), .r_data(tb_r_data), .empty(tb_empty), .full(tb_full));
   
   initial
     begin 
	tb_n_rst = 1'b0;
	tb_r_enable = 0;
	tb_w_enable = 0;
	tb_w_data = 0;
	#1;@(negedge tb_clk);
	tb_n_rst = 1'b1;
	#1;@(negedge tb_clk);
	tb_r_enable = 1;
	#1;@(negedge tb_clk);
	tb_n_rst = 1'b0;
	tb_r_enable = 1'b0;
	#1;@(negedge tb_clk);
	tb_n_rst = 1'b1;
	#1;@(negedge tb_clk);
	tb_w_data = 8'hF;
	tb_w_enable = 1;
	#1;@(negedge tb_clk);
	tb_w_data = 8'b00000000;
	#1;@(negedge tb_clk);
	tb_w_data = 8'hFFFFFFFF;
	#1;@(negedge tb_clk);
	tb_w_data = 8'b00000000;
	#1;@(negedge tb_clk);
	tb_w_enable = 0;
	#1;@(negedge tb_clk);
	tb_r_enable = 1;
	#1;@(negedge tb_clk);
	tb_r_enable = 1;
	tb_w_enable = 1;
	
	#1;@(negedge tb_clk);
	for(i=0; i<2000000; i++) begin
	   #1;
	   @(negedge tb_clk);
	   tb_w_data = tb_w_data ^ 8'b11111111;
	end
		
     end // initial begin
endmodule // tb_edge_detect

