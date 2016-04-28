// $Id: $
// File name:   aes_control.sv
// Created:     4/26/2016
// Author:      Alexander Dunker
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Controller of the AES

module aes_control
	(
		input clk,
		input n_rst,
		input ready,
		input [0:127] data_in,
		output complete,
		output [0:127] data_out
	);

	logic first;
	logic first2;
	logic [0:127] key;
	logic [0:1407] schedule;
	logic comp;

	typedef enum     bit [3:0] {IDLE, START, SCHED, COMP, WAITE, WAITK} states;
	states state, nstate;

	aes_key_expansion keySched (.clk(clk), .ready(first2), .key(data_in), .schedule(schedule));
	aes_rounds rounds (.schedule(schedule), .data(data_in), .round_out(data_out));

	always_ff @ (posedge clk, negedge n_rst) begin
		if(n_rst == 0) begin
			first <= 1;
			state <= IDLE;
		end else begin
			first <= first2;
			state <= nstate;
		end
	end

	always_comb begin
		nstate = state;
		comp = 0;
		first2 = first;
		case(state)
			IDLE:
			begin
				if (ready) begin
					if (first2) begin
						nstate = SCHED;
						comp = 0;
					end else begin
						nstate = START;
						comp = 0;
					end
				end else begin
					nstate = IDLE;
				end
			end
			START:
			begin
				nstate = COMP;
				comp = 1;
			end
			SCHED:
			begin
				nstate = IDLE;
				first2 = 0;
				comp = 0;
			end
			COMP:
			begin
				nstate = IDLE;
				comp = 0;
			end
		endcase
	end

	assign complete = comp;

endmodule // end aes_control