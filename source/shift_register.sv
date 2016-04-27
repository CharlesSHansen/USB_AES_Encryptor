// $Id: $
// File name:   shift_register.sv
// Created:     3/1/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Shift Register for USB

module shift_register(
		       input wire clk,
		       input wire n_rst,
		       input wire shift_enable,
		       input wire d_orig,
		       output wire [7:0] rcv_data
		      );

   flex_stp_sr #(8, 1) call(
		    .clk(clk),
		    .n_rst(n_rst),
		    .shift_enable(shift_enable),
		    .serial_in(d_orig),
		    .parallel_out(rcv_data)
			    );
   
endmodule // shift_register
