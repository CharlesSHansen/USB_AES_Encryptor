// $Id: $
// File name:   timer.sv
// Created:     3/1/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Tiemr for Lab 6

module timer(
	     input wire  clk,
	     input wire  n_rst,
	     input wire  d_edge,
	     input wire  rcving,
	     output logic shift_enable,
	     output logic byte_recieved
	     );

   reg 			 temp1, temp2, temp3;
   reg [3:0] 		 count_to_three;
   
   flex_counter #(4) one(
			 .clk(clk),
			 .n_rst(n_rst),
			 .clr(~rcving || d_edge),
			 .count_enable(rcving),
			 .rollover_val(4'd8),
			 .count_out(count_to_three)
			 );
   
   flex_counter #(4) two(
			 .clk(clk),
			 .n_rst(n_rst),
			 .clr(~rcving),
			 .rollover_val(4'd8),
			 .count_enable(shift_enable),
			 .rollover_flag(temp1)
			 );

   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 0) begin
	 temp2 <= 0;
	 temp3 <= 0;
      end
      else begin
	 temp2 <= temp3;
	 temp3 <= temp1;
      end
      
   end // always_ff @
   assign byte_recieved = (temp2 == 0 && temp3 == 1);
   assign shift_enable = (count_to_three == 3);
   
endmodule   
