// $Id: $
// File name:   decoder.sv
// Created:     2/23/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Decodes the NRZ ecoded incoming data


module decode(
	      input wire clk,
	      input wire n_rst,
	      input wire d_plus,
	      input wire shift_enable,
	      input wire eop,
	      output reg d_orig
	      );

   reg 			 xout;
   reg 			 endmux;
   reg 			 endout;


   /*
    always_ff block acomplishes two purposes:
    1) Allow for asynchrounous reset of data
    2) Hold on to previous signal for comparison to current value.  USB1.1 Utilizes NRZI Encoding which requires comparison to the previous signal.  If the previous signal is the same as the current signal, the encoded information is 0, in the opposite case it is 1.  
    */
   always_ff @ (posedge clk, negedge n_rst) begin
	if(n_rst == 1'b0) begin
	   endout <= 1;
	   endmux <= 1;
	end
	else begin
	   endmux <= d_plus;
	   endout <= xout;
	end
   end

   /*
    Set xout to be the read-in information sent on d_plus if the end of packet has not been reached.  If it has been, the signal is sent to high to allow for end of packet manipulation.  If shift_enable is not enabled, the output information is set to be the previous signal sent: High for both d_plus and d_minus.    
    */
   
   always_comb begin
      if(shift_enable == 1'b1 && eop == 1'b0)
	xout = d_plus;
      else if(shift_enable == 1'b1 && eop == 1'b1)
	xout = 1;
      else
	xout = endout;
   end // always_comb

   //If the previous signal is equal to the current signal, the decoded bit is 0.  If it is different, the bit is 1
   assign d_orig = endout != endmux;
         
endmodule // decode
   
