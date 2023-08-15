#!/usr/bin/python3

import numpy as np
import re
import sys

SIZE = 300


def main():
    sn = int(sys.stdin.readline())
    grid = np.zeros((SIZE + 1, SIZE + 1), dtype=int)

    for y in range(1, SIZE + 1):
        for x in range(1, SIZE + 1):
            rack_id = x + 10
            pwr_lvl = (rack_id * y + sn) * rack_id
            pwr_lvl = int(str(pwr_lvl)[-3]) if pwr_lvl >= 100 else 0
            grid[y][x] = pwr_lvl - 5

    max_pwr = 0
    descriptor = None

    for y in range(1, SIZE - 2):
        for x in range(1, SIZE - 2):
            pwr = np.sum(grid[y:y+3, x:x+3])

            if pwr > max_pwr:
                max_pwr = pwr
                descriptor = (x, y, pwr)

    print('Part 1: {},{} ({})'.format(*descriptor))

    for y in range(1, SIZE - 2):
        print('\rWorking... {:.2f} %'.format(100 * y / (SIZE - 3)), end='')
        for x in range(1, SIZE - 2):
            for l in range(1, SIZE + 1 - max(x, y)):
                pwr = np.sum(grid[y:y+l, x:x+l])

                if pwr > max_pwr:
                    max_pwr = pwr
                    descriptor = (x, y, l, pwr)

    print('\nPart 2: {},{},{} ({})'.format(*descriptor))


if __name__ == '__main__':
    main()
