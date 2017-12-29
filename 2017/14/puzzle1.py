#!/usr/bin/python3

import os
import sys

hexToBin = {
    '0': '0000',
    '1': '0001',
    '2': '0010',
    '3': '0011',
    '4': '0100',
    '5': '0101',
    '6': '0110',
    '7': '0111',
    '8': '1000',
    '9': '1001',
    'a': '1010',
    'b': '1011',
    'c': '1100',
    'd': '1101',
    'e': '1110',
    'f': '1111'
}


def processKnotHash(str):
    return os.popen('echo ' + str + ' | ../10/puzzle2.py').readline().strip()


def hashToRow(hash):
    return ''.join(hexToBin[char] for char in hash)


def main():
    for line in sys.stdin:
        keyString = line.strip()

        f = open('grid.txt', 'w')
        usedSquares = 0

        for row in range(128):
            hashInput = str(keyString) + '-' + str(row)
            knotHash = processKnotHash(hashInput)

            print(hashInput, knotHash)

            bin = hashToRow(knotHash)
            f.write(bin + '\n')
            usedSquares += bin.count('1')

        print('Used squares:', usedSquares)


if __name__ == '__main__':
    main()
