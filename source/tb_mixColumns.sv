// $Id: $
// File name:   tb_subBytes.sv
// Created:     4/25/2016
// Author:      Mitchel Bouma
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: sub bytes tester

`timescale 1ns / 100ps

module tb_mixColumns();

localparam CLK_PERIOD = 10;

logic [0:127] inData = {8'h19, 8'h3d, 8'he3, 8'hbe, 8'ha0, 8'hf4, 8'he2, 8'h2b, 8'h9a, 8'hc6, 8'h8d, 8'h2a, 8'he9, 8'hf8, 8'h48, 8'h08};
//logic [0:127] inData = {8'h04, 8'h66, 8'h81, 8'he5, 8'he0, 8'hcb, 8'h19, 8'h9a, 8'h48, 8'hf8, 8'hd3, 8'h7a, 8'h28, 8'h06, 8'h26, 8'h4c};
logic [0:127] roundKey = {8'ha0, 8'hfa, 8'hfe, 8'h17, 8'h88, 8'h54, 8'h2c, 8'hb1, 8'h23, 8'ha3, 8'h39, 8'h39, 8'h2a, 8'h6c, 8'h76, 8'h05}; 
logic [0:127] outDataSubBytes;
logic [0:127] outDataShiftRows;
logic [0:127] outDataMixColumns;
logic [0:127] outDataAddRoundKey;
logic clk;

always begin : CLK_GEN
	clk = 1'b0;
      	#(CLK_PERIOD/2);
      	clk = 1'b1;
      	#(CLK_PERIOD/2);
end

subBytes subBytes(.inData(inData), .outData(outDataSubBytes));
shiftRows shiftRows(.inData(outDataSubBytes), .outData(outDataShiftRows));
mixColumns mixColumns(.inData(outDataShiftRows), .outData(outDataMixColumns));
//addRoundKey addRoundKey(.inData(outDataMixColumns), .roundKey(roundKey), .outData(outDataAddRoundKey));

initial begin

	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);
	#1;@(negedge clk);

end

endmodule