// $Id: $
// File name:   usb_reciever.sv
// Created:     3/1/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Top level file for usb_reciever

module usb_receiver(
		    input wire 	      clk,
		    input wire 	      n_rst,
		    input wire 	      d_plus,
		    input wire 	      d_minus,
		    input wire 	      r_enable,
		    output reg [7:0] r_data,
		    output wire       empty,
		    output wire       full,
		    output wire       rcving,
		    output wire       r_error		    
		    );
   reg 				      d_plus_sync;
   reg 				      d_minus_sync;
   reg 				      eop;
   reg 				      shift_enable;
   reg 				      d_orig;
   reg 				      d_edge;
   reg 				      byte_recieved;
   reg [7:0] 			      rcv_data;
   
   
   sync_high shi(
		 .clk(clk),
		 .n_rst(n_rst),
		 .async_in(d_plus),
		 .sync_out(d_plus_sync)
		 );

   sync_low slo(
		.clk(clk),
		.n_rst(n_rst),
		.async_in(d_minus),
		.sync_out(d_minus_sync)
		);
   
   eop_detect reop(
	       .d_plus(d_plus_sync),
	       .d_minus(d_minus_sync),
	       .eop(eop)
	       );

   edge_detect edetect(
		       .clk(clk),
		       .n_rst(n_rst),
		       .d_plus(d_plus_sync),
		       .d_edge(d_edge)
		       );
   
   decode dec(
	      .clk(clk),
	      .n_rst(n_rst),
	      .d_plus(d_plus_sync),
	      .shift_enable(shift_enable),
	      .eop(eop),
	      .d_orig(d_orig)
	      );

   timer tim(
	     .clk(clk),
	     .n_rst(n_rst),
	     .d_edge(d_edge),
	     .rcving(rcving),
	     .shift_enable(shift_enable),
	     .byte_recieved(byte_recieved)
	     );

   shift_register sr(
		     .clk(clk),
		     .n_rst(n_rst),
		     .shift_enable(shift_enable),
		     .d_orig(d_orig),
		     .rcv_data(rcv_data)
		     );

   rx_fifo fifo(
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(r_enable),
		.w_enable(w_enable),
		.w_data(rcv_data),
		.r_data(r_data),
		.empty(empty),
		.full(full)
		);

   rcu control(
	       .clk(clk),
	       .n_rst(n_rst),
	       .d_edge(d_edge),
	       .eop(eop),
	       .shift_enable(shift_enable),
	       .rcv_data(rcv_data),
	       .byte_recieved(byte_recieved),
	       .rcving(rcving),
	       .w_enable(w_enable),
	       .r_error(r_error)
	       );
   
endmodule
