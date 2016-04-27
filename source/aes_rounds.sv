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
   logic [0:127]  sub1, sub2, sub3, sub4, sub5, sub6, sub7, sub8, sub9, sub10;
   logic [0:127]  shift1, shift2, shift3, shift4, shift5, shift6, shift7, shift8, shift9, shift10;
   logic [0:127]  mix1, mix2, mix3, mix4, mix5, mix6, mix7, mix8, mix9;
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
   addRoundKey add_1 (.inData(mix1), .roundKey(roundkey1), .outData(add1));

   // Round 2
   subBytes sub_2 (.inData(add1), .outData(sub2));
   shiftRows shift_2 (.inData(sub2), .outData(shift2));
   mixColumns mix_2 (.inData(shift2), .outData(mix2));
   addRoundKey add_2 (.inData(mix2), .roundKey(roundkey2), .outData(add2));

   // Round 3
   subBytes sub_3 (.inData(add2), .outData(sub3));
   shiftRows shift_3 (.inData(sub3), .outData(shift3));
   mixColumns mix_3 (.inData(shift3), .outData(mix3));
   addRoundKey add_3 (.inData(mix3), .roundKey(roundkey3), .outData(add3));

   // Round 4
   subBytes sub_4 (.inData(add3), .outData(sub4));
   shiftRows shift_4 (.inData(sub4), .outData(shift4));
   mixColumns mix_4 (.inData(shift4), .outData(mix4));
   addRoundKey add_4 (.inData(mix4), .roundKey(roundkey4), .outData(add4));

   // Round 5
   subBytes sub_5 (.inData(add4), .outData(sub5));
   shiftRows shift_5 (.inData(sub5), .outData(shift5));
   mixColumns mix_5 (.inData(shift5), .outData(mix5));
   addRoundKey add_5 (.inData(mix5), .roundKey(roundkey5), .outData(add5));

   // Round 6
   subBytes sub_6 (.inData(add5), .outData(sub6));
   shiftRows shift_6 (.inData(sub6), .outData(shift6));
   mixColumns mix_6 (.inData(shift6), .outData(mix6));
   addRoundKey add_6 (.inData(mix6), .roundKey(roundkey6), .outData(add6));

   // Round 7
   subBytes sub_7 (.inData(add6), .outData(sub7));
   shiftRows shift_7 (.inData(sub7), .outData(shift7));
   mixColumns mix_7 (.inData(shift7), .outData(mix7));
   addRoundKey add_7 (.inData(mix7), .roundKey(roundkey7), .outData(add7));

   // Round 8
   subBytes sub_8 (.inData(add7), .outData(sub8));
   shiftRows shift_8 (.inData(sub8), .outData(shift8));
   mixColumns mix_8 (.inData(shift8), .outData(mix8));
   addRoundKey add_8 (.inData(mix8), .roundKey(roundkey8), .outData(add8));

   // Round 9
   subBytes sub_9 (.inData(add8), .outData(sub9));
   shiftRows shift_9 (.inData(sub9), .outData(shift9));
   mixColumns mix_9 (.inData(shift9), .outData(mix9));
   addRoundKey add_9 (.inData(mix9), .roundKey(roundkey9), .outData(add9));

   // Round 10
   subBytes sub_10 (.inData(add9), .outData(sub10));
   shiftRows shift_10 (.inData(sub10), .outData(shift10));
   addRoundKey add_10 (.inData(shift10), .roundKey(roundkey10), .outData(round_out));
    
   
endmodule // aes_rounds