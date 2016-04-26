// $Id: $
// File name:   addRoundKey.sv
// Created:     4/24/2016
// Author:      Mitchel Bouma
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: add round key block

input addRoundKey(input logic [0:127] inData, input logic [0:127] roundKey, output logic [0:127] outData);

assign outData[0:127] = inData[0:127]^roundKey[0:127];

endmodule