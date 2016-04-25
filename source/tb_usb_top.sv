// $Id: $
// File name:   tb_usb.sv
// Created:     4/24/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Top Level USB

`timescale 1ns / 100ps

module tb_usb_top();

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

// BEGIN FILE I/O
integer data_file;
integer scan_file;
logic signed [7:0] captured_data; //one character at a time
`define NULL 0

initial begin
	data_file = $fopen("./source/usb_data.dat", "r");
	if (data_file == `NULL) begin
		$display("data_file handle was NULL");
		$finish;
	end
end

always @(posedge tb_clk) begin
	scan_file = $fscanf(data_file, "%c", captured_data);
	if (!$feof(data_file)) begin
		// use captured_data as a reg
		//gets 1 character per clock cycle
	end
end
// END FILE I/O

endmodule