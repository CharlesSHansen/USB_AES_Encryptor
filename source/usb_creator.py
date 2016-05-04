#!/usr/local/bin/python3
from random import *
import sys
import binascii

sync = '0b01111111'
crc = '0b00000000'
end_of_file = '0b01101001'
token_pids = ['0b00011110', '0b10010110', '0b01011010', '0b11010010']
data_pids = ['0b00111100', '0b10110100', '0b01111000', '0b11110000']
handshake_pids = ['0b00101101', '0b10100101', '0b11100001']
sof_pids = ['0b11000011', '0b11000011', '0b10000111', '0b01001011']

def usb_data():
    token_size = 24 # 8-PID, 7-address, 4-endpoint, 5-CRC -> eop
    data_size = 32 # 8-PID, 8-data, 16-CRC -> eop
    handshake_size = 8 # 8-PID, -> eop
    sof_size = 24 # 8-PID, 11-frame name, 5-CRC -> eop
    packet_counter = 100

    with open("./usb_data.dat", "wb") as usb_file:
        with open(sys.argv[1], "r") as data_file:
            for line in data_file:
                for character in line:
                    #for every byte of data write the following... 
                    # -> sync, a random data PID, the data byte, and 2 CRC bytes
                    first_half = [sync, data_pids[randint(0,3)]]
                    second_half = [crc, crc]
                    first_int = [int(item, 2) for item in first_half]
                    second_int = [int(item, 2) for item in second_half]
                    integer_data_packet = first_int
                    integer_data_packet.append(ord(character))
                    integer_data_packet += second_int
                    byte_data_packet = [int2bytes(item) for item in integer_data_packet]
                    for item in byte_data_packet:
                        usb_file.write(item)
            usb_file.write(int2bytes(int(sync, 2)))
            usb_file.write(int2bytes(int(end_of_file, 2)))
            print("finished writing data file as usb data")
    
    #with open("./packet_data.txt", "wb") as packet_file:
    #    while packet_counter > 0:
    #        packet_type = randint(0,2)
    #        if (packet_type == 0): #token
    #            data = [sync, token_pids[randint(0,3)], '0b01010101', '0b00110011']
    #        elif (packet_type == 1): #handshake
    #            data = [sync, handshake_pids[randint(0,2)]]
    #        elif (packet_type == 2): #start of frame
    #            data = [sync, sof_pids[randint(0,3)], '0b11110000', '0b11001100']
    #        data_ints = [int(item, 2) for item in data]
    #        data_bytes = [int2bytes(item) for item in data_ints]
    #        for item in data_bytes:
    #            packet_file.write(item)
    #        packet_counter -= 1
    #    packet_file.write(int2bytes(int(sync, 2)))
    #    packet_file.write(int2bytes(int(end_of_file, 2)))
    return

def mixed_data():
    with open("./mixed_data.dat", "wb") as mixed_file:
        with open(sys.argv[1], "r") as data_file:
            for line in data_file:
                for character in line:
                    if (randint(0,5) == 1):
                        packet_type = randint(0,2)
                        if (packet_type == 0): #token
                            data = [sync, token_pids[randint(0,3)], '0b01010101', '0b00110011']
                        elif (packet_type == 1): #handshake
                            data = [sync, handshake_pids[randint(0,2)]]
                        elif (packet_type == 2): #start of frame
                            data = [sync, sof_pids[randint(0,3)], '0b11110000', '0b11001100']
                        data_ints = [int(item, 2) for item in data]
                        data_bytes = [int2bytes(item) for item in data_ints]
                        for item in data_bytes:
                            mixed_file.write(item)
                    first_half = [sync, data_pids[randint(0,3)]]
                    second_half = [crc, crc]
                    first_int = [int(item, 2) for item in first_half]
                    second_int = [int(item, 2) for item in second_half]
                    integer_data_packet = first_int
                    integer_data_packet.append(ord(character))
                    integer_data_packet += second_int
                    byte_data_packet = [int2bytes(item) for item in integer_data_packet]
                    for item in byte_data_packet:
                        mixed_file.write(item)
            mixed_file.write(int2bytes(int(sync, 2)))
            mixed_file.write(int2bytes(int(end_of_file, 2)))
    return

def text_to_bits(text, encoding='utf-8', errors='surrogatepass'):
    bits = bin(int(binascii.hexlify(text.encode(encoding, errors)), 16))[2:]
    return bits.zfill(8 * ((len(bits) + 7) // 8))

def text_from_bits(bits, encoding='utf-8', errors='surrogatepass'):
    n = int(bits, 2)
    #return int2bytes(n).decode(encoding, errors)
    return (chr(n))

def int2bytes(i):
    hex_string = '%x' % i
    n = len(hex_string)
    return binascii.unhexlify(hex_string.zfill(n + (n & 1)))

if __name__ == "__main__":
    usb_data()
    #mixed_data()
