// $Id: $
// File name:   sync.sv
// Created:     2/16/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Synchronizer from Lab 2

module sync_high
  (
   input wire clk,
   input wire n_rst,
   input wire async_in,
   output reg sync_out
   );
   
  reg temp;

   always_ff @ (posedge clk, negedge n_rst) begin
      if(1'b0 == n_rst) begin
	 temp <= 1;
	 sync_out <= 1;
      end
      else begin
	 temp <= async_in;
	 sync_out <= temp;
      end
   end

endmodule
