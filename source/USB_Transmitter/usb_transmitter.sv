// $Id: $
// File name:   usb_transmitter.sv
// Created:     4/24/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Top Level for USB Transmitter

module usb_transmitter(
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

   reg 				   rdata_enable, rnd_enable, rpid_enable, rdcrc_enable, rencrypt_enable;
   reg [7:0] 			   r_data, r_nd, r_pid, r_dcrc, r_encrypt, shift_write;
   reg 				   data_empty, pad_empty, pid_empty, nondata_empty, encrypt_empty;
   reg 				   data_full, pad_full, pid_full, nondata_full, encrypt_full;
   reg 				   enable_pad, enable_data, enable_pid, enable_nondata, enable_encrypt, enable_eop, enable_write;
   reg 				   transmit_out;

   reg 				   encrypted_data;
   

   trcu TRCU_CALL(
		  .clk(clk),
		  .n_rst(n_rst),
		  .encrypt_full(encrypt_full),
		  .pid_empty(pid_empty),
		  .data_empty(encrypt_empty),
		  .pid_read(r_pid),
		  .nd_read(r_nd),
		  .dcrc_read(r_dcrc),
		  .data_read(r_encrypt),
		  .write(shift_write),
		  .write_enable(enable_write),
		  .nd_enable(enable_nd),
		  .eop_enable(enable_eop),
		  .pid_enable(enable_pid),
		  .dcrc_enable(enable_pad),
		  .data_enable(enable_encrypt)
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


endmodule // usb_transmitter

