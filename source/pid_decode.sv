// $Id: $
// File name:   pid_decode.sv
// Created:     4/20/2016
// Author:      Charles Hansen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Interperets the different packets recieved and sends packets to the appropriate location


/*
 Instead of information going directly to RX_FIFO, it is captured by pid_decode.  Since the first 8 bits will be the packet id, if it is a data packet it will be sent to rx_fifo and if not it will be sent to non-data packet transmission. 
 */

/* TO DO */
//Send data to appropriate locations
//Reroute modules to go through decode
//Shift_register, RCU
//Add pid_decode to the Top level

module pid_decode(
		  input wire 	    clk,
		  input wire 	    n_rst,
		  input wire 	    w_enable,
		  input wire [7:0]  rcv_data,
		  output logic 	    enable_pad,
		  output logic	    enable_data,
		  output logic	    enable_pid,
		  output logic	    enable_nondata
		  );

   reg [2:0] packet_counter;
   
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
   localparam [3:0] 			    hand4 = 4'b0110;

   //Start of Frame Packet
   localparam [3:0] 			    spec1 = 4'b1100;
   localparam [3:0] 			    spec2 = 4'b1100;
   localparam [3:0] 			    spec3 = 4'b1000;
   localparam [3:0] 			    spec4 = 4'b0100;

   typedef enum 	    bit [1:0] {IDLE, NON_DATA, DATA, CRC} stateType;
   stateType state;
   stateType next_state;

   always_ff @ (posedge clk, negedge n_rst) begin
      if(n_rst == 1'b0)
	state <= IDLE;
      else
	state <= next_state;
   end // always_ff @

always_comb begin
	// avoid latches
	enable_pad = 0;
	enable_data = 0;
	enable_pid = 0;
	enable_nondata = 0;
	next_state = state;

	case(state)
	IDLE:
	begin
		packet_counter = 0;
		if (w_enable == 1)
		begin
			enable_pid = 1; //write PID to the pid_fifo from w_data
			//decide what type of packet was just received
			if ((rcv_data[7:4] == data1) || (rcv_data[7:4] == data2) || (rcv_data[7:4] == data3) || (rcv_data[7:4] == data4))
				next_state = DATA;
			else
				next_state = NON_DATA;
				if((rcv_data[7:4] == token1) || (rcv_data[7:4] == token2) || (rcv_data[7:4] == token3) || (rcv_data[7:4] == token4))
				begin
					packet_counter = 2; // 2 bytes of token packet 
				end else if((rcv_data[7:4] == hand1) || (rcv_data[7:4] == hand2) || (rcv_data[7:4] == hand3) || (rcv_data[7:4] == hand4))
				begin
					next_state = IDLE; // only pid in handshake
				end else if((rcv_data[7:4] == spec1) || (rcv_data[7:4] == spec2) || (rcv_data[7:4] == spec3) || (rcv_data[7:4] == spec4))
				begin
					packet_counter = 2; // 2 bytes of start of frame packet
				end
		end
		else
			next_state = IDLE;
	end

	NON_DATA:
	begin
		next_state = NON_DATA;
		if (w_enable == 1)
		begin
			enable_nondata = 1;
			packet_counter = packet_counter - 1;			
		end
		if (packet_counter == 0)
			next_state = IDLE;
	end

	DATA:
	begin
		if (w_enable == 1)
		begin
			enable_data = 1;
			packet_counter = 2; //2 bytes of padding after data packet
			next_state = CRC;
		end else begin
			next_state = DATA;
		end
	end

	CRC:
	begin
		next_state = CRC;
		if (w_enable == 1)
		begin
			enable_pad = 1;
			packet_counter = packet_counter - 1;			
		end
		if (packet_counter == 0)
			next_state = IDLE;
	end
	endcase
end //end next-state logic

endmodule // pid_decode
