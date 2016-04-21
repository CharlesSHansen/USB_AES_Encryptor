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
		  input wire 	    r_enable,
		  input wire 	    w_enable,
		  input wire [7:0]  w_data,
		  output wire [7:0] r_data,
		  output wire 	    empty,
		  output wire 	    
		  );

   reg [8:0] 			    num_bits;
   reg [1:0] 			    packet_type;
   
   //Token Packets
   wire [3:0] 			    token1 = 4'b0001;
   wire [3:0] 			    token2 = 4'b1001;
   wire [3:0] 			    token3 = 4'b0101;
   wire [3:0] 			    token4 = 4'b1101;

   //Data Packets
   wire [3:0] 			    data1 = 4'b0011;
   wire [3:0] 			    data2 = 4'b1011;
   wire [3:0] 			    data3 = 4'b0111;
   wire [3:0] 			    data4 = 4'b1111;

   //Handshake Packets
   wire [3:0] 			    hand1 = 4'b0010;
   wire [3:0] 			    hand2 = 4'b1010;
   wire [3:0] 			    hand3 = 4'b1110;
   wire [3:0] 			    hand4 = 4'b0110;

   /*   Start of Frame Packet, dealt with in else statement.  Declarations are for sanity
    wire [3:0] 			    spec1 = 4'b1100;
    wire [3:0] 			    spec2 = 4'b1100;
    wire [3:0] 			    spec3 = 4'b1000;
    wire [3:0] 			    spec4 = 4'b0100;
    */
   
   always_comb begin
      /*
       Deal with the packet type and store the number bits that will be recieved.  
       */
      if((w_data[7:4] == token1) || (w_data[7:4] == token2) || (w_data[7:4] == token3) || (w_data[7:4] == token4)) begin
	 num_bits = 9'hF8;
	 packet_type = 2'b00;
      end
      else if((w_data[7:4] == data1) || (w_data[7:4] == data2) || (w_data[7:4] == data3) || (w_data[7:4] == data4)) begin
	 num_bits = 9'FF;
	 packet_type = 2'b01;
      end
      else if((w_data[7:4] == hand1) || (w_data[7:4] == hand2) || (w_data[7:4] == hand3) || (w_data[7:4] == hand4)) begin
	 num_bits = 9'h8;
	 packet_type = 2'b10;
      end
      else begin
	 num_bits = 9'hF8;
	 packet_type = 2'b11;
      end
   end // always_comb
   
endmodule // pid_decode
