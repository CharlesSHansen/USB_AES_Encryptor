// $Id: $
// File name:   tb_encryptor_chip.sv
// Created:     4/24/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Top Level USB

`timescale 1ns / 100ps

module tb_encryptor_chip();

encryptor_chip top_level_DUT(.clk(tb_clk), .n_rst(tb_n_rst), .d_plus_in(tb_d_plus_in), .d_minus_in(tb_d_minus_in), .in_pwr(tb_in_pwr), .in_gnd(tb_in_gnd), .d_plus_out(tb_d_plus_out), .d_minus_out(tb_d_minus_out), .out_pwr(tb_out_pwr), .out_gnd(tb_out_gnd));

endmodule
