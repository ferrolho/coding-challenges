#!/usr/bin/python3

import numpy as np
import sys


VELOCITIES = [[1, 0], [0, 1], [-1, 0], [0, -1]]


def main():
    for line in sys.stdin:
        distance = int(line.strip())

        position = np.array([0, 0])
        velocityIndex = 0

        counter = 1

        for steps in [i for i in range(1, 1000) for _ in range(2)]:
            for i in range(steps):
                position += VELOCITIES[velocityIndex]
                counter += 1

                # print(counter, position, sum(np.absolute(position)))
                if counter == distance:
                    break

            velocityIndex = (velocityIndex + 1) % 4
            if counter == distance:
                break

        print(counter, position, sum(np.absolute(position)))


if __name__ == '__main__':
    main()
