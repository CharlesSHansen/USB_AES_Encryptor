// $Id: $
// File name:   transmit_shift.sv
// Created:     4/20/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Parallel to serial shift register for transmitting the data to the transmitter.

module transmit_shift(
		      input wire clk,
		      input wire n_rst,
		      input wire load_enable,
		      input wire [7:0] data,
		      output wire data_out		      
		      );

   reg 				  shift_enable;

   always_ff @ (posedge clk, negedge n_rst) begin
      shift_enable <= load_enable;
   end
   
   flex_pts_sr #(8,0) call(
		    .clk(clk),
		    .n_rst(n_rst),
		    .shift_enable(shift_enable),
		    .load_enable(load_enable),
		    .parallel_in(data),
		    .serial_out(data_out)
		    );

endmodule // transmit_shift
