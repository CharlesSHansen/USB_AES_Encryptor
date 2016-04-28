// $Id: $
// File name:   extract_fifo.sv
// Created:     4/24/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Extracts the data_fifo to a 128 bit array of wires

module extract_fifo(
		    input wire 		 clk,
		    input wire 		 n_rst,
		    input wire 		 full,
		    input wire [7:0] 	 data,
		    output logic 	 pop,
		    output logic 	 ready,
		    output logic [127:0] out
		    );

   reg [127:0] 				tmp;
   reg 					rdy;

 

    typedef enum 			bit [4:0] {IDLE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, ELEVEN, TWELVE, THIRTEEN, FOURTEEN, FIFTEEN, SIXTEEN, WAIT, READ} stateType;
    stateType state;
    stateType nstate;


    always_ff @ (posedge clk, negedge n_rst) begin
       if(n_rst == 1'b0) begin
	  ready <= 0;
	  out <= '0;
	 state <= IDLE;
      end
      else begin
	 ready <= rdy;
	 out <= tmp;
	 state <= nstate;
      end
   end

   always_comb begin
      case(state)
	IDLE : begin
	   tmp = '0;
	   rdy = 0;
	   pop = 0;
	   if(full == 1'b1) begin
	      pop = 1;
	      tmp[127:120] = data;
	      nstate = TWO;
	   end
	   else
	     nstate = IDLE;
	end

	TWO : begin
	   tmp[119:112] = data;
	   nstate = THREE;
	end
	THREE : begin
	   tmp[111:104] = data;
	   nstate = FOUR;
	end
	FOUR : begin
	   tmp[103:96] = data;
	   nstate = FIVE;
	end
	FIVE : begin
	   tmp[95:88] = data;
	   nstate = SIX;
	end
	SIX : begin
	   tmp[87:80] = data;
	   nstate = SEVEN;
	end
	SEVEN : begin
	   tmp[79:72] = data;
	   nstate = EIGHT;
	end
	EIGHT : begin
	   tmp[71:64] = data;
	   nstate = NINE;
	end
	NINE : begin
	   tmp[63:56] = data;
	   nstate = TEN;
	end
	TEN : begin
	   tmp[55:48] = data;
	   nstate = ELEVEN;
	end
	ELEVEN : begin
	   tmp[47:40] = data;
	   nstate = TWELVE;
	end
	TWELVE : begin
	   tmp[39:32] = data;
	   nstate = THIRTEEN;
	end
	THIRTEEN : begin
	   tmp[31:24] = data;
	   nstate = FOURTEEN;
	end
	FOURTEEN : begin
	   tmp[23:16] = data;
	   nstate = FIFTEEN;
	end
	FIFTEEN : begin
	   tmp[15:8] = data;
	   nstate = SIXTEEN;
	end
	SIXTEEN : begin
	   tmp[7:0] = data;
	   nstate = WAIT;
	   rdy = 1;
	   pop = 1;
	end
	WAIT : begin
	   nstate = IDLE;
	   pop = 0;
	end
      endcase // case (state)
   end // always_comb

endmodule    
