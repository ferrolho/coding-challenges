#!/usr/bin/python3

import numpy as np
import sys


class Layer:
    def __init__(self, depth, size=0):
        self.depth = depth
        self.size = size

    def scannerPosition(self, picosecond):
        offset = picosecond % ((self.size - 1) * 2)
        return 2 * (self.size - 1) - offset if offset > self.size - 1 else offset

    def severity(self, picosecond):
        return self.depth * (self.size if self.size > 0 and self.scannerPosition(picosecond) == 0 else 0)


def main():
    firewall = []

    for line in sys.stdin:
        depth, scannerRange = line.strip().split(': ')
        depth = int(depth)
        scannerRange = int(scannerRange)

        while len(firewall) != depth:
            firewall.append(Layer(len(firewall)))

        firewall.append(Layer(depth, scannerRange))

    done = False
    picosecond = 0
    packageStream = np.zeros(int(5e6), dtype=bool)

    while not done:
        for layer in firewall:
            if layer.scannerPosition(picosecond) == 0:
                packageStream[picosecond - layer.depth] = True  # Caught package

        picosecond += 1

        if picosecond >= len(firewall) and \
           not packageStream[picosecond - len(firewall)]:
            done = True

    print(picosecond - len(firewall))


if __name__ == '__main__':
    main()
