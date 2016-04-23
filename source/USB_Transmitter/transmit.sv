// $Id: $
// File name:   transmit.sv
// Created:     4/20/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Converts binary to NRZI Encoding


module transmit(
		input wire  clk,
		input wire  n_rst,
		input wire  eop;
		input wire  data,
		output wire d_plus,
		output wire d_minus
		);

   reg 			    previous;
   reg 			    data_out;
   
   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 1'b0) begin
	 previous <= 1;
	 data_out <= 1;
      end
      else begin
	 previous <= data;
	 data_out <= previous;
      end
   end

   assign d_plus = (previous != data_out) | eop;
   assign d_minus = ~(previous != data_out) | eop;

endmodule // transmit
