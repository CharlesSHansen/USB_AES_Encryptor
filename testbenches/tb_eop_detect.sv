// $Id: $
// File name:   tb_mealy.sv
// Created:     2/10/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 
// Test Bench for Mealy Machine 1101 Detector

`timescale 1ns / 100ps

module tb_eop_detect();

   localparam CLK_PERIOD = 2.5;

   reg tb_d_plus;
   reg tb_d_minus;
   reg tb_eop;

   eop_detect dut(.d_plus(tb_d_plus), .d_minus(tb_d_minus), .eop(tb_eop));
   
   initial
     begin 

	//Test Case 1
	tb_d_plus = 0;
	tb_d_minus = 0;
	#1;
	tb_d_plus = 0;
	tb_d_minus = 1;
	#1;
	tb_d_plus = 1;
	tb_d_minus = 0;
	#1;
	tb_d_plus = 1;
	tb_d_minus = 1;
	#1;
	tb_d_plus = 0;
	tb_d_minus = 0;
	#1;
	tb_d_minus = 1;
	tb_d_plus = 1;
	#1;
	tb_d_plus = 0;
	tb_d_minus = 1;
	#1;
	tb_d_minus = 0;
	tb_d_plus = 1;
	#1;
			
     end // initial begin
endmodule // tb_mealy
