// $Id: $
// File name:   slow_nd_enable.sv
// Created:     4/28/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Speed up enable for nd_enable signal

module slow_nd_enable(
		       input wire clk,
		       input wire n_rst,
		       input wire slow_enable,
		       output reg fast_enable
		       );

   flex_slow ND_SLOW(.clk(clk), .n_rst(n_rst), .slow_enable(slow_enable), .fast_enable(fast_enable));

endmodule    
