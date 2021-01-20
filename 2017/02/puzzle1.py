#!/usr/bin/python3

import sys


def main():
    sum = 0
    for line in sys.stdin:
        values = [int(x) for x in line.strip().split()]
        sum += max(values) - min(values)
    print(sum)


if __name__ == '__main__':
    main()
