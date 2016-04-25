// $Id: $
// File name:   tb_usb.sv
// Created:     4/24/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Top Level USB

`timescalse 1ns / 100ps

  module tb_usb();

   reg tb_clk;
   reg tb_n_rst;
   reg tb_d_plus;
   reg tb_d_minus;
   
