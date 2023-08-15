#!/usr/bin/python3

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

    severity = 0

    for step in range(len(firewall)):
        severity += firewall[step].severity(step)

    print(severity)


if __name__ == '__main__':
    main()
