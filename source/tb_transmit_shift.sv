// $Id: $
// File name:   tb_transmit_shift.sv
// Created:     4/26/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test bench for transmit_shift.sv

`timescale 1ns / 100ps

  module tb_transmit_shift();


   localparam CLK_PERIOD = 10;

   reg clk;
   reg n_rst;
   reg load_enable;
   reg [7:0] data;
   reg 	     data_out;
   reg 	     eop;
   
   transmit_shift CALL(.clk(clk), .n_rst(n_rst), .load_enable(load_enable), .data(data), .eop(eop), .data_out(data_out));

   always begin : CLK_GEN
      clk = 1'b0;
      #(CLK_PERIOD/2);
      clk = 1'b1;
      #(CLK_PERIOD/2);
   end

   initial
     begin
	n_rst = 0;
	load_enable = 0;
	eop = 0;
	data = 8'b10110010;
	#1;@(negedge clk);
	n_rst = 1;
	#1;@(negedge clk);
	load_enable = 1;
	#1;@(negedge clk);
	load_enable = 0;
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	data = 8'b01001101 ;
	load_enable = 1;
	#1;@(negedge clk);
	load_enable = 0;
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	eop = 0;
	#1;@(negedge clk);
	#1;@(negedge clk);
     end // initial begin
endmodule
   

	
	
	
	
