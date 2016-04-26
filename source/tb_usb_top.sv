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
reg tb_load_enable, tb_data_out, tb_eop;

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

usb_top top_level_DUT(.clk(tb_clk), .n_rst(tb_n_rst), .d_plus_in(tb_d_plus_in), .d_minus_in(tb_d_minus_in), .in_pwr(tb_in_pwr), .in_gnd(tb_in_gnd), .d_plus_out(tb_d_plus_out), .d_minus_out(tb_d_minus_out), .out_pwr(tb_out_pwr), .out_gnd(tb_out_gnd));

transmit_shift tb_transmit_shift(.clk(tb_clk), .n_rst(tb_n_rst), .load_enable(tb_load_enable), .data(tb_data), .data_out(tb_data_out));

transmit tb_transmit(.clk(tb_clk), .n_rst(tb_n_rst), .eop(tb_eop), .data(tb_data_out), .d_plus(tb_d_plus_in), .d_minus(tb_d_minus_in));

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
	tb_load_enable = 0;
	@(negedge tb_clk);
	tb_n_rst = 0;
	@(negedge tb_clk);
	tb_n_rst = 1;
end

always @(posedge tb_clk) begin
	if (tb_n_rst) begin
		scan_file = $fscanf(data_file, "%c", captured_data);
		if (!$feof(data_file)) begin
			// use captured_data as a reg
			//gets 1 character per clock cycle
			tb_data = captured_data;
			tb_load_enable = 1;
			@(posedge tb_clk)
			tb_load_enable = 0;
			repeat (8) begin
				@(posedge tb_clk);
			end
		end
	end
end
// END FILE I/O

endmodule
