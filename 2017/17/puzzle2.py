#!/usr/bin/python3

from collections import deque
import sys

NUM_OPS = 50000000


def main():
    steps = int(sys.stdin.readline().strip())

    buffer = deque([0])

    for value in range(1, NUM_OPS + 1):
        buffer.rotate(-steps)
        buffer.append(value)

    print(buffer[buffer.index(0) + 1])


if __name__ == '__main__':
    main()
