// $Id: $
// File name:   dcrc_fifo.sv
// Created:     4/23/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Fifo for holding crc16 padding at end of data packet

module dcrc_fifo (
		  input wire 	   clk,
		  input wire 	   n_rst,
		  input wire 	   r_enable,
		  input wire 	   w_enable,
		  input wire [7:0] w_data,
		  input wire [7:0] r_data,
		  output wire 	   empty,
		  output wire 	   full
		  );

   fifo #(4,64,8) CALL(
		       .clk(clk),
		       .n_rst(n_rst),
		       .r_enable(r_enable),
		       .w_enable(w_enable),
		       .w_data(w_data),
		       .r_data(r_data),
		       .empty(empty),
		       .full(full)
		       );
endmodule // data_fifo
