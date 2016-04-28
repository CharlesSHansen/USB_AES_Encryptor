#!/usr/bin/env python3

### Author: Alex Dunker
### ECN: adunker
### HW: 4
### Filename: ece404_hw04_dunker.py
### Due Date: 02/05/2016

from BitVector import *
import sys
import binascii

inmessage = "plaintext.txt"
encout = "encryptedtext.txt"
decout = "decryptedtext.txt"
inKey = "aardvarkaardvark"
AES_modulus = BitVector(bitstring='100011011')

## These two tables are created with the genTables function seen below and outlined in the notes
subBytesTable = [99, 124, 119, 123, 242, 107, 111, 197, 48, 1, 103, 43, 254, 215, 171, 118, 202, 130, 201, 125, 250, 89, 71, 240, 173, 212, 162, 175, 156, 164, 114, 192, 183, 253, 147, 38, 54, 63, 247, 204, 52, 165, 229, 241, 113, 216, 49, 21, 4, 199, 35, 195, 24, 150, 5, 154, 7, 18, 128, 226, 235, 39, 178, 117, 9, 131, 44, 26, 27, 110, 90, 160, 82, 59, 214, 179, 41, 227, 47, 132, 83, 209, 0, 237, 32, 252, 177, 91, 106, 203, 190, 57, 74, 76, 88, 207, 208, 239, 170, 251, 67, 77, 51, 133, 69, 249, 2, 127, 80, 60, 159, 168, 81, 163, 64, 143, 146, 157, 56, 245, 188, 182, 218, 33, 16, 255, 243, 210, 205, 12, 19, 236, 95, 151, 68, 23, 196, 167, 126, 61, 100, 93, 25, 115, 96, 129, 79, 220, 34, 42, 144, 136, 70, 238, 184, 20, 222, 94, 11, 219, 224, 50, 58, 10, 73, 6, 36, 92, 194, 211, 172, 98, 145, 149, 228, 121, 231, 200, 55, 109, 141, 213, 78, 169, 108, 86, 244, 234, 101, 122, 174, 8, 186, 120, 37, 46, 28, 166, 180, 198, 232, 221, 116, 31, 75, 189, 139, 138, 112, 62, 181, 102, 72, 3, 246, 14, 97, 53, 87, 185, 134, 193, 29, 158, 225, 248, 152, 17, 105, 217, 142, 148, 155, 30, 135, 233, 206, 85, 40, 223, 140, 161, 137, 13, 191, 230, 66, 104, 65, 153, 45, 15, 176, 84, 187, 22]
invSubBytesTable = [82, 9, 106, 213, 48, 54, 165, 56, 191, 64, 163, 158, 129, 243, 215, 251, 124, 227, 57, 130, 155, 47, 255, 135, 52, 142, 67, 68, 196, 222, 233, 203, 84, 123, 148, 50, 166, 194, 35, 61, 238, 76, 149, 11, 66, 250, 195, 78, 8, 46, 161, 102, 40, 217, 36, 178, 118, 91, 162, 73, 109, 139, 209, 37, 114, 248, 246, 100, 134, 104, 152, 22, 212, 164, 92, 204, 93, 101, 182, 146, 108, 112, 72, 80, 253, 237, 185, 218, 94, 21, 70, 87, 167, 141, 157, 132, 144, 216, 171, 0, 140, 188, 211, 10, 247, 228, 88, 5, 184, 179, 69, 6, 208, 44, 30, 143, 202, 63, 15, 2, 193, 175, 189, 3, 1, 19, 138, 107, 58, 145, 17, 65, 79, 103, 220, 234, 151, 242, 207, 206, 240, 180, 230, 115, 150, 172, 116, 34, 231, 173, 53, 133, 226, 249, 55, 232, 28, 117, 223, 110, 71, 241, 26, 113, 29, 41, 197, 137, 111, 183, 98, 14, 170, 24, 190, 27, 252, 86, 62, 75, 198, 210, 121, 32, 154, 219, 192, 254, 120, 205, 90, 244, 31, 221, 168, 51, 136, 7, 199, 49, 177, 18, 16, 89, 39, 128, 236, 95, 96, 81, 127, 169, 25, 181, 74, 13, 45, 229, 122, 159, 147, 201, 156, 239, 160, 224, 59, 77, 174, 42, 245, 176, 200, 235, 187, 60, 131, 83, 153, 97, 23, 43, 4, 126, 186, 119, 214, 38, 225, 105, 20, 99, 85, 33, 12, 125]


kSchedule = [BitVector(size = 32)] * 44
roundKeys = [BitVector(size = 128)] * 11

if len(sys.argv) != 4:
    sys.stderr.write("Usage: %s <key> <encryptedtext> <outfile>\n" % sys.argv[0])
    sys.exit(1)

## Function for creating the substitution tables that are hard coded above to save time
def genTables():
    c = BitVector(bitstring='01100011')
    d = BitVector(bitstring='00000101')
    for i in range(0, 256):
        a = BitVector(intVal = i, size=8).gf_MI(AES_modulus,8) if i != 0 else BitVector(intVal=0)

        a1,a2,a3,a4 = [a.deep_copy() for x in range(4)]
        a ^= (a1 >> 4) ^ (a2 >> 5) ^ (a3 >> 6) ^ (a4 >> 7) ^ c
        subBytesTable.append(int(a))

        b = BitVector(intVal = i, size=8)

        b1,b2,b3 = [b.deep_copy() for x in range(3)]
        b = (b1 >> 2) ^ (b2 >> 5) ^ (b3 >> 7) ^ d
        check = b.gf_MI(AES_modulus, 8)
        b = check if isinstance(check, BitVector) else 0
        invSubBytesTable.append(int(b))

## Add the round key to the state
def addRoundKey(state, word):
    state ^= word
    return state

## Substitute the bytes
def SubBytes(state):
    for i in range(4):
        for j in range(4):
            state[j][i] = hex(subBytesTable[int(state[j][i],0)])
    return state

## Shift rows
def ShiftRows(state):
    state[1] = state[1][1:]+state[1][:1]
    state[2] = state[2][2:]+state[2][:2]
    state[3] = state[3][3:]+state[3][:3]
    return state

## Column mixer, employs GF(2^8) arithmetic
def MixColumns(state):
    ## The hex multipliers
    hex_01 = BitVector( hexstring = '01' )
    hex_02 = BitVector( hexstring = '02' )
    hex_03 = BitVector( hexstring = '03' )
    for r in range(4):
        for c in range(4):
            ## Convert the hex list to bitvector to use the BitVector module calls
            state[r][c] = BitVector(intVal = int(state[r][c], 0))
            if len(state[r][c]) < 8:
                state[r][c].pad_from_left(8-len(state[r][c]))

    # Create a temporary and perform a deep copy
    temp = [[BitVector( size = 8 ) for x in range(4)] for x in range(4)]
    for r in range(4):
        for c in range(4):
            temp[r][c] = state[r][c].deep_copy()

    ## Perform the operation
    for c in range(4):
        state[0][c] = temp[0][c].gf_multiply_modular(hex_02, AES_modulus, 8) ^ temp[1][c].gf_multiply_modular(hex_03, AES_modulus, 8) ^ temp[2][c] ^ temp[3][c]
        state[1][c] = temp[0][c] ^ temp[1][c].gf_multiply_modular(hex_02, AES_modulus, 8) ^ temp[2][c].gf_multiply_modular(hex_03, AES_modulus, 8) ^ temp[3][c]
        state[2][c] = temp[0][c] ^ temp[1][c] ^ temp[2][c].gf_multiply_modular(hex_02, AES_modulus, 8) ^ temp[3][c].gf_multiply_modular(hex_03, AES_modulus, 8)
        state[3][c] = temp[0][c].gf_multiply_modular(hex_03, AES_modulus, 8) ^ temp[1][c] ^ temp[2][c] ^ temp[3][c].gf_multiply_modular(hex_02, AES_modulus, 8)

    ## Convert to hex list
    for r in range(4):
        for c in range(4):
            state[r][c] = hex(state[r][c].int_val())

    return state

## Function to convert my stateArrays to bitvectors and hold the proper 4x4 orientation
def sAr2BV(state):
    tBV = BitVector(intVal = int(state[0][0], 0))
    if len(tBV) < 8:
        tBV.pad_from_left(8-(len(tBV)%8))
    bv = tBV
    for c in range(0,4,1):
        for r in range(0,4,1):
            if((r+c) != 0):
                tBV = BitVector(intVal = int(state[r][c], 0))
                if len(tBV) < 8:
                    tBV.pad_from_left(8-(len(tBV)))
                bv = bv + tBV
    return bv

## Rotate word
def RotWord(word):
    word.circular_rot_left()
    word.circular_rot_left()
    word.circular_rot_left()
    word.circular_rot_left()
    word.circular_rot_left()
    word.circular_rot_left()
    word.circular_rot_left()
    word.circular_rot_left()
    return word

## Substitute word
def SubWord(word):
    for i in range(0,32,8):
        temp = BitVector( intVal = subBytesTable[word[i:i+8].int_val()])
        if len(temp) < 8:
            temp.pad_from_left(8-len(temp))
        word[i:i+8] = temp

    return word


## Create the key schedule
def getKeySchedule(bv):
    kArray = [[BitVector(size = 8) for x in range(4)] for x in range(4)]
    key = BitVector( textstring = inKey)
    words = [None, None, None, None]
    ## Generate round constant bytes
    bufferBits = BitVector(intVal = 0, size = 24)
    two = BitVector(intVal = 2, size = 8)
    roundConstant = [0] * 10
    roundConstant[0] = BitVector(intVal = 1, size = 8)
    ## Start creating the round constants.
    for i in range(1,10):
        roundConstant[i] = roundConstant[i-1].gf_multiply_modular(two, AES_modulus, 8)
    ## Expand them to the proper size
    for i in range(10):
        roundConstant[i] += bufferBits
    for i in range(4):
        for j in range(4):
            kArray[i][j] = key[32*i + 8*j:32*i+8*(j+1)]
    for i in range(4):
        words[i] = kArray[i][0] + kArray[i][1] + kArray[i][2] + kArray[i][3]
        kSchedule[i] = words[i]
    ## Create the rest of the words
    for i in range(4,44,1):
        temp = kSchedule[i-1].deep_copy()
        if i % 4 == 0:
            temp = RotWord(temp)
            temp = SubWord(temp)
            temp ^= roundConstant[int(i/4)-1]
        kSchedule[i] = temp ^ kSchedule[i-4]
    ## Assemble the final roundKeys
    for i in range(0,44,4):
        roundKeys[int(i/4)] = kSchedule[i]+kSchedule[i+1]+kSchedule[i+2]+kSchedule[i+3]

def AES_enc(key, message, fileout):
    ## Get the key
    kBV = BitVector( textstring = inKey )
    ## Create the bitvector for the file
    bv = BitVector( filename = message )
    FILEOUT = open(fileout, 'wb')
    FILEHEX = open(fileout+"hex", 'wb')
    stateArray = [[0 for x in range(4)] for x in range(4)]
    nextArray = [[0 for x in range(4)] for x in range(4)]
    while(bv.more_to_read):
        ## Read 128 bit block
        bitvec = bv.read_bits_from_file(128)
        ## Ensure that length is 128, if not pad
        if((bitvec.length() % 128) != 0):
            bitvec.pad_from_right(128-(bitvec.length() % 128))
        getKeySchedule(bitvec)
        bitvec = addRoundKey(bitvec, roundKeys[0])
        for i in range(4):
            for j in range(4):
                nextArray[j][i] = hex(bitvec[32*i + 8*j:32*i+8*(j+1)].int_val())

        for x in range(9):
            stateArray = nextArray
            stateArray = SubBytes(stateArray)
            stateArray = ShiftRows(stateArray)
            stateArray = MixColumns(stateArray)
            stateArray = addRoundKey(sAr2BV(stateArray), roundKeys[x+1]) ##returns bitvector
            for r in range(4):
                for c in range(4):
                    nextArray[c][r] = hex(stateArray[8*c+32*r:8*(c+1)+32*r].int_val())
        stateArray = SubBytes(nextArray)
        stateArray = ShiftRows(stateArray)
        stateArray = addRoundKey(sAr2BV(stateArray), roundKeys[10])
        FILEOUT.write(stateArray.get_text_from_bitvector())
        FILEHEX.write(stateArray.get_bitvector_in_hex())
    FILEOUT.close()

def InvShiftRows(state):
    state[1] = state[1][-1:]+state[1][:-1]
    state[2] = state[2][-2:]+state[2][:-2]
    state[3] = state[3][-3:]+state[3][:-3]
    return state

def InvSubBytes(state):
    for i in range(4):
        for j in range(4):
            state[j][i] = hex(invSubBytesTable[int(state[j][i], 16)])
    return state

def InvMixColumns(state):
    ## Hex codes for gf_multiplicaiton
    hex_0E = BitVector( hexstring = '0e' )
    hex_0B = BitVector( hexstring = '0b' )
    hex_0D = BitVector( hexstring = '0d' )
    hex_09 = BitVector( hexstring = '09' )

    for r in range(4):
        for c in range(4):
            state[r][c] = BitVector(intVal = int(state[r][c], 0))
            if len(state[r][c]) < 8:
                state[r][c].pad_from_left(8-len(state[r][c]))

    temp = [[BitVector( size = 8 ) for x in range(4)] for x in range(4)]
    for r in range(4):
        for c in range(4):
            temp[r][c] = state[r][c].deep_copy()

    for c in range(4):
        state[0][c] = temp[0][c].gf_multiply_modular(hex_0E, AES_modulus, 8) ^ temp[1][c].gf_multiply_modular(hex_0B, AES_modulus, 8) ^ temp[2][c].gf_multiply_modular(hex_0D, AES_modulus, 8) ^ temp[3][c].gf_multiply_modular(hex_09, AES_modulus, 8)
        state[1][c] = temp[0][c].gf_multiply_modular(hex_09, AES_modulus, 8) ^ temp[1][c].gf_multiply_modular(hex_0E, AES_modulus, 8) ^ temp[2][c].gf_multiply_modular(hex_0B, AES_modulus, 8) ^ temp[3][c].gf_multiply_modular(hex_0D, AES_modulus, 8)
        state[2][c] = temp[0][c].gf_multiply_modular(hex_0D, AES_modulus, 8) ^ temp[1][c].gf_multiply_modular(hex_09, AES_modulus, 8) ^ temp[2][c].gf_multiply_modular(hex_0E, AES_modulus, 8) ^ temp[3][c].gf_multiply_modular(hex_0B, AES_modulus, 8)
        state[3][c] = temp[0][c].gf_multiply_modular(hex_0B, AES_modulus, 8) ^ temp[1][c].gf_multiply_modular(hex_0D, AES_modulus, 8) ^ temp[2][c].gf_multiply_modular(hex_09, AES_modulus, 8) ^ temp[3][c].gf_multiply_modular(hex_0E, AES_modulus, 8)

    for r in range(4):
        for c in range(4):
            state[r][c] = hex(state[r][c].int_val())

    return state

def AES_dec(key, message, fileout):
    ## Get the key
    text = ""
    kBV = BitVector( textstring = inKey )
    bv = BitVector( filename = message )
    FILEOUT = open(fileout, 'wb')
    stateArray = [[0 for x in range(4)] for x in range(4)]
    nextArray = [[0 for x in range(4)] for x in range(4)]
    while(bv.more_to_read):
        bitvec = bv.read_bits_from_file(128)
        ## Ensure that length is 128, if not pad
        if((bitvec.length() % 128) != 0):
            bitvec.pad_from_right(128-(bitvec.length() % 128))
        getKeySchedule(bitvec)
        bitvec = addRoundKey(bitvec, roundKeys[10])
        for i in range(4):
            for j in range(4):
                nextArray[j][i] = hex(bitvec[32*i + 8*j:32*i+8*(j+1)].int_val())
        ## Different process for AES_dec
        for x in range(9):
            stateArray = nextArray
            stateArray = InvShiftRows(stateArray)
            stateArray = InvSubBytes(stateArray)
            stateArray = addRoundKey(sAr2BV(stateArray), roundKeys[9-x])
            for i in range(4):
                for j in range(4):
                    nextArray[j][i] = hex(stateArray[32*i + 8*j:32*i+8*(j+1)].int_val())
            nextArray = InvMixColumns(nextArray)
        stateArray = InvShiftRows(nextArray)
        stateArray = InvSubBytes(stateArray)
        stateArray = addRoundKey(sAr2BV(stateArray), kBV)
        text += stateArray.get_text_from_bitvector()
        FILEOUT.write(stateArray.get_text_from_bitvector())
    print("Decrypted text is:")
    print(text)
    FILEOUT.close()

def main():
    #genTables() ## Commented out since we already have the tables
    f = open(sys.argv[2])
    message = f.read().strip()
    f.close()
    with open('tempHex.tmp', 'wb') as f:
        f.write(binascii.unhexlify(message))
    AES_dec(sys.argv[1], "tempHex.tmp", sys.argv[3])

if __name__ == "__main__":
    main()
