#!/usr/bin/python3

import numpy as np
import sys


def reverseSublist(lst, start, end):
    while start < end:
        lst[start % len(lst)], lst[end % len(lst)] = lst[end % len(lst)], lst[start % len(lst)]

        start += 1
        end -= 1

    return lst


def main():
    for line in sys.stdin:
        lst = [x for x in range(256)]
        currentPosition = 0
        skipSize = 0
        lengths = [ord(x) for x in line.strip()] + [17, 31, 73, 47, 23]
        lengths *= 64

        for length in lengths:
            lst = reverseSublist(lst, currentPosition, currentPosition + length - 1)
            currentPosition = (currentPosition + length + skipSize) % len(lst)
            skipSize += 1

        denseHash = []
        for x in range(0, 255, 16):
            denseHash.append(np.bitwise_xor.reduce(lst[x:x + 16]))

        knotHash = ''.join('%02x' % i for i in denseHash)
        print(knotHash)


if __name__ == '__main__':
    main()
