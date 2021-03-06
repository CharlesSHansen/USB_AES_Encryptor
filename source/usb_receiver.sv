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
		    input wire 	      rdata_enable,
		    input wire 	      rnd_enable,
		    input wire 	      rpid_enable,
		    input wire 	      rdcrc_enable,
		    output reg [7:0] r_data,
		    output reg [7:0] r_nd,
		    output reg [7:0] r_pid,
		    output reg [7:0] r_dcrc,
		    output wire       data_empty,
		    output wire       data_full,
		    output wire       pad_empty,
		    output wire       pad_full,
		    output wire       pid_empty,
		    output wire       pid_full,
		    output wire       nondata_empty,
		    output wire       nondata_full,
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
   reg				      enable_pad;
   reg				      enable_data;
   reg				      enable_pid;
   reg				      enable_nondata;


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
   //edit?
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

   pid_decode(
		.clk(clk),
		.n_rst(n_rst),
		.w_enable(w_enable),
		.rcv_data(rcv_data),
		.enable_pad(enable_pad),
		.enable_data(enable_data),
		.enable_pid(enable_pid),
		.enable_nondata(enable_nondata)
	     );

   data_fifo data( //data fifo
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(rdata_enable),
		.w_enable(enable_data),
		.w_data(rcv_data),
		.r_data(r_data),
		.empty(data_empty),
		.full(data_full)
		);

   dcrc_fifo padding( //CRC data padding fifo
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(rdcrc_enable),
		.w_enable(enable_pad),
		.w_data(rcv_data),
		.r_data(r_dcrc),
		.empty(pad_empty),
		.full(pad_full)
		);

   pid_fifo pid( //PID fifo
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(rpid_enable),
		.w_enable(enable_pid),
		.w_data(rcv_data),
		.r_data(r_pid),
		.empty(pid_empty),
		.full(pid_full)
		);

   nd_fifo nondata( //non-data fifo
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(rnd_enable),
		.w_enable(enable_nondata),
		.w_data(rcv_data),
		.r_data(r_nd),
		.empty(nondata_empty),
		.full(nondata_full)
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
