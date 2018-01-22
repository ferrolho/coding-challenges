#!/usr/bin/python3

import math
import numpy as np
import sys

GRID_SIZE = 10001


def main():
    grid = np.zeros((GRID_SIZE, GRID_SIZE), dtype=int)
    map = [list(line.strip()) for line in sys.stdin.readlines()]

    for i in range(len(map)):
        for j in range(len(map[i])):
            grid[int(GRID_SIZE / 2 - len(map) / 2) + i][int(GRID_SIZE / 2 - len(map[i]) / 2) + j] = map[i][j] == '#'

    p_i = p_j = int(GRID_SIZE / 2)
    direction = math.pi

    infection_counter = 0

    for i in range(10000):
        direction += -math.pi / 2 if grid[p_i][p_j] else math.pi / 2

        grid[p_i][p_j] = not grid[p_i][p_j]

        if grid[p_i][p_j]:
            infection_counter += 1

        p_i += int(math.cos(direction))
        p_j += int(math.sin(direction))

    print(infection_counter)


if __name__ == '__main__':
    main()
