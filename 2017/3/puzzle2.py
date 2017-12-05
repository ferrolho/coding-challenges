#!/usr/bin/python3

import numpy as np
import sys


VELOCITIES = [[1, 0], [0, 1], [-1, 0], [0, -1]]


def sumOfNeighbours(gridMap, x, y):
    sum = 0
    for i in range(-1, 2):
        for j in range(-1, 2):
            if (x + i, y + j) in gridMap:
                sum += gridMap[(x + i, y + j)]
    return sum


def main():
    gridMap = {}
    gridMap[(0, 0)] = 1

    for line in sys.stdin:
        distance = int(line.strip())

        position = np.array([0, 0])
        velocityIndex = 0

        done = False

        for steps in [i for i in range(1, 1000) for _ in range(2)]:
            for i in range(steps):
                position += VELOCITIES[velocityIndex]
                sum = sumOfNeighbours(gridMap, position[0], position[1])
                gridMap[(position[0], position[1])] = sum

                print(position, "<-", sum)
                if sum > distance:
                    done = True
                    break

            velocityIndex = (velocityIndex + 1) % 4
            if done:
                break

        print()
        print("  Answer:", gridMap[(position[0], position[1])])
        print()


if __name__ == '__main__':
    main()
