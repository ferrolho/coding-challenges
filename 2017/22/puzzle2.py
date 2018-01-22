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
            if map[i][j] == '#':
                grid[int(GRID_SIZE / 2 - len(map) / 2) + i][int(GRID_SIZE / 2 - len(map[i]) / 2) + j] = 2

    p_i = p_j = int(GRID_SIZE / 2)
    direction = math.pi

    # Node states:
    # ------------
    # 0 - Clean
    # 1 - Weakened
    # 2 - Infected
    # 3 - Flagged

    infection_counter = 0

    for i in range(10000000):
        if grid[p_i][p_j] == 0:
            direction += math.pi / 2
        elif grid[p_i][p_j] == 2:
            direction -= math.pi / 2
        elif grid[p_i][p_j] == 3:
            direction += math.pi

        # Working around Float Point Arithmetic precision limitations...
        direction %= 2 * math.pi

        grid[p_i][p_j] = (grid[p_i][p_j] + 1) % 4

        if grid[p_i][p_j] == 2:
            infection_counter += 1

        p_i += int(math.cos(direction))
        p_j += int(math.sin(direction))

    print(infection_counter)


if __name__ == '__main__':
    main()
