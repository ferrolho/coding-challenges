#!/usr/bin/python3

import numpy as np
import re
import sys


def main():
    fabric = np.zeros((1000, 1000), dtype=int)

    for line in sys.stdin:
        _, margin_left, margin_top, width, height = tuple(
            map(int, re.search(r'#(\w+) @ (\w+),(\w+): (\w+)x(\w+)', line).groups()))

        fabric[margin_top:margin_top + height,
               margin_left:margin_left + width] += 1

    print((fabric >= 2).sum())


if __name__ == '__main__':
    main()
