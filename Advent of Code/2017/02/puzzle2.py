#!/usr/bin/python3

import sys


def main():
    sum = 0

    for line in sys.stdin:
        values = [int(x) for x in line.strip().split()]

        goToNextLine = False

        for i in range(len(values)):
            for j in range(len(values)):
                if i == j:
                    continue

                if values[i] % values[j] == 0:
                    sum += values[i] / values[j]
                    goToNextLine = True
                    break

            if goToNextLine:
                break

    print(sum)


if __name__ == '__main__':
    main()
