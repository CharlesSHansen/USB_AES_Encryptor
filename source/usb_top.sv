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
	       output wire out_gnd,
		output wire [127:0] data_out, //strictly for demonstration purposes to chow encrypted data
		output wire complete //strictly to know when to write out finished encrypted data for demonstration
	       );

   reg 			   rdata_enable, rnd_enable, rpid_enable, rdcrc_enable, rencrypt_enable;
   reg [7:0] 		   read_data, r_nd, r_pid, r_dcrc, r_encrypt, shift_write, rcv_data;
   reg 			   data_empty, pad_empty, pid_empty, nondata_empty, encrypt_empty;
   reg 			   data_full, pad_full, pid_full, nondata_full, encrypt_full;
   reg 			   enable_pad, enable_data, enable_pid, enable_nondata, enable_encrypt, enable_eop, enable_write;
   reg 			   transmit_out;
   reg 			   d_orig, d_edge, d_plus_sync, d_minus_sync;
   reg 			   eop, shift_enable;
   reg 			   byte_recieved;
   reg 			   encrypted_data;

reg [127:0] data_in;
reg ready, extract_ready, eof;
reg encrypt_data_full, encrypt_data_empty;
reg [7:0] encrypted_r_data;
reg fast_rdcrc_enable, fast_rnd_enable, fast_rpid_enable, fast_encrypted_rdata_enable;

// GENERATE SLOW CLOCK = CLK/8
reg [1:0] counter;
reg slow_clk;
reg clk_flag;
always @(posedge clk, negedge n_rst) begin
	if (!n_rst) begin
		clk_flag <= 0;
		counter <= 2'b00;
	end else begin
		if (counter == 2'b11) begin
			counter <= 2'b00;
			clk_flag <= clk_flag^1;
		end else begin
			counter <= counter+1;
		end
	end
end
assign slow_clk = clk_flag;
// END SLOW CLOCK GEN

   sync_high SHI( //input data usb sycnhronizer
		 .clk(clk),
		 .n_rst(n_rst),
		 .async_in(d_plus_in),
		 .sync_out(d_plus_sync)
		 );

   sync_low SHL( //input usb data synchronizer
		.clk(clk),
		.n_rst(n_rst),
		.async_in(d_minus_in),
		.sync_out(d_minus_sync)
		);

   eop_detect REOP( //input usb eop detector
		   .d_plus(d_plus_sync),
		   .d_minus(d_minus_sync),
		   .eop(eop)
		   );

   edge_detect EDETECT( //input usb edge detector
		       .clk(clk),
		       .n_rst(n_rst),
		       .d_minus(d_minus_sync),
		       .d_edge(d_edge)
		       );

   decode DEC( //input usb data decoder
	      .clk(clk),
	      .n_rst(n_rst),
	      .d_plus(d_plus_sync),
	      .shift_enable(shift_enable),
	      .eop(eop),
	      .d_orig(d_orig)
	      );
   timer TIM( //input usb timer
	     .clk(clk),
	     .n_rst(n_rst),
	     .d_edge(d_edge),
	     .rcving(rcving),
	     .shift_enable(shift_enable),
	     .byte_recieved(byte_recieved)
	     );

   shift_register SR( //input usb shift register
		     .clk(clk),
		     .n_rst(n_rst),
		     .shift_enable(shift_enable),
		     .d_orig(d_orig),
		     .rcv_data(rcv_data)
		     );

   rcu RRCU( //reciever control unit state machine
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

   pid_decode PID_DECODE( //packet handling state machine
			 .clk(clk),
			 .n_rst(n_rst),
			 .w_enable(w_enable),
			 .rcv_data(rcv_data),
			 .enable_pad(enable_pad),
			 .enable_data(enable_data),
			 .enable_pid(enable_pid),
			 .enable_nondata(enable_nondata),
			 .eof(eof)
			 );

   pid_fifo PID( //PID fifo
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(fast_rpid_enable),
		.w_enable(enable_pid),
		.w_data(rcv_data),
		.r_data(r_pid),
		.empty(pid_empty),
		.full(pid_full)
		);
   
   nd_fifo NONDATA( //non-data fifo
		    .clk(clk),
		    .n_rst(n_rst),
		    .r_enable(fast_rnd_enable),
		    .w_enable(enable_nondata),
		    .w_data(rcv_data),
		    .r_data(r_nd),
		    .empty(nondata_empty),
		    .full(nondata_full)
		    );

   dcrc_fifo PADDING( //CRC data padding fifo
		      .clk(clk),
		      .n_rst(n_rst),
		      .r_enable(fast_rdcrc_enable),
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
		   .r_data(read_data),
		   .empty(data_empty),
		   .full(data_full)
		   );

extract_fifo EXTRACT( //extractor to pack 128 bits from data fifo
		.clk(clk),
		.n_rst(n_rst),
		.full(data_full),
		.eof(eof),
		.data(read_data),
		.pop(rdata_enable),
		.ready(extract_ready),
		.out(data_in)
		);

aes_control AES( //top level AES controller
		.clk(clk),
		.n_rst(n_rst),
		.ready(extract_ready),
		.data_in(data_in),
		.complete(complete),
		.data_out(data_out)
		);

encrypted_fifo ENCRYPTED( //encrypted data fifo
			.clk(clk),
			.n_rst(n_rst),
			.r_enable(fast_encrypted_rdata_enable),
			.complete(complete),
			.raw_data(data_out),
			.r_data(encrypted_r_data),
			.empty(encrypt_data_empty),
			.full(encrypt_data_full)
			);

    trcu TRCU_CALL( //transmitter control unit state machine
		  .clk(slow_clk),
		  .n_rst(n_rst),
		  .encrypt_full(encrypt_data_full),
		  .pid_empty(pid_empty),
		  .data_empty(encrypt_data_empty),
		  .pid_read(r_pid),
		  .nd_read(r_nd),
		  .dcrc_read(r_dcrc),
		  .data_read(encrypted_r_data),
		  .write(shift_write),
		  .write_enable(enable_write),
		  .nd_enable(rnd_enable),
		  .eop_enable(enable_eop),
		  .pid_enable(rpid_enable),
		  .dcrc_enable(rdcrc_enable),
		  .data_enable(encrypted_rdata_enable)
		  );

slow_dcrc_enable SLOW_DCRC(
		.clk(clk),
		.n_rst(n_rst),
		.slow_enable(rdcrc_enable),
		.fast_enable(fast_rdcrc_enable)
		);

slow_nd_enable SLOW_ND(
		.clk(clk),
		.n_rst(n_rst),
		.slow_enable(rnd_enable),
		.fast_enable(fast_rnd_enable)
		);

data_slow_enable SLOW_DATA(
		.clk(clk),
		.n_rst(n_rst),
		.slow_enable(encrypted_rdata_enable),
		.fast_enable(fast_encrypted_rdata_enable)
		);

pid_slow_enable SLOW_PID(
		.clk(clk),
		.n_rst(n_rst),
		.slow_enable(rpid_enable),
		.fast_enable(fast_rpid_enable)
		);


   transmit_shift WRITE_SHIFT( //output shift register for 8 bit -> serial data
			      .clk(slow_clk),
			      .n_rst(n_rst),
			      .load_enable(enable_write),
			      .data(shift_write),
			      .eop(enable_eop),
			      .data_out(transmit_out),
			      .ready(ready)
			      );
   
   transmit_out DATA_OUT( //output USB transmitter for serial data -> D+ & D-
		     .clk(slow_clk),
		     .n_rst(n_rst),
		     .data(transmit_out),
		     .ready(ready),
		     .eop(enable_eop),
		     .d_plus(d_plus_out),
		     .d_minus(d_minus_out)
		     );


endmodule // usb_top
