#!/usr/bin/python3

from enum import Enum
import numpy as np
import operator
import sys


class Dir(Enum):
    LEFT = 1
    RIGHT = 2
    UP = 3
    DOWN = 4


VELOCITY = {Dir.LEFT: (0, -1), Dir.RIGHT: (0, 1), Dir.UP: (-1, 0), Dir.DOWN: (1, 0)}


def main():
    diagram = [list(line.strip('\n')) for line in sys.stdin.readlines()]

    pos, dir = (0, diagram[0].index('|')), Dir.DOWN
    path, steps = [], 0

    diagram = np.asarray(diagram)

    done = False
    while not done:

        if diagram[pos].isalpha():
            path.append(diagram[pos])

        elif diagram[pos] == '+':
            if dir in [Dir.UP, Dir.DOWN]:
                char = diagram[tuple(map(operator.add, pos, VELOCITY[Dir.LEFT]))]
                dir = Dir.LEFT if char == '-' or char.isalpha() else Dir.RIGHT
            elif dir in [Dir.LEFT, Dir.RIGHT]:
                char = diagram[tuple(map(operator.add, pos, VELOCITY[Dir.UP]))]
                dir = Dir.UP if char == '|' or char.isalpha() else Dir.DOWN

        elif diagram[pos] == ' ':
            done = True
            break

        # print(pos, path)
        pos = tuple(map(operator.add, pos, VELOCITY[dir]))
        steps += 1

    print('Path:', ''.join(path))
    print('Steps:', steps)


if __name__ == '__main__':
    main()
