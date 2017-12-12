#!/usr/bin/python3

import numpy as np
import sys

cubeDirections = {
    'se': (+1, -1, 0), 'ne': (+1, 0, -1), 'n': (0, +1, -1),
    'nw': (-1, +1, 0), 'sw': (-1, 0, +1), 's': (0, -1, +1)
}


def cubeDistance(a, b):
    return int((abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])) / 2)


def main():
    for line in sys.stdin:
        position = (0, 0, 0)
        steps = [dir for dir in line.strip().split(',')]
        maximumDistance = 0

        for step in steps:
            position = np.add(position, cubeDirections[step])
            currentDistance = cubeDistance((0, 0, 0), position)

            if currentDistance > maximumDistance:
                maximumDistance = currentDistance

        print('Current distance:', cubeDistance((0, 0, 0), position))
        print('Maximum distance:', maximumDistance)


if __name__ == '__main__':
    main()
