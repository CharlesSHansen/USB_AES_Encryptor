// $Id: $
// File name:   encrypted_fifo.sv
// Created:     4/25/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: FIFO to hold Enrypted Data

module encrypted_fifo(
		      input wire 	 clk,
		      input wire 	 n_rst,
		      input wire 	 r_enable,
		      input wire 	 complete,
		      input wire [127:0] raw_data,
		      output logic [7:0] r_data, 
		      output logic 	 empty,
		      output logic 	 full
		      );

   reg 					 increment;
   reg [7:0] 				 w_data;
   
   
   flex_fifo #(8,16,4) CALL(
			    .clk(clk),
			    .n_rst(n_rst),
			    .r_enable(r_enable),
			    .w_enable(increment),
			    .w_data(w_data),
			    .r_data(r_data),
			    .empty(empty),
			    .full(full));

   typedef enum 			 bit [4:0] {IDLE, ONE, WAIT1, TWO, WAIT2, THREE, WAIT3, FOUR, WAIT4, FIVE, WAIT5, SIX, WAIT6, SEVEN, WAIT7, EIGHT, WAIT8, NINE, WAIT9, TEN, WAIT10, ELEVEN, WAIT11, TWELVE, WAIT12, THIRTEEN, WAIT13, FOURTEEN, WAIT14, READ} stateType;
   stateType state;
   stateType nstate;

   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 1'b0) begin
	 state <= IDLE;
      end
      else begin
	 state <= nstate;
      end
   end

   always_comb begin
      case(state)
	IDLE : begin
	   increment = 0;
	   w_data = '0;
	   if(complete == 1'b1) begin
	      increment = 1;
	      w_data = raw_data[7:0];
	      nstate = ONE;
	   end
	   else
	     nstate = IDLE;
	end

	ONE : begin
	   w_data = raw_data[15:8];
	   nstate = WAIT1;
	end

	WAIT1 : begin
	   nstate = TWO;
	end

	TWO : begin
	   w_data = raw_data[23:16];
	   nstate = WAIT2;
	end

	WAIT2 : begin
	   nstate = THREE;
	end

	THREE : begin
	   w_data = raw_data[31:24];
	   nstate = WAIT3;
	end
	
	WAIT3 : begin
	   nstate = FOUR;
	end
	
	FOUR : begin
	   w_data = raw_data[39:32];
	   nstate = WAIT4;
	end

	WAIT4 : begin
	   nstate = FIVE;
	end
	
	FIVE : begin
	   w_data = raw_data[47:40];
	   nstate = WAIT5;
	end

	WAIT5 : begin
	   nstate = SIX;
	end

	SIX : begin
	   w_data = raw_data[55:48];
	   nstate = WAIT6;
	end

	WAIT6 : begin
	   nstate = SEVEN;
	end

       	SEVEN : begin
	   w_data = raw_data[63:56];
	   nstate = WAIT7;
	end

	WAIT7 : begin
	   nstate = EIGHT;
	end
	
	EIGHT : begin
	   w_data = raw_data[71:64];
	   nstate = WAIT8;
	end

	WAIT8 : begin
	   w_data = raw_data[79:72];
	   nstate = NINE;
	end
	
	NINE : begin
	   w_data = raw_data[87:80];
	   nstate = WAIT9;
 	end

	WAIT9 : begin
	   nstate = TEN;
	end

	TEN : begin
	   w_data = raw_data[95:88];
	   nstate = WAIT10;
	end

	WAIT10 : begin
	   nstate = ELEVEN;
	end

	ELEVEN : begin
	   w_data = raw_data[103:96];
	   nstate = WAIT11;
	end

	WAIT11 : begin
	   nstate = TWELVE;
	end

	TWELVE : begin
	   w_data = raw_data[111:104];
	   nstate = WAIT12;
	end

	WAIT12 : begin
	   nstate = THIRTEEN;
	end

	THIRTEEN : begin
	   w_data = raw_data[119:112];
	   nstate = WAIT13;
	end

	WAIT13 : begin
	   nstate = FOURTEEN;
	end
	
	FOURTEEN : begin
	   w_data = raw_data[127:120];
	   nstate = WAIT14;
	end

	WAIT14 : begin
	   nstate = READ;
	end

	READ : begin
	   nstate = IDLE;
	end
      endcase // case (state)
   end // always_comb
endmodule // encrypted_fifo
