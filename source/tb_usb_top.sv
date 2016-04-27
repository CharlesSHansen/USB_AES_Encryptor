// $Id: $
// File name:   tb_usb.sv
// Created:     4/24/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Top Level USB

`timescale 1ns / 100ps

module tb_usb_top();

reg tb_n_rst, tb_d_plus_in, tb_d_minus_in, tb_in_pwr, tb_in_gnd, tb_d_plus_out, tb_d_minus_out, tb_out_pwr, tb_out_gnd;
reg [7:0] tb_data;
reg tb_load_enable, tb_data_out, tb_eop, tb_ready;
reg [2:0] tb_packet_counter;

// BEGIN CLK GEN
reg tb_clk;
localparam CLK_PERIOD = 10;
always begin : CLK_GEN
	tb_clk = 1'b0;
	#(CLK_PERIOD/2);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2);
end
// END CLK GEN 

// GENERATE SLOW CLOCK = CLK/8
reg [1:0] counter;
reg slow_clk;
reg clk_flag;
always @(posedge tb_clk, negedge tb_n_rst) begin
	if (!tb_n_rst) begin
		clk_flag <= 0;
		counter <= 2'b00;
	end else begin
		if (counter == 2'b11) begin
			counter <= 2'b00;
			clk_flag <= clk_flag^1;
		end else begin
			counter <= counter+1;
		end
	end
end
assign slow_clk = clk_flag;
// END SLOW CLOCK GEN

usb_top top_level_DUT(.clk(tb_clk), .n_rst(tb_n_rst), .d_plus_in(tb_d_plus_in), .d_minus_in(tb_d_minus_in), .in_pwr(tb_in_pwr), .in_gnd(tb_in_gnd), .d_plus_out(tb_d_plus_out), .d_minus_out(tb_d_minus_out), .out_pwr(tb_out_pwr), .out_gnd(tb_out_gnd));

transmit_shift tb_transmit_shift(.clk(slow_clk), .n_rst(tb_n_rst), .load_enable(tb_load_enable), .data(tb_data), .eop(tb_eop), .data_out(tb_data_out), .ready(tb_ready));

transmit tb_transmit(.clk(slow_clk), .n_rst(tb_n_rst), .data(tb_data_out), .ready(tb_ready), .eop(tb_eop), .d_plus(tb_d_plus_in), .d_minus(tb_d_minus_in));

// BEGIN FILE I/O
integer data_file;
integer scan_file;
logic unsigned [7:0] captured_data; //one character at a time
`define NULL 0

initial begin
	data_file = $fopen("./source/usb_data.dat", "r");
	if (data_file == `NULL) begin
		$display("ERROR: Couldn't open input data file.");
		$finish;
	end
	tb_n_rst = 1;
	@(posedge tb_clk)
	tb_load_enable = 0;
	tb_n_rst = 0;
	tb_eop = 0;
	tb_packet_counter = 3'b000;
	@(posedge tb_clk);
	tb_n_rst = 1;
end

// BEGIN DATA EOP TIMER (count to 5 bytes) (sync -> PID -> data -> CRC -> crc)
always @(posedge slow_clk) begin
	if (tb_packet_counter == 3'b101) begin
		tb_eop = 1;
		tb_packet_counter = 3'b000;
		@(posedge slow_clk); //hold EOP for 2 slow clock cycles
	end else begin
		tb_eop = 0;
	end
end
// END DATA EOP TIMER

always @(posedge slow_clk) begin
	if (tb_n_rst) begin
		scan_file = $fscanf(data_file, "%c", captured_data);
		if (!$feof(data_file)) begin
			//use captured_data as a reg
			//gets 1 character per 8 slow clock cycles
			tb_data = captured_data;
			tb_load_enable = 1;
			@(posedge slow_clk);
			tb_load_enable = 0;
			@(posedge slow_clk);
			//2 cycle delay for transmit D+ & D- to begin following input data
			repeat (8) begin //8 bits @ 8 cycles each (slow_clk) for a readable speed for the RCU
				@(posedge slow_clk);
			end
			tb_packet_counter = tb_packet_counter+1;
		end
	end
end
// END FILE I/O

endmodule
