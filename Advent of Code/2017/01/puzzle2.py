#!/usr/bin/python3

import sys


def main():
    for line in sys.stdin:
        line = line.strip()

        sum = 0
        for a in range(len(line)):
            b = (a + int(len(line) / 2)) % len(line)
            if line[a] == line[b]:
                sum += int(line[a])

        print(sum)


if __name__ == '__main__':
    main()
