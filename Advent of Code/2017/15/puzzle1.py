#!/usr/bin/python3

import sys


def main():
    prev_a, prev_b = [int(line.strip().split()[-1]) for line in sys.stdin.readlines()]

    count = 0

    for i in range(int(40e6)):
        next_a = (prev_a * 16807) % 2147483647
        next_b = (prev_b * 48271) % 2147483647

        prev_a = next_a
        prev_b = next_b

        if i % 1e6 == 0:
            print('Progress:', i)

        if format(next_a, '032b')[16:] == format(next_b, '032b')[16:]:
            count += 1

    print(count)


if __name__ == '__main__':
    main()
