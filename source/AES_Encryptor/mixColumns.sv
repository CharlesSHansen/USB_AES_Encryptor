// $Id: $
// File name:   mixColumns.sv
// Created:     4/24/2016
// Author:      Mitchel Bouma
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: mix columns block

input mixColumns(input logic [0:127] inData, output logic [0:127] outData);

logic [0:31] temp1, temp2, temp3, temp4;
logic [7:0] S0x2, S1x2, S2x2, S3x2, S0x3, S1x3, S2x3, S3x3;

assign outData[0:31]= temp1
assign outData[32:63]= temp2
assign outData[64:95]= temp3
assign outData[96:127]= temp4



endmodule