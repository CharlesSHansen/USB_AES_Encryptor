// $Id: $
// File name:   aes_g_function.sv
// Created:     4/25/2016
// Author:      Alexander Dunker
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: G Function for aes Key expansion.

module aes_g_function
  (
   input 	  clk,
   input [0:127]  key_in,
   input [0:7] 	  Rcon,
   output [0:127] key_out 
   );
   
   // Obtain words from previous key
   logic [0:31]   wp0, wp1, wp2, wp3;
   logic [0:7] 	  wp03, wp13, wp23, wp33;
   logic [0:31]   subword;
   assign {wp0, wp1, wp2, wp3} = key_in;
   assign {wp03, wp13, wp23, wp33} = wp3;
   
   // Obtain SubWord using SubBytes
   // RotWord is implemented using rotated input
   SubBytes subbytes_0(.*, .in(wp13), .out(subword[0:7]));
   SubBytes subbytes_1(.*, .in(wp23), .out(subword[8:15]));
   SubBytes subbytes_2(.*, .in(wp33), .out(subword[16:23]));
   SubBytes subbytes_3(.*, .in(wp03), .out(subword[24:31]));
   
   logic [0:31]   w0, w1, w2, w3;
   assign w0 = wp0 ^ {subword[0:7] ^ Rcon, subword[8:31]};
   assign w1 = wp1 ^ w0;
   assign w2 = wp2 ^ w1;
   assign w3 = wp3 ^ w2;
   
   assign key_out = {w0, w1, w2, w3};
   
endmodule
