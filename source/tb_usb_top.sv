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
reg [127:0] full_data_out;
reg complete;
reg last_sync;

//Token Packets
localparam [3:0] 			    token1 = 4'b0001;
localparam [3:0] 			    token2 = 4'b1001;
localparam [3:0] 			    token3 = 4'b0101;
localparam [3:0] 			    token4 = 4'b1101;

//Data Packets
localparam [3:0] 			    data1 = 4'b0011;
localparam [3:0] 			    data2 = 4'b1011;
localparam [3:0] 			    data3 = 4'b0111;
localparam [3:0] 			    data4 = 4'b1111;

//Handshake Packets
localparam [3:0] 			    hand1 = 4'b0010;
localparam [3:0] 			    hand2 = 4'b1010;
localparam [3:0] 			    hand3 = 4'b1110;

//EOF Packet
localparam [3:0] 			    eof = 4'b0110;

//Start of Frame Packet
localparam [3:0] 			    spec1 = 4'b1100;
localparam [3:0] 			    spec2 = 4'b1100;
localparam [3:0] 			    spec3 = 4'b1000;
localparam [3:0] 			    spec4 = 4'b0100;

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

usb_top top_level_DUT(.clk(tb_clk), .n_rst(tb_n_rst), .d_plus_in(tb_d_plus_in), .d_minus_in(tb_d_minus_in), .in_pwr(tb_in_pwr), .in_gnd(tb_in_gnd), .d_plus_out(tb_d_plus_out), .d_minus_out(tb_d_minus_out), .out_pwr(tb_out_pwr), .out_gnd(tb_out_gnd), .data_out(full_data_out), .complete(complete));

transmit_shift tb_transmit_shift(.clk(slow_clk), .n_rst(tb_n_rst), .load_enable(tb_load_enable), .data(tb_data), .eop(tb_eop), .data_out(tb_data_out), .ready(tb_ready));

transmit tb_transmit(.clk(slow_clk), .n_rst(tb_n_rst), .data(tb_data_out), .ready(tb_ready), .eop(tb_eop), .d_plus(tb_d_plus_in), .d_minus(tb_d_minus_in));

// BEGIN FILE INPUTTING
integer data_file;
integer scan_file;
integer output_file;
logic unsigned [7:0] captured_data; //one character at a time
`define NULL 0

initial begin
	data_file = $fopen("./source/usb_data.dat", "r");
	if (data_file == `NULL) begin
		$display("ERROR: Couldn't open input data file.");
		$finish;
	end
	output_file = $fopen("./source/encrypted_data.txt", "w");
	if (output_file == `NULL) begin
		$display("ERROR: Couldn't open output data file.");
		$finish;
	end
	tb_n_rst = 1;
	@(posedge tb_clk)
	tb_load_enable = 0;
	tb_n_rst = 0;
	tb_eop = 0;
	tb_packet_counter = 3'b000;
	last_sync = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;
end

always @(posedge slow_clk) begin
	if (tb_n_rst) begin
		if (tb_packet_counter != 3'b101)
			scan_file = $fscanf(data_file, "%c", captured_data);
		if (!$feof(data_file)) begin
			//use captured_data as a reg
			//gets 1 character per 8 slow clock cycles (tb_clk/8)
			if (captured_data == 8'b01111111) begin
				last_sync = 1;
			end else begin
				if (last_sync == 1) begin
					if ((captured_data[7:4] == data1) || (captured_data[7:4] == data2) || (captured_data[7:4] == data3) || (captured_data[7:4] == data4))
						tb_packet_counter = 3'b001; // (sync -> PID -> data -> CRC -> CRC -> eop)
					if((captured_data[7:4] == token1) || (captured_data[7:4] == token2) || (captured_data[7:4] == token3) || (captured_data[7:4] == token4))
						tb_packet_counter = 3'b010; // (sync -> PID -> byte -> byte)
					if((captured_data[7:4] == hand1) || (captured_data[7:4] == hand2) || (captured_data[7:4] == hand3) || (captured_data[7:4] == eof))
						tb_packet_counter = 3'b100; // (sync -> PID -> eop)
					if((captured_data[7:4] == spec1) || (captured_data[7:4] == spec2) || (captured_data[7:4] == spec3) || (captured_data[7:4] == spec4))
						tb_packet_counter = 3'b010; // (sync -> PID -> byte -> byte)
					last_sync = 0;
				end
			end
			tb_packet_counter = tb_packet_counter+1;
			if (tb_packet_counter == 3'b110) begin
				// BEGIN DATA EOP TIMER
				tb_eop = 1;
				tb_packet_counter = 3'b000;
				tb_data = 8'b11111111; //waiting for data
				@(posedge slow_clk); //hold EOP for 3 slow clock cycles
				tb_load_enable = 0;
				@(posedge slow_clk);
				@(posedge slow_clk);
				tb_eop = 0;
				@(posedge slow_clk); //just enough delay for the RCU to be ready for another packet
				// END DATA EOP TIMER
			end else begin
				tb_eop = 0;
				tb_data = captured_data;
				tb_load_enable = 1;
				@(posedge slow_clk);
				tb_load_enable = 0;
				@(posedge slow_clk);
				//2 cycle delay for transmit D+ & D- to begin following input data
				repeat (8) begin //8 bits @ 8 cycles each (slow_clk) for a readable speed for the RCU
					@(posedge slow_clk);
				end
			end
		end
	end
end
// END FILE INPUTTING

// BEGIN ENCRYPTED DATA OUTPUTTING
always @(posedge tb_clk) begin
	if (complete) begin
		$fwrite(output_file, "%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x", full_data_out[127:120], full_data_out[119:112], full_data_out[111:104], full_data_out[103:96], full_data_out[95:88], full_data_out[87:80], full_data_out[79:72], full_data_out[71:64], full_data_out[63:56], full_data_out[55:48], full_data_out[47:40], full_data_out[39:32], full_data_out[31:24], full_data_out[23:16], full_data_out[15:8], full_data_out[7:0]);
	end
end
// END ENCRYPTED FILE OUTPUTTING

endmodule
