#!/usr/bin/python3

import numpy as np
import sys


def flood(grid, flooded, i, j):
    if flooded[i][j]:
        return

    flooded[i][j] = True

    for offset_y, offset_x in ((-1, 0), (1, 0), (0, -1), (0, 1)):
        if i + offset_y >= 0 and i + offset_y < 128 and \
           j + offset_x >= 0 and j + offset_x < 128:
            if grid[i + offset_y][j + offset_x]:
                flood(grid, flooded, i + offset_y, j + offset_x)


def main():
    grid = [[square == '1' for square in line.strip()] for line in sys.stdin]
    flooded = np.zeros((128, 128), dtype=bool)

    regionCounter = 0

    for i in range(128):
        for j in range(128):
            if grid[i][j] and not flooded[i][j]:
                flood(grid, flooded, i, j)
                regionCounter += 1

    print(regionCounter)


if __name__ == '__main__':
    main()
