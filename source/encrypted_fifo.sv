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
   reg [127:0] 				 data;
      
   
   flex_fifo #(8,16,4) CALL(
			    .clk(clk),
			    .n_rst(n_rst),
			    .r_enable(r_enable),
			    .w_enable(increment),
			    .w_data(w_data),
			    .r_data(r_data),
			    .empty(empty),
			    .full(full));

   typedef enum 			 bit [4:0] {IDLE, START, ONE, WAIT1, TWO, WAIT2, THREE, WAIT3, FOUR, WAIT4, FIVE, WAIT5, SIX, WAIT6, SEVEN, WAIT7, EIGHT, WAIT8, NINE, WAIT9, TEN, WAIT10, ELEVEN, WAIT11, TWELVE, WAIT12, THIRTEEN, WAIT13, FOURTEEN, READ} stateType;
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
	      data = raw_data;
	      nstate = START;
	   end
	   else begin
	      nstate = IDLE;
	      data = '0;
	   end
	end // case: IDLE

	START : begin
	   increment = 1;
	   w_data = data[127:120];
	   nstate = ONE;
	end

	ONE : begin
	   w_data = data[119:112];
	   nstate = TWO;
	end

	TWO : begin
	   w_data = data[111:104];
	   nstate = THREE;
	end

	THREE : begin
	   w_data = data[103:96];
	   nstate = FOUR;
	end
	
	FOUR : begin
	   w_data = data[95:88];
	   nstate = FIVE;
	end

	FIVE : begin
	   w_data = data[87:80];
	   nstate = SIX;
	end

	SIX : begin
	   w_data = data[71:64];
	   nstate = SEVEN;
	end

       	SEVEN : begin
	   w_data = data[63:56];
	   nstate = EIGHT;
	end
	
	EIGHT : begin
	   w_data = data[55:48];
	   nstate = NINE;
	end
	
	NINE : begin
	   w_data = data[47:40];
	   nstate = TEN;
	end

	TEN : begin
	   w_data = data[39:32];
	   nstate = ELEVEN;
	end

	ELEVEN : begin
	   w_data = data[31:24];
	   nstate = TWELVE;
	end

	TWELVE : begin
	   w_data = data[23:16];
	   nstate = THIRTEEN;
	end

	THIRTEEN : begin
	   w_data = data[15:8];
	   nstate = FOURTEEN;
	end
	
	FOURTEEN : begin
	   w_data = data[7:0];
	   nstate = READ;
	end

	READ : begin
	   nstate = IDLE;
	end
      endcase // case (state)
   end // always_comb
endmodule // encrypted_fifo
