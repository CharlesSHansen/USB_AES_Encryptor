// $Id: $
// File name:   edge_detect.sv
// Created:     2/23/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Edge Detector Block

module edge_detect (
		    input wire clk,
		    input wire n_rst,
		    input wire d_plus,
		    output reg d_edge
		    );
   reg 				ff_1;
   always_ff @ (posedge clk, negedge n_rst) begin
      if(1'b0 == n_rst) begin
	 ff_1 <= 1;
	 d_edge <= 0;
      end
      else begin
	 ff_1 <= d_plus;
	 d_edge <= ff_1 ^ d_plus;
      end
   end

   
endmodule // edge_detect

   
	 
      
   
   
