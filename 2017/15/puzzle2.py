#!/usr/bin/python3

import sys


def main():
    prev_a, prev_b = [int(line.strip().split()[-1]) for line in sys.stdin.readlines()]

    count = 0

    for i in range(int(5e6)):
        done = False
        while not done:
            next_a = (prev_a * 16807) % 2147483647
            prev_a = next_a
            done = next_a % 4 == 0

        done = False
        while not done:
            next_b = (prev_b * 48271) % 2147483647
            prev_b = next_b
            done = next_b % 8 == 0

        # print(prev_a, prev_b)

        if i % 1e6 == 0:
            print('Progress:', i)

        # print(format(next_a, '032b')[16:])
        # print(format(next_b, '032b')[16:])
        # print()

        if format(next_a, '032b')[16:] == format(next_b, '032b')[16:]:
            count += 1

    print(count)


if __name__ == '__main__':
    main()
