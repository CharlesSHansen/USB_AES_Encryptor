// $Id: $
// File name:   flex_fifo.sv
// Created:     4/21/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Flex Fifo for basis of Packet-Holding


module flex_fifo
  #(parameter NUMBITS = 8, parameter STACKSIZE = 64, parameter STACKCNT = 6)
   (
    input wire 		      clk,
    input wire 		      n_rst,
    input wire 		      r_enable,
    input wire 		      w_enable,
    input wire [NUMBITS-1:0]  w_data,
    output wire [NUMBITS-1:0] r_data,
    output reg 		      empty,
    output reg 		      full
    );
   
   reg [STACKSIZE-1:0][NUMBITS-1:0] memory;
   reg [STACKSIZE-1:0][NUMBITS-1:0] nxt_memory;
   reg [STACKCNT-1:0] 		    write_point;
   reg [STACKCNT-1:0] 		    read_point;
   reg 				    not_used, not_used2;
   wire 			    w_not_used;

   localparam count_to = STACKSIZE-1;
      
   
   genvar 			    index;
   
   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 1'b0) begin
	 memory <= 0;
      end else begin
	 memory <= nxt_memory;
      end
   end
   
   flex_full_counter #(STACKCNT) WRITE (.clk(clk), .n_rst(n_rst), .clr(not_used), .count_enable(w_enable), .rollover_val(count_to[STACKCNT-1:0]+1'b1), .count_out(write_point), .rollover_flag(w_not_used));
   flex_full_counter #(STACKCNT) READ (.clk(clk), .n_rst(n_rst), .clr(not_used), .count_enable(r_enable), .rollover_val(count_to[STACKCNT-1:0]+1'b1), .count_out(read_point), .rollover_flag(w_not_used));

   generate
      for(index = 0; index < STACKSIZE; index = index + 1) begin
	 always_comb begin
	    if(write_point == index && w_enable && full == 0)
	      nxt_memory[index] = w_data;
	    else
	      nxt_memory[index] = memory[index];
	 end
      end
   endgenerate
   
   always_comb begin
      if(write_point == read_point) 
	empty = 1;
      else
	empty = 0;
      
      if((write_point) % STACKSIZE == read_point - 1)
	full = 1;
      else
	full = 0;
   end // always_comb
   
   assign r_data = memory[read_point];
   
endmodule // flex_fifo
