// $Id: $
// File name:   mixColumns.sv
// Created:     4/24/2016
// Author:      Mitchel Bouma
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: mix columns block

module mixColumns(input logic [0:127] inData, output logic [0:127] outData);

logic [0:31] temp1, temp2, temp3, temp4;
logic [0:7] S0x2_1, S1x2_1, S2x2_1, S3x2_1, S0x3_1, S1x3_1, S2x3_1, S3x3_1;
logic [0:7] S0x2_2, S1x2_2, S2x2_2, S3x2_2, S0x3_2, S1x3_2, S2x3_2, S3x3_2;
logic [0:7] S0x2_3, S1x2_3, S2x2_3, S3x2_3, S0x3_3, S1x3_3, S2x3_3, S3x3_3;
logic [0:7] S0x2_4, S1x2_4, S2x2_4, S3x2_4, S0x3_4, S1x3_4, S2x3_4, S3x3_4;
logic [0:31] input1 = inData[0:31];
logic [0:31] input2 = inData[32:63];
logic [0:31] input3 = inData[64:95];
logic [0:31] input4 = inData[96:127];

always_comb begin

	//column 1
	S0x2_1={input1[1:7],1'b0}^(8'h1b&{8{input1[0]}});
	S1x2_1={input1[9:15],1'b0}^(8'h1b&{8{input1[8]}});
	S2x2_1={input1[17:23],1'b0}^(8'h1b&{8{input1[16]}}); 
	S3x2_1={input1[25:31],1'b0}^(8'h1b&{8{input1[24]}});

	S0x3_1={input1[1:7],1'b0}^(8'h1b&{8{input1[0]}})^{input1[0:7]};
	S1x3_1={input1[9:15],1'b0}^(8'h1b&{8{input1[8]}})^{input1[8:15]}; 
	S2x3_1={input1[17:23],1'b0}^(8'h1b&{8{input1[16]}})^{input1[16:23]}; 
	S3x3_1={input1[25:31],1'b0}^(8'h1b&{8{input1[24]}})^{input1[24:31]}; 

	temp1[0:7] = S0x2_1 ^ S1x3_1 ^ input1[16:23] ^ input1[24:31];    
	temp1[8:15] = input1[0:7] ^ S1x2_1 ^ S2x3_1 ^ input1[24:31];
	temp1[16:23] = input1[0:7] ^ input1[8:15] ^ S2x2_1 ^ S3x3_1;	
	temp1[24:31] = S0x3_1 ^ input1[8:15] ^ input1[16:23] ^ S3x2_1;

	//column 2
	S0x2_2={input2[1:7],1'b0}^(8'h1b&{8{input2[0]}});
	S1x2_2={input2[9:15],1'b0}^(8'h1b&{8{input2[8]}});
	S2x2_2={input2[17:23],1'b0}^(8'h1b&{8{input2[16]}}); 
	S3x2_2={input2[25:31],1'b0}^(8'h1b&{8{input2[24]}});

	S0x3_2={input2[1:7],1'b0}^(8'h1b&{8{input2[0]}})^{input2[0:7]};
	S1x3_2={input2[9:15],1'b0}^(8'h1b&{8{input2[8]}})^{input2[8:15]}; 
	S2x3_2={input2[17:23],1'b0}^(8'h1b&{8{input2[16]}})^{input2[16:23]}; 
	S3x3_2={input2[25:31],1'b0}^(8'h1b&{8{input2[24]}})^{input2[24:31]}; 

	temp2[0:7] = S0x2_2 ^ S1x3_2 ^ input2[16:23] ^ input2[24:31];    
	temp2[8:15] = input2[0:7] ^ S1x2_2 ^ S2x3_2 ^ input2[24:31];
	temp2[16:23] = input2[0:7] ^ input2[8:15] ^ S2x2_2 ^ S3x3_2;	
	temp2[24:31] = S0x3_2 ^ input2[8:15] ^ input2[16:23] ^ S3x2_2;

	//column 3
	S0x2_3={input3[1:7],1'b0}^(8'h1b&{8{input3[0]}});
	S1x2_3={input3[9:15],1'b0}^(8'h1b&{8{input3[8]}});
	S2x2_3={input3[17:23],1'b0}^(8'h1b&{8{input3[16]}}); 
	S3x2_3={input3[25:31],1'b0}^(8'h1b&{8{input3[24]}});

	S0x3_3={input3[1:7],1'b0}^(8'h1b&{8{input3[0]}})^{input3[0:7]};
	S1x3_3={input3[9:15],1'b0}^(8'h1b&{8{input3[8]}})^{input3[8:15]}; 
	S2x3_3={input3[17:23],1'b0}^(8'h1b&{8{input3[16]}})^{input3[16:23]}; 
	S3x3_3={input3[25:31],1'b0}^(8'h1b&{8{input3[24]}})^{input3[24:31]}; 

	temp3[0:7] = S0x2_3 ^ S1x3_3 ^ input3[16:23] ^ input3[24:31];    
	temp3[8:15] = input3[0:7] ^ S1x2_3 ^ S2x3_3 ^ input3[24:31];
	temp3[16:23] = input3[0:7] ^ input3[8:15] ^ S2x2_3 ^ S3x3_3;	
	temp3[24:31] = S0x3_3 ^ input3[8:15] ^ input3[16:23] ^ S3x2_3;

	//column 4
	S0x2_4={input4[1:7],1'b0}^(8'h1b&{8{input4[0]}});
	S1x2_4={input4[9:15],1'b0}^(8'h1b&{8{input4[8]}});
	S2x2_4={input4[17:23],1'b0}^(8'h1b&{8{input4[16]}}); 
	S3x2_4={input4[25:31],1'b0}^(8'h1b&{8{input4[24]}});

	S0x3_4={input4[1:7],1'b0}^(8'h1b&{8{input4[0]}})^{input4[0:7]};
	S1x3_4={input4[9:15],1'b0}^(8'h1b&{8{input4[8]}})^{input4[8:15]}; 
	S2x3_4={input4[17:23],1'b0}^(8'h1b&{8{input4[16]}})^{input4[16:23]}; 
	S3x3_4={input4[25:31],1'b0}^(8'h1b&{8{input4[24]}})^{input4[24:31]}; 

	temp4[0:7] = S0x2_4 ^ S1x3_4 ^ input4[16:23] ^ input4[24:31];    
	temp4[8:15] = input4[0:7] ^ S1x2_4 ^ S2x3_4 ^ input4[24:31];
	temp4[16:23] = input4[0:7] ^ input4[8:15] ^ S2x2_4 ^ S3x3_4;	
	temp4[24:31] = S0x3_4 ^ input4[8:15] ^ input4[16:23] ^ S3x2_4;
end

assign outData[0:127] = {temp1[0:31], temp2[0:31], temp3[0:31], temp4[0:31]};
	
endmodule