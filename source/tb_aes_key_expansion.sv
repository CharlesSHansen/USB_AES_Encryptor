// $Id: $
// File name:   tb_aes_rounds.sv
// Created:     4/26/2016
// Author:      Alexander Dunker
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test bench for testing the rounds of AES.

`timescale 1ns / 10ps

module tb_aes_key_expansion
  ();

   localparam CLK_PERIOD = 2.5;
   localparam CHECK_DELAY = 1;

   reg tb_clk;
   logic [0:127] tb_key;
   logic [0:1407] tb_sched;
   
   KeyExpansion DUT (.clk(tb_clk), .key(tb_key), .schedule(tb_sched));
   
   
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
  tb_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
  @(posedge tb_clk);
  @(posedge tb_clk);     
     end
endmodule