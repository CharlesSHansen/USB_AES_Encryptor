// $Id: $
// File name:   aes_rounds.sv
// Created:     4/26/2016
// Author:      Alexander Dunker
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: First 9 rounds of AES.

module aes_rounds
  (
   input [0:1407] schedule,
   input [0:127] data,
   output [0:127] round_out
   );
   
   logic [0:127]  roundkey0, roundkey1, roundkey2, roundkey3, roundkey4, roundkey5, 
		  roundkey6, roundkey7, roundkey8, roundkey9, roundkey10;
   logic [0:127]  sub1, sub2, sub3, sub4, sub5, sub6, sub7, sub8, sub9;
   logic [0:127]  shift1, shift2, shift3, shift4, shift5, shift6, shift7, shift8, shift9;
   logic [0:127]  mix1, mix2, mix4, mix5, mix6, mix7, mix8, mix9;
   logic [0:127]  add0, add1, add2, add3, add4, add5, add6, add7, add8, add9;
   
   assign roundkey0 = schedule[0:127];
   assign roundkey1 = schedule[127:255];
   assign roundkey2 = schedule[256:383];
   assign roundkey3 = schedule[384:511];
   assign roundkey4 = schedule[512:639];
   assign roundkey5 = schedule[640:767];
   assign roundkey6 = schedule[768:895];
   assign roundkey7 = schedule[896:1023];
   assign roundkey8 = schedule[1024:1151];
   assign roundkey9 = schedule[1152:1279];
   assign roundkey10 = schedule[1280:1407];

   // Initial round key
   addRoundKey add_0 ( .inData(data), .roundKey(roundkey0), .outData(add0));

   // Round 1
   subBytes sub_1 (.inData(add0), .outData(sub1));
   shiftRows shift_1 (.inData(sub1), .outData(shift1));
   mixColumns mix_1 (.inData(shift1), .outData(mix1));
   addRoundKey add_1 (.inData(mix1), .outData(add1));
    
   
endmodule // aes_rounds