// $Id: $
// File name:   flex_slow.sv
// Created:     4/28/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Flex Slow for reducing enable by 8


module flex_slow(
		 input wire clk,
		 input wire n_rst,
		 input wire slow_enable,
		 output reg fast_enable
		 );

   reg 			     previous_enable;
   
   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 1'b0) begin
	 previous_enable <= 1;
	 fast_enable <= 0;
      end
      else begin
	 previous_enable <= slow_enable;
	 fast_enable <= (previous_enable ^ slow_enable) && slow_enable == 1;
      end
   end
   
endmodule
