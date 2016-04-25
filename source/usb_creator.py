#!/usr/local/bin/python3
from random import *
import sys
import binascii

def usb_data():
    sync = '0b10000000'
    crc = '0b00000000'
    token_pids = ['0b00011110', '0b10010110', '0b01011010', '0b11010010']
    data_pids = ['0b00111100', '0b10110100', '0b01111000', '0b11110000']
    handshake_pids = ['0b00101101', '0b10100101', '0b11100001', '0b01101001']
    sof_pids = ['0b11000011', '0b11000011', '0b10000111', '0b01001011']
    token_size = 24 # 8-PID, 7-address, 4-endpoint, 5-CRC -> eop
    data_size = 32 # 8-PID, 8-data, 16-CRC -> eop
    handshake_size = 8 # 8-PID, -> eop
    sof_size = 24 # 8-PID, 11-frame name, 5-CRC -> eop

    with open("./usb_data.dat", "w") as usb_file:
        with open(sys.argv[1], "r") as data_file:
            for line in data_file:
                for character in line:
                    #for every byte of data write the following... 
                    # -> sync, a random data PID, the data byte, and 2 CRC bytes
                    binary_data_packet = [sync, data_pids[randint(0,3)], crc, crc]
                    character_data_packet = [text_from_bits(item) for item in binary_data_packet]
                    data_packet = character_data_packet[:2]+list(character)+character_data_packet[2:]
                    print(data_packet)
                    #for item in data_packet:
                        #usb_file.write(item)
                    
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
