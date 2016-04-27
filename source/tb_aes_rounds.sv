// $Id: $
// File name:   tb_aes_keySchedule.sv
// Created:     4/25/2016
// Author:      Alexander Dunker
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test bench for the key schedule.

`timescale 1ns / 10ps

module tb_aes_rounds
  ();

   localparam CLK_PERIOD = 2.5;
   localparam CHECK_DELAY = 1;

   reg tb_clk;
   logic [0:1407] tb_sched;
   logic [0:127] tb_data;
   logic [0:127] tb_round_out;
   
   aes_rounds DUT (.schedule(tb_sched), .data(tb_data), .round_out(tb_round_out));
   
   
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
        tb_sched = 1408'h2b7e151628aed2a6abf7158809cf4f3ca0fafe1788542cb123a339392a6c7605f2c295f27a96b9435935807a7359f67f3d80477d4716fe3e1e237e446d7a883bef44a541a8525b7fb671253bdb0bad00d4d1c6f87c839d87caf2b8bc11f915bc6d88a37a110b3efddbf98641ca0093fd4e54f70e5f5fc9f384a64fb24ea6dc4fead27321b58dbad2312bf5607f8d292fac7766f319fadc2128d12941575c006ed014f9a8c9ee2589e13f0cc8b6630ca6;
        tb_data = 128'h3243f6a8885a308d313198a2e0370734;
      	@(posedge tb_clk);
      	@(posedge tb_clk);
        @(posedge tb_clk);
        tb_sched = 1408'h000102030405060708090a0b0c0d0e0fd6aa74fdd2af72fadaa678f1d6ab76feb692cf0b643dbdf1be9bc5006830b3feb6ff744ed2c2c9bf6c590cbf0469bf4147f7f7bc95353e03f96c32bcfd058dfd3caaa3e8a99f9deb50f3af57adf622aa5e390f7df7a69296a7553dc10aa31f6b14f9701ae35fe28c440adf4d4ea9c02647438735a41c65b9e016baf4aebf7ad2549932d1f08557681093ed9cbe2c974e13111d7fe3944a17f307a78b4d2b30c5;
        tb_data = 128'h00112233445566778899aabbccddeeff;
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
      end
endmodule // tb_aes_keySchedule
