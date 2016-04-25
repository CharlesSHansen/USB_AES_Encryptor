// $Id: $
// File name:   flex_counter.sv
// Created:     2/4/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Flex Counter for Lab 3
// 

module flex_counter
  #(
    NUM_CNT_BITS=4
    )
   (
    input wire 			  clk,
    input wire 			  n_rst,
    input wire 			  clr,
    input wire 			  count_enable,
    input wire [NUM_CNT_BITS-1:0] rollover_val,
    output reg [NUM_CNT_BITS-1:0] count_out,
    output reg 			  rollover_flag
    );

   reg [NUM_CNT_BITS-1:0] 	  rollover;
   reg [NUM_CNT_BITS-1:0] 	  count;
   reg 				  curr_rollover;
   reg 				  next_rollover;

   always_ff @ (posedge clk, negedge n_rst)
     begin
	if(n_rst == 0) begin
	   curr_rollover <= 0;
	   rollover <= '0;
	end
	else begin
	   rollover <= count;
	   curr_rollover <= next_rollover;
	end
     end
   always_comb
     begin
	if(clr == 1)
	  begin
	     count = '0;
	     next_rollover = '0;
	  end
	else
	  begin
	     if(count_enable == 1)
	       begin
		  count = rollover + 1;
		  next_rollover = 0;
		  if(count == (rollover_val + 1)) begin
		     count = 1;
		  end
		  if(count == rollover_val)
		    next_rollover = 1'b1;
	       end
	     else
	       begin
		  next_rollover = curr_rollover;
		  count = rollover;
	       end // else: !if(count_enable == 1)
	  end // else: !if(clr == 1)
     end // always_comb begin
   assign count_out = rollover;
   assign rollover_flag = curr_rollover;
      
endmodule // flex_pts_sr
