#!/usr/bin/python3

import sys


def main():
    for line in sys.stdin:
        line = line.strip() + line[0]

        sum = 0
        for i in range(len(line) - 1):
            if line[i] == line[i + 1]:
                sum += int(line[i])

        print(sum)


if __name__ == '__main__':
    main()
