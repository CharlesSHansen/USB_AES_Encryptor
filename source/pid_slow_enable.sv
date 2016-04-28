// $Id: $
// File name:   pid_slow_enable.sv
// Created:     4/28/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Fast PID enable for TRCU

module pid_slow_enable(
		       input wire clk,
		       input wire n_rst,
		       input wire slow_enable,
		       output reg fast_enable
		       );

   flex_slow PID_SLOW(.clk(clk), .n_rst(n_rst), .slow_enable(slow_enable), .fast_enable(fast_enable));

endmodule    
