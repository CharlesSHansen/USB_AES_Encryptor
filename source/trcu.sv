// $Id: $
// File name:   trcu.sv
// Created:     4/23/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: RCU for Pulling Data from FIFOs and Transmitting them


module trcu(
	    input wire 	     clk,
	    input wire 	     n_rst,
	    input wire 	     encrypt_full,
	    input wire 	     pid_empty,
	    input wire 	     data_empty,
	    input wire [7:0] pid_read,
	    input wire [7:0] nd_read,
	    input wire [7:0] dcrc_read,
	    input wire [7:0] data_read,
	    output reg [7:0] write,
	    output reg 	     write_enable,
	    output reg 	     nd_enable,
	    output reg 	     eop_enable,
	    output reg 	     pid_enable,
	    output reg 	     dcrc_enable,
	    output reg 	     data_enable
	    );
   
   typedef enum 	     bit [4:0] {IDLE, READ_PID, W_SYNC, WAIT_SYNC, WAIT_SYNC2, WRITE_PID, WAIT_PID, WAIT_PID2, READ_ND, WAIT_ND, WAIT_ND2, READ_DATA, WAIT_DATA, WAIT_DATA2, READ_CRC, WAIT_CRC, WAIT_CRC2, READ_CRC2, WAIT_CRC3, WAIT_CRC4, WRITE_EOP, WAIT_EOP} stateType;
   stateType state;
   stateType nstate;

   reg 			     non_data, data;
   reg [1:0] 		     pid_remaining;
   reg [2:0] 		     wait_remaining;
   reg 			     full;
   
   //Token Packets
   localparam [3:0] 			    token1 = 4'b0001;
   localparam [3:0] 			    token2 = 4'b1001;
   localparam [3:0] 			    token3 = 4'b0101;
   localparam [3:0] 			    token4 = 4'b1101;

   //Data Packets
   localparam [3:0] 			    data1 = 4'b0011;
   localparam [3:0] 			    data2 = 4'b1011;
   localparam [3:0] 			    data3 = 4'b0111;
   localparam [3:0] 			    data4 = 4'b1111;

   //Handshake Packets
   localparam [3:0] 			    hand1 = 4'b0010;
   localparam [3:0] 			    hand2 = 4'b1010;
   localparam [3:0] 			    hand3 = 4'b1110;

   //End of File Handshake
   localparam [3:0] 			    hand4 = 4'b0110;

   //Start of Frame Packets
   localparam [3:0] 			     spec1 = 4'b1100;
   localparam [3:0] 			    spec2 = 4'b1100;
   localparam [3:0] 			    spec3 = 4'b1000;
   localparam [3:0] 			    spec4 = 4'b0100;

   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 1'b0)
	state <= IDLE;
      else
	state <= nstate;
   end
   always_ff @ (posedge clk, posedge encrypt_full) begin
      if(encrypt_full == 1'b1)
	full <= 1;
      else
	full <= 0;
   end // always_ff @

   always_comb begin
      nstate = state;
      nd_enable = 0;
      pid_enable = 0;
      dcrc_enable = 0;
      data_enable = 0;
      write_enable = 0;
      pid_remaining = pid_remaining;
      wait_remaining = wait_remaining;
      data = data;
      eop_enable = eop_enable;
      write = write;
      
      begin : RCU_TRANSMIT
	 case(state)
	   IDLE : begin
	      non_data = 0;
	      eop_enable = 1;
	      data = '0;
	      pid_remaining = 0;
	      wait_remaining = 0;
	      if(full == 1)
		nstate = READ_PID;
	      else
		nstate = IDLE;
	   end // case: IDLE

	   READ_PID : begin
	      non_data = 0;
	      data = 0;
	      pid_remaining = 0;
	      wait_remaining = 0;
	      if((data_empty == 1) && (pid_empty == 1)) begin
		 nstate = IDLE;
	      end
	      else begin
		 nstate = W_SYNC;
	      end
	   end // case: READ_PID

	   W_SYNC : begin
	      write = 8'b10000000;
	      write_enable = 1;
	      eop_enable = 0;
	      //Token Packets
	      if((pid_read[7:4] == token1) || (pid_read[7:4] == token2) || (pid_read[7:4] == token3) || (pid_read[7:4] == token4)) begin
		 non_data = 1;
		 data = 0;
		 pid_remaining = 2'b10;
	      end
	      //Data Packets
	      else if((pid_read[7:4] == data1) || (pid_read[7:4] == data2) || (pid_read[7:4] == data3) || (pid_read[7:4] == data4)) begin
		 data = 1;
		 non_data = 0;
		 pid_remaining = 0;
	      end
 	      //Handshake Packets
	      else if((pid_read[7:4] == hand1) || (pid_read[7:4] == hand2) || (pid_read[7:4] == hand3) || (pid_read[7:4] == hand4)) begin
		 non_data = 1;
		 data = 0;
		 pid_remaining = 2'b00;
	      end
	      //Start of Frame Packets
	      if((pid_read[7:4] == spec1) || (pid_read[7:4] == spec2) || (pid_read[7:4] == spec3) || (pid_read[7:4] == spec4)) begin
		 non_data = 1;
		 data = 0;
		 pid_remaining = 2'b10;
	      end
	      wait_remaining = 6;
	      nstate = WAIT_SYNC;
	   end // case: W_SYNC

	   WAIT_SYNC : begin
	      if(wait_remaining == 0) begin
		 write = pid_read;
		 nstate = WRITE_PID;
	      end else begin
		 wait_remaining = wait_remaining - 1'b1;
		 nstate = WAIT_SYNC2;
	      end
	   end

	   WAIT_SYNC2 : begin
	      if(wait_remaining == 0) begin
		 write = pid_read;
		 nstate = WRITE_PID;
	      end else begin
		 wait_remaining = wait_remaining - 1'b1;
		 nstate = WAIT_SYNC;
	      end
	   end
	   
	   WRITE_PID : begin
	      write_enable = 1;
	      wait_remaining = 6;
	      nstate = WAIT_PID;
	   end
	   
	   WAIT_PID : begin
	      if(wait_remaining != 1'b0) begin
		 nstate = WAIT_PID2;
		 wait_remaining = wait_remaining - 1;
	      end
	      else begin
		 if(data == 1) begin
		    write = data_read;
		    nstate = READ_DATA;
		 end else begin
		    nstate = READ_ND;
		 end
	      end
	   end // case: WAIT_SYNC

	   WAIT_PID2 : begin
	      if(wait_remaining != 1'b0) begin
		 nstate = WAIT_PID;
		 wait_remaining = wait_remaining - 1;
	      end
	      else begin
		 if(data == 1) begin
		    write = data_read;
		    nstate = READ_DATA;
		 end else begin
		    nstate = READ_ND;
		 end
	      end
	   end // case: WAIT_SYNC2

	   READ_DATA : begin
	      write_enable = 1;
	      wait_remaining = 6;
	      nstate = WAIT_DATA;
	   end // case: READ

	   WAIT_DATA : begin
	      if(wait_remaining == 0) begin
		 write = dcrc_read;
		 nstate = READ_CRC;
	      end else begin
		 nstate = WAIT_DATA2;
		 wait_remaining = wait_remaining - 1;
	      end
	   end // case: WAIT_DATA

	   WAIT_DATA2 : begin
	      if(wait_remaining == 0) begin
		 write = dcrc_read;
		 nstate = READ_CRC;
	      end else begin
		 nstate = WAIT_DATA;
		 wait_remaining = wait_remaining - 1;
	      end
	   end // case: WAIT_DATA

	   
	   READ_CRC : begin
	      if(data == 1'b1)
		data_enable = 1;
	      else
		nd_enable = 1;
	      wait_remaining = 6;
	      write_enable = 1;
	      nstate = WAIT_CRC;
	   end // case: READ_CRC

	   WAIT_CRC : begin
	      if(wait_remaining == 0) begin
		 nstate = READ_CRC2;
		 write = dcrc_read;
	      end
	      else begin
		 wait_remaining = wait_remaining - 1;
		 nstate = WAIT_CRC2;
	      end
	   end // case: WAIT_CRC

	   WAIT_CRC2 : begin
	      if(wait_remaining == 0) begin
		 nstate = READ_CRC2;
		 write = dcrc_read;
	      end
	      else begin
		 wait_remaining = wait_remaining - 1;
		 nstate = WAIT_CRC;
	      end
	   end // case: WAIT_CRC

	   
	   READ_CRC2 : begin
	      wait_remaining = 6;
	      write_enable = 1;
	      dcrc_enable = 1;
	      nstate = WAIT_CRC3;
	   end // case: READ_CRC

	   WAIT_CRC3 : begin
	      if(wait_remaining == 0) begin
		 nstate = WRITE_EOP;
	      end else begin
		 wait_remaining = wait_remaining - 1;
		 nstate = WAIT_CRC4;
	      end
	   end // case: WAIT_CRC

	   WAIT_CRC4 : begin
	      if(wait_remaining == 0) begin
		 nstate = WRITE_EOP;
	      end else begin
		 wait_remaining = wait_remaining - 1;
		 nstate = WAIT_CRC3;
	      end
	   end // case: WAIT_CRC

	   
	   READ_ND : begin
	      write = nd_read;
	      write_enable = 1;
	      if(pid_remaining == 0) begin
		 nstate = WRITE_EOP;
	      end
	      else begin
		 wait_remaining = 6;
		 pid_remaining = pid_remaining - 1;
		 nstate = WAIT_ND;
	      end
	   end // case: READ_ND
	   
	   WAIT_ND : begin
	      if(wait_remaining == 0) begin
		 nd_enable = 1;
		 if(pid_remaining != 0) begin
		    nstate = READ_ND;
		 end else begin
		    nstate = WRITE_EOP;
		 end
	      end else begin
		 wait_remaining = wait_remaining - 1;
		 nstate = WAIT_ND2;
	      end
	   end // case: WAIT_ND

	   WAIT_ND2 : begin
	      if(wait_remaining == 0) begin
		 nd_enable = 1;
		 if(pid_remaining != 0) begin
		    nstate = READ_ND;
		 end else begin
		    nstate = WRITE_EOP;
		 end
	      end else begin
		 wait_remaining = wait_remaining - 1;
		 nstate = WAIT_ND;
	      end
	   end // case: WAIT_ND
	   
	   WRITE_EOP : begin
	      dcrc_enable = 1;
	      eop_enable = 1;
	      nstate = WAIT_EOP;
	   end

	   WAIT_EOP : begin
	      pid_enable = 1;
	      nstate = READ_PID;
	   end
	 endcase // case (state)
      end // block: RCU_TRANSMIT
   end // always_comb
endmodule // RCU_Transmit
