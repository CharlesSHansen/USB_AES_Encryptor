// $Id: $
// File name:   KeyExpansion.sv
// Created:     4/25/2016
// Author:      Alexander Dunker
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Key expansion test.

module KeyExpansion (
		     input 	     clk,
		     input [0:127]   key, 
		     output [0:1407] schedule );
   
   // Round constant table, derived from Rijndael documentation
   const byte 			     unsigned Rcon [0:9] = '{ 8'h01,8'h02,8'h04,8'h08,8'h10,8'h20,8'h40,8'h80,8'h1b,8'h36 };
   
   // The 10 round keys that will be used
   logic [0:127] 		     key0, key1, key2, key3, key4, key5, key6, key7, key8, key9;
   
   // First key is just the original key
   assign schedule[0:127] = key;
   
   // Perform the expansions of the keys, based on the g function to make
   // each subsequent key
   aes_g_function key_0 (.clk(clk), .key_in(key), .key_out(key0), .Rcon(Rcon[0]));
   aes_g_function key_1 (.clk(clk), .key_in(key0), .key_out(key1), .Rcon(Rcon[1]));
   aes_g_function key_2 (.clk(clk), .key_in(key1), .key_out(key2), .Rcon(Rcon[2]));
   aes_g_function key_3 (.clk(clk), .key_in(key2), .key_out(key3), .Rcon(Rcon[3]));
   aes_g_function key_4 (.clk(clk), .key_in(key3), .key_out(key4), .Rcon(Rcon[4]));
   aes_g_function key_5 (.clk(clk), .key_in(key4), .key_out(key5), .Rcon(Rcon[5]));	
   aes_g_function key_6 (.clk(clk), .key_in(key5), .key_out(key6), .Rcon(Rcon[6]));
   aes_g_function key_7 (.clk(clk), .key_in(key6), .key_out(key7), .Rcon(Rcon[7]));
   aes_g_function key_8 (.clk(clk), .key_in(key7), .key_out(key8), .Rcon(Rcon[8]));
   aes_g_function key_9 (.clk(clk), .key_in(key8), .key_out(key9), .Rcon(Rcon[9]));
   
   assign schedule[128:1407] = {key0, key1, key2, key3, key4, key5, key6, key7, key8, key9};
endmodule