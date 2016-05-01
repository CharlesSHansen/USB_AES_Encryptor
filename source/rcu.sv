// $Id: $
// File name:   rcu.sv
// Created:     3/1/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: RCU Controller for USB Reciever

module rcu(
	   input wire 	    clk,
	   input wire 	    n_rst,
	   input wire 	    d_edge,
	   input wire 	    eop,
	   input wire 	    shift_enable,
	   input wire [7:0] rcv_data,
	   input wire 	    byte_recieved,
	   output logic     rcving,
	   output logic     w_enable,
	   output logic     r_error
	   );

   typedef enum 	    bit [3:0] {IDLE, RECIEVE, CHECK, CONT_RECIEVE, ENDOFBYTE, CHECK_SHIFT, RCVING_END, MERROR, DUMMY1, DUMMY2, DISREGARD} stateType;
   stateType state;
   stateType nstate;

   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 1'b0)
	state <= IDLE;
      else
	state <= nstate;
   end // always_ff @
   
   always_comb begin
      nstate = state;
      rcving = 0;
      w_enable = 0;
      r_error = 0;
      
      begin : RCU
	 case(state)
	   IDLE : begin
	      rcving = 0;
	      r_error = 0;
	      w_enable = 0;
	      if(d_edge == 1)
		nstate = RECIEVE;
	      else
		nstate = IDLE;
	   end // case: IDLE
	   
	   
	   RECIEVE : begin
	      rcving = 1;
	      r_error = 0;
	      w_enable = 0;
	      if(byte_recieved == 1)
		nstate = CHECK;
	      else
		nstate = RECIEVE;
	   end // case: RECIEVE
	   

	   CHECK : begin
	      rcving = 1;
	      r_error = 0;
	      w_enable = 0;
	      if(rcv_data == 8'b01111111)
		nstate = CONT_RECIEVE;
	      else
		nstate = DISREGARD;
	   end // case: CHECK
	   

	   CONT_RECIEVE : begin
	      rcving = 1;
	      w_enable = 0;
	      r_error = 0;
	      if(eop == 1 && shift_enable == 1)
		nstate = MERROR;
	      else if(byte_recieved == 1)
		nstate = ENDOFBYTE;
	      else
		nstate = CONT_RECIEVE;
	   end // case: CONT_RECIEVE
	   

	   ENDOFBYTE : begin
	      rcving = 1;
	      w_enable = 1;
	      r_error = 0;
	      nstate = CHECK_SHIFT;
	   end // case: ENDOFBYTE
	   
	   

	   CHECK_SHIFT : begin
	      rcving = 1;
	      w_enable = 0;
	      r_error = 0;
	      if(shift_enable == 1) begin
		 if(eop == 0)
		   nstate = CONT_RECIEVE;
		 else
		   nstate = RCVING_END;
	      end // if (shift_enable == 1)
	   end // case: CHECK_SHIFT
	   

	   RCVING_END : begin
	      rcving = 0;
	      if(d_edge == 1'b1)
		nstate = IDLE;
	   end // case: RCVING_END
	   
	   
	   MERROR : begin
	      rcving = 1;
	      r_error = 1;
	      if(eop == 1 && shift_enable == 1)
		nstate = DUMMY1;
	      else
		nstate = MERROR;
	   end // case: MERROR

	   DUMMY1 : begin
	      r_error = 1;
	      rcving = 0;
	      w_enable = 0;
	      if(d_edge == 1)
		nstate = DUMMY2;
	      else
		nstate = DUMMY1;
	   end // case: DUMMY1

	   DUMMY2 : begin
	      r_error = 1;
	      rcving = 0;
	      w_enable = 0;
	      if(d_edge == 1)
		nstate = RECIEVE;
	      else
		nstate = DUMMY2;
	   end // case: DUMMY2
	   	   	   
	   DISREGARD : begin
	      r_error = 1;
	      rcving = 1;
	      if(eop == 1 && shift_enable == 1)
		nstate = DUMMY1;
	      else
		nstate = DISREGARD;
	   end // case: DISREGARD
	 endcase // case (state)
      end // block: RCU
   end // always_comb

endmodule // rcu


