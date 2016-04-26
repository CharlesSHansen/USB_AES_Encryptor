// $Id: $
// File name:   tb_trcu.sv
// Created:     4/25/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test bench for TRCU

`timescale 1ns / 100ps

module tb_trcu();

   localparam CLK_PERIOD = 10;

   reg 	     clk;
   reg 	     n_rst;
   reg 	     encrypt_full;
   reg 	     pid_empty;
   reg 	     data_empty;
   reg [7:0] pid_read;
   reg [7:0] nd_read;
   reg [7:0] dcrc_read;
   reg [7:0] data_read;
   reg [7:0] write;
   reg 	     write_enable;
   reg 	     nd_enable;
   reg 	     eop_enable;
   reg 	     pid_enable;
   reg 	     dcrc_enable;
   reg 	     data_enable;

   always begin : CLK_GEN
      clk = 1'b0;
      #(CLK_PERIOD/2);
      clk = 1'b1;
      #(CLK_PERIOD/2);
   end

   trcu TEST(.clk(clk), .n_rst(n_rst), .encrypt_full(encrypt_full), .pid_empty(pid_empty), .data_empty(data_empty), .pid_read(pid_read), .nd_read(nd_read), .dcrc_read(dcrc_read), .data_read(data_read), .write(write), .write_enable(write_enable), .nd_enable(nd_enable), .eop_enable(eop_enable), .pid_enable(pid_enable), .dcrc_enable(dcrc_enable), .data_enable(data_enable));

   initial begin
      n_rst = 1'b0;
      encrypt_full = 0;
      pid_empty = 0;
      data_empty = 0;
      nd_read = '1;
      dcrc_read = '1;
      data_read = '1;
      pid_read = 8'b00111100;
      #1;@(negedge clk);
      n_rst = 1'b1;
      #1;@(negedge clk);
      encrypt_full = 1;
      #1;@(negedge clk);
      #1;@(negedge clk);
      encrypt_full = 0;
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
      #1;@(negedge clk);
   end // initial begin

endmodule // tb_trcu
