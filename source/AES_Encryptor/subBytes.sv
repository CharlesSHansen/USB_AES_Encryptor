// $Id: $
// File name:   subBytes.sv
// Created:     4/24/2016
// Author:      Mitchel Bouma
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: sub bytes block

module subBytes(input logic [0:127] inData, output logic [0:127] outData);

//send in groups of 8 bits
sBox sBox1(.inData(inData[120:127]), .outData(outData[120:127]));
sBox sBox2(.inData(inData[112:119]), .outData(outData[112:119]));
sBox sBox3(.inData(inData[104:111]), .outData(outData[104:111]));
sBox sBox4(.inData(inData[96:103]), .outData(outData[96:103]));
sBox sBox5(.inData(inData[88:95]), .outData(outData[88:95]));
sBox sBox6(.inData(inData[80:87]), .outData(outData[80:87]));
sBox sBox7(.inData(inData[72:79]), .outData(outData[72:79]));
sBox sBox8(.inData(inData[64:71]), .outData(outData[64:71]));
sBox sBox9(.inData(inData[56:63]), .outData(outData[56:63]));
sBox sBox10(.inData(inData[48:55]), .outData(outData[48:55]));
sBox sBox11(.inData(inData[40:47]), .outData(outData[40:47]));
sBox sBox12(.inData(inData[32:39]), .outData(outData[32:39]));
sBox sBox13(.inData(inData[24:31]), .outData(outData[24:31]));
sBox sBox14(.inData(inData[16:23]), .outData(outData[16:23]));
sBox sBox15(.inData(inData[8:15]), .outData(outData[8:15]));
sBox sBox16(.inData(inData[0:7]), .outData(outData[0:7]));

endmodule