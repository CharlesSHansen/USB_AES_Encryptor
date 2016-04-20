// $Id: $
// File name:   decoder.sv
// Created:     2/23/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Decodes the NRZ ecoded incoming data


module decode(
	      input wire clk,
	      input wire n_rst,
	      input wire d_plus,
	      input wire shift_enable,
	      input wire eop,
	      output reg d_orig
	      );

   reg 			 xout;
   reg 			 endmux;
   reg 			 endout;


   always_ff @ (posedge clk, negedge n_rst) begin
	if(n_rst == 1'b0) begin
	   endout <= 1;
	   endmux <= 1;
	end
	else begin
	   endmux <= d_plus;
	   endout <= xout;
	end
   end

   always_comb begin
      
      if(shift_enable == 1'b1 && eop == 1'b0)
	xout = d_plus;
      else if(shift_enable == 1'b1 && eop == 1'b1)
	xout = 1;
      else
	xout = endout;
   end // always_comb
   
   
   assign d_orig = endout == endmux;
         
endmodule // decode
   
