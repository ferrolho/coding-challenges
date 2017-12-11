#!/usr/bin/python3

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
        lengths = [int(x) for x in line.strip().split(',')]

        for length in lengths:
            lst = reverseSublist(lst, currentPosition, currentPosition + length - 1)
            currentPosition = (currentPosition + length + skipSize) % len(lst)
            skipSize += 1

        print(lst[0] * lst[1])


if __name__ == '__main__':
    main()
