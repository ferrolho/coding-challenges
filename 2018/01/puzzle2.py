#!/usr/bin/python3

import sys


def main():
    frequency_change_list = [int(line) for line in sys.stdin]

    seen = set([0])
    frequency = 0

    i = 0
    while True:
        frequency += frequency_change_list[i]

        # print(frequency, frequency in seen)

        if frequency in seen:
            print(frequency)
            break

        i = (i + 1) % len(frequency_change_list)
        seen.add(frequency)
        # print(seen)


if __name__ == '__main__':
    main()
