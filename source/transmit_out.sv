// $Id: $
// File name:   transmit_out.sv
// Created:     4/27/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Transmit serial data to D+ and D- for USB Transmission

module transmit_out(
		input wire clk,
		input wire n_rst,
		input wire data,
		input wire ready,
		input wire eop,
		output reg d_plus,
		output reg d_minus
		);

   reg 			   previous;

   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 1'b0) begin
	 previous = 1;
      end
      else begin
	 previous = d_plus;
	 if(ready == 1) begin
	    if(data == 0) begin
	       d_plus = previous;
	       d_minus = ~previous;
	    end else begin
	       d_plus = ~previous;
	       d_minus = previous;
	    end
	 end
	 else if (eop) begin
	    d_plus = 0;
	    d_minus = 0;
	 end
	 else begin
	    d_plus = 1;
	    d_minus = 1;
	 end
      end // else: !if(n_rst == 1'b0)
   end // always_ff @
endmodule // transmit
