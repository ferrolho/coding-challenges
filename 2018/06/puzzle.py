#!/usr/bin/python3

import numpy as np
import sys
from time import sleep

grid = None
points = None
flood_queue = set()


def manhattan(p1, p2):
    return abs(p1[0] - p2[0]) + abs(p1[1] - p2[1])


def flood_aux(id, i, j):
    flood_queue.add((id, i - 1, j))
    flood_queue.add((id, i + 1, j))
    flood_queue.add((id, i, j - 1))
    flood_queue.add((id, i, j + 1))


def flood(id, i, j):
    if i < 0 or i >= len(grid) or \
       j < 0 or j >= len(grid[i]):
        return

    if grid[i][j] == id:
        return

    # Unclaimed territory
    if grid[i][j] == 0:
        grid[i][j] = id
        flood_aux(id, i, j)
        return

    # Fight for claimed territory
    if grid[i][j] > 0:
        other_id = grid[i][j]

        this_dist = manhattan([i, j], points[id - 1])
        other_dist = manhattan([i, j], points[other_id - 1])

        # Same distance: nobody gets it
        if this_dist == other_dist:
            grid[i][j] = -this_dist
            return

        # This distance is shorter: claim it
        if this_dist < other_dist:
            grid[i][j] = id
            flood_aux(id, i, j)
            return

    # Negative means previously disputed cell
    if grid[i][j] < 0:
        this_dist = manhattan([i, j], points[id - 1])
        prev_dist = -grid[i][j]

        if this_dist < prev_dist:
            grid[i][j] = id
            flood_aux(id, i, j)
            return


def main():
    global grid, points

    points = np.array([[int(i) for i in line.strip().split(', ')]
                       for line in sys.stdin])

    grid = np.zeros((max(points[:, 0]) + 1,
                     max(points[:, 1]) + 1), dtype=int)

    for id, p in enumerate(points):
        flood(id + 1, p[0], p[1])

    while len(flood_queue) != 0:
        flood(*flood_queue.pop())

    # print(grid.T)

    infinites = set()
    infinites |= set(np.unique(grid[:, 0]))
    infinites |= set(np.unique(grid[:, -1]))
    infinites |= set(np.unique(grid[0, :]))
    infinites |= set(np.unique(grid[-1, :]))

    candidate_ids = set(range(1, len(points) + 1)) - infinites
    # print(candidate_ids)

    areas = [np.count_nonzero(grid == id) for id in candidate_ids]
    print('Part 1:', max(areas))

    safety = np.array([sum([manhattan([i, j], p) for p in points])
                       for i in range(len(grid))
                       for j in range(len(grid[i]))])
    print('Part 2:', sum(safety < 10000))


if __name__ == '__main__':
    main()
