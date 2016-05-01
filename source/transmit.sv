// $Id: $
// File name:   transmit.sv
// Created:     4/20/2016
// Author:      Charles Hansen
1;
2802;
0c// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Converts binary to NRZI Encoding


module transmit(
		input wire  clk,
		input wire  n_rst,
		input wire  data,
		input wire  ready,
		input wire  eop,
		output reg d_plus,
		output reg d_minus
		);

   reg 			    previous;

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

/*
   always_comb begin
      if(ready == 1) begin
	 d_plus = (previous != data_out) | eop;
	 d_minus = ~(previous != data_out) | eop;
      end else begin
	 d_plus = 1;
	 d_minus = 1;
      end
   end*/
endmodule // transmit
