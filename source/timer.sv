// $Id: $
// File name:   timer.sv
// Created:     3/1/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Tiemr for Lab 6
module timer
(
	input wire clk,
	input wire n_rst,
	input wire d_edge,
	input wire rcving,
	output wire shift_enable,
	output wire byte_recieved
);

logic [3:0] buffer;
logic garbage1;
logic [3:0] garbage2;

// START 3 CYCLE DELAY ON NEW BYTE (byte_received == 1)
logic [4:0] delay_counter;
logic delay;
always @(posedge clk, negedge n_rst) begin
	if (!n_rst) begin
		delay_counter <= 5'b00000;
		delay = 1;
	end else begin
		if (delay_counter == 5'b11000) begin
			delay = 1;
			delay_counter <= 5'b00000;
		end else if (byte_recieved == 1) begin
			delay = 0;
		end else if (delay == 0) begin
			delay_counter <= delay_counter+1;
		end
	end
end
// END DELAY

flex_counter #(4) COUNTER1
(
	.clk(clk),
	.n_rst(n_rst),
	.clr(d_edge || ~rcving),
	.count_enable(rcving && delay),
	.rollover_val(4'd8),
	.count_out(buffer),
	.rollover_flag(garbage1)
);

assign shift_enable = (buffer == 4'd3);

flex_counter #(4) COUNTER2
(
	.clk(clk),
	.n_rst(n_rst),
	.clr(~rcving || byte_recieved),
	.count_enable(shift_enable),
	.rollover_val(4'd8),
	.count_out(garbage2),
	.rollover_flag(byte_recieved)
);

endmodule
