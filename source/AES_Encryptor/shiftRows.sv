// $Id: $
// File name:   shiftRows.sv
// Created:     4/24/2016
// Author:      Mitchel Bouma
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: shift rows block

module shiftRows(input logic [0:127] inData, output logic [0:127] outData);

assign outData[0:7] = inData[0:7];
assign outData[8:15] = inData[40:47]; 
assign outData[16:23] = inData[80:87];
assign outData[24:31] = inData[120:127];
assign outData[32:39] = inData[32:39];
assign outData[40:47] = inData[72:79];
assign outData[48:55] = inData[112:119];
assign outData[56:63] = inData[24:31];
assign outData[64:71] = inData[64:71];
assign outData[72:79] = inData[104:111];
assign outData[80:87] = inData[16:23];
assign outData[88:95] = inData[56:63];
assign outData[96:103] = inData[96:103];
assign outData[104:111] = inData[8:15];
assign outData[112:119] = inData[48:55];
assign outData[120:127] = inData[88:95];

endmodule