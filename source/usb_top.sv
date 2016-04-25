// $Id: $
// File name:   usb_top.sv
// Created:     4/24/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Top Level USB for testing

module usb_top(
	       input wire  clk,
	       input wire  n_rst,
	       input wire  d_plus_in,
	       input wire  d_minus_in,
	       input wire  in_pwr,
	       input wire  in_gnd,
	       output wire d_plus_out,
	       output wire d_minus_out,
	       output wire out_pwr,
	       output wire out_gnd
	       );

   reg 			   rdata_enable, rnd_enable, rpid_enable, rdcrc_enable, rencrypt_enable;
   reg [7:0] 		   r_data, r_nd, r_pid, r_dcrc, r_encrypt, shift_write, rcv_data;
   reg 			   data_empty, pad_empty, pid_empty, nondata_empty, encrypt_empty;
   reg 			   data_full, pad_full, pid_full, nondata_full, encrypt_full;
   reg 			   enable_pad, enable_data, enable_pid, enable_nondata, enable_encrypt, enable_eop, enable_write;
   reg 			   transmit_out;
   reg 			   d_orig, d_edge, d_plus_sync, d_minus_sync;
   reg 			   eop, shift_enable;
   reg 			   byte_recieved;
   reg 			   encrypted_data;


   sync_high SHI(
		 .clk(clk),
		 .n_rst(n_rst),
		 .async_in(d_plus),
		 .sync_out(d_plus_sync)
		 );

   sync_low SHL(
		.clk(clk),
		.n_rst(n_rst),
		.async_in(d_minus),
		.sync_out(d_minus_sync)
		);

   eop_detect REOP(
		   .d_plus(d_plus_sync),
		   .d_minus(d_minus_sync),
		   .eop(eop)
		   );

   edge_detect EDETECT(
		       .clk(clk),
		       .n_rst(n_rst),
		       .d_plus(d_plus_sync),
		       .d_edge(d_edge)
		       );

   decode DEC(
	      .clk(clk),
	      .n_rst(n_rst),
	      .d_plus(d_plus_sync),
	      .shift_enable(shift_enable),
	      .eop(eop),
	      .d_orig(d_orig)
	      );
   //edit?
   timer TIM(
	     .clk(clk),
	     .n_rst(n_rst),
	     .d_edge(d_edge),
	     .rcving(rcving),
	     .shift_enable(shift_enable),
	     .byte_recieved(byte_recieved)
	     );

   shift_register SR(
		     .clk(clk),
		     .n_rst(n_rst),
		     .shift_enable(shift_enable),
		     .d_orig(d_orig),
		     .rcv_data(rcv_data)
		     );

   pid_decode PID_DECODE(
			 .clk(clk),
			 .n_rst(n_rst),
			 .w_enable(w_enable),
			 .rcv_data(rcv_data),
			 .enable_pad(enable_pad),
			 .enable_data(enable_data),
			 .enable_pid(enable_pid),
			 .enable_nondata(enable_nondata)
			 );

   rcu RRCU(
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

    trcu TRCU_CALL(
		  .clk(clk),
		  .n_rst(n_rst),
		  .encrypt_full(data_full),
		  .pid_empty(pid_empty),
		  .data_empty(data_empty),
		  .pid_read(r_pid),
		  .nd_read(r_nd),
		  .dcrc_read(r_dcrc),
		  .data_read(r_data),
		  .write(shift_write),
		  .write_enable(enable_write),
		  .nd_enable(enable_nd),
		  .eop_enable(enable_eop),
		  .pid_enable(enable_pid),
		  .dcrc_enable(enable_pad),
		  .data_enable(enable_data)
		  );
   
   transmit_shift WRITE_SHIFT(
			      .clk(clk),
			      .n_rst(n_rst),
			      .load_enable(enable_write),
			      .data(shift_write),
			      .data_out(transmit_out)
			      );
   
   transmit DATA_OUT(
		     .clk(clk),
		     .n_rst(n_rst),
		     .eop(eop_enable),
		     .d_plus(d_plus_out),
		     .d_minus(d_minus_out)
		     );

   pid_fifo PID(
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(rpid_enable),
		.w_enable(enable_pid),
		.w_data(rcv_data),
		.r_data(r_pid),
		.empty(pid_empty),
		.full(pid_full)
		);

   /*
   encrypted_fifo ENCRYPTED(
			    .clk(clk),
			    .n_rst(n_rst),
			    .r_enable(rencreypt_enable),
			    .w_enable(enable_encrypt),
			    .w_data(encrypted_data),
			    .r_data(r_encrypt),
			    .empty(encrypt_empty),
			    .full(encrypt_full)
			    );
    */
   
   nd_fifo NONDATA( //non-data fifo
		    .clk(clk),
		    .n_rst(n_rst),
		    .r_enable(rnd_enable),
		    .w_enable(enable_nondata),
		    .w_data(rcv_data),
		    .r_data(r_nd),
		    .empty(nondata_empty),
		    .full(nondata_full)
		    );

   dcrc_fifo PADDING( //CRC data padding fifo
		      .clk(clk),
		      .n_rst(n_rst),
		      .r_enable(rdcrc_enable),
		      .w_enable(enable_pad),
		      .w_data(rcv_data),
		      .r_data(r_dcrc),
		      .empty(pad_empty),
		      .full(pad_full)
		      );

   data_fifo DATA( //data fifo
		   .clk(clk),
		   .n_rst(n_rst),
		   .r_enable(rdata_enable),
		   .w_enable(enable_data),
		   .w_data(rcv_data),
		   .r_data(r_data),
		   .empty(data_empty),
		   .full(data_full)
		   );

endmodule // usb_top
