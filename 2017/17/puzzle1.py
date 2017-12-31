#!/usr/bin/python3

import sys

NUM_OPS = 2017


def main():
    steps = int(sys.stdin.readline().strip())

    buffer = [0]
    currentPosition = 0

    for value in range(NUM_OPS):
        currentPosition = (currentPosition + steps + 1) % len(buffer)
        buffer.insert(currentPosition + 1, value + 1)

    print(buffer[buffer.index(2017) + 1])


if __name__ == '__main__':
    main()
