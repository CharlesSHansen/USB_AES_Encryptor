// $Id: $
// File name:   nd_fifo.sv
// Created:     4/23/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Fifo to hold non-data packets in 8 bit chunks

module nd_fifo (
		  input wire 	   clk,
		  input wire 	   n_rst,
		  input wire 	   r_enable,
		  input wire 	   w_enable,
		  input wire [7:0] w_data,
		  output wire [7:0] r_data,
		  output wire 	   empty,
		  output wire 	   full
		  );

   flex_fifo #(8,200, 8) CALL(
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
