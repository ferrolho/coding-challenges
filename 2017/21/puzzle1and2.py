#!/usr/bin/python3

import numpy as np
import sys


def flip(pattern):
    return '/'.join(pattern.split('/')[::-1])


def rotate(pattern):
    return '/'.join(''.join(elem) for elem in zip(*pattern.split('/')[::-1]))


def prettyPrint(pattern):
    for row in pattern.split('/'):
        print(row)


def splitPattern(pattern, squareSize):
    grid = np.array([list(row) for row in pattern.split('/')])
    num_splits = len(grid) / squareSize
    sub_grids = [np.hsplit(row, num_splits) for row in np.split(grid, num_splits)]
    return [['/'.join([''.join(x) for x in square]) for square in row] for row in sub_grids]


def expand(square, rules):
    # Try all 4 possible rotations
    for i in range(4):
        if square in rules:
            return rules[square]
        square = rotate(square)

    # Flip pattern
    square = flip(square)

    # Try all 4 possible *flipped* rotations
    for i in range(4):
        if square in rules:
            return rules[square]
        square = rotate(square)


def mergePatterns(squares):
    struct = [[row.split('/') for row in square] for square in squares]

    result = ''

    for row in struct:
        while row[0]:
            for square in row:
                result += square.pop(0)
            result += '/'

    return result[:-1]


def main():
    rules = {key: value for (key, value) in [rule.strip().split(' => ') for rule in sys.stdin.readlines()]}

    pattern = '.#./..#/###'
    prettyPrint(pattern)
    print()

    # for i in range(5):
    for i in range(18):
        squares = splitPattern(pattern, 2 if len(pattern.split('/')) % 2 == 0 else 3)
        squares = [[expand(square, rules) for square in row] for row in squares]
        pattern = mergePatterns(squares)
        # prettyPrint(pattern)
        # print()

    print(pattern.count('#'))


if __name__ == '__main__':
    main()
