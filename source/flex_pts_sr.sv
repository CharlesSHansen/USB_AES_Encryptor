// $Id: $
// File name:   flex_pts_counter.sv
// Created:     2/4/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Flex Counter for Lab 3
// 

module flex_pts_sr
  #(parameter NUM_BITS = 4, parameter SHIFT_MSB = 1)
   (
    input wire 		      clk,
    input wire 		      n_rst,
    input wire 		      shift_enable,
    input wire 		      load_enable, 
    input wire [NUM_BITS-1:0] parallel_in,
    output wire 	      serial_out
    );

   reg [NUM_BITS-1:0] 	      tmp;

   always@(posedge clk, negedge n_rst) begin
      if (n_rst == 0) begin
	 tmp <= {NUM_BITS{1'b1}};
      end
      else if(load_enable == 1'b1) begin
	 tmp <= parallel_in;
      end
      else if(shift_enable == 1'b1) begin
	 
	 if(SHIFT_MSB == 1) begin //Shift Left
	    tmp <= {tmp[NUM_BITS-2:0], 1'b0};
	 end
	 else begin
	    tmp <= {1'b0, tmp[NUM_BITS-1:1]};
	 end
      end
   end // always@ (posedge clk, negedge n_rst)
   
   if(SHIFT_MSB == 1) begin
      assign serial_out = tmp[NUM_BITS-1];
   end
   else begin
      assign serial_out = tmp[0];
   end
   
endmodule
