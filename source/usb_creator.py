#!/usr/local/bin/python3
from random import *
import sys

def usb_data():
    sync = 0b10000000
    token_pids = [0b00011110, 0b10010110, 0b01011010, 0b11010010]
    data_pids = [0b00111100, 0b10110100, 0b01111000, 0b11110000]
    handshake_pids = [0b00101101, 0b10100101, 0b11100001, 0b01101001]
    sof_pids = [0b11000011, 0b11000011, 0b10000111, 0b01001011]
    token_size = 16 # 7-address, 4-endpoint, 5-CRC -> eop
    data_size = 24 # 8-data, 16-CRC -> eop
    handshake_size = 0 # -> eop
    sof_size = 16 # 11-frame name, 5-CRC -> eop

    with open("./usb_data.txt", "wb") as usb_file:
        with open(sys.argv[1], "r") as data_file:
            for line in data_file:
                ascii_nums = [ord(item) for item in line]
                data_bytes = bytearray(ascii_nums)
                usb_file.write(data_bytes)
                
    return

if __name__ == "__main__":
    usb_data()
