#!/usr/bin/python3

import numpy as np
import re
import sys


def main():
    fabric = np.zeros((1000, 1000), dtype=int)
    candidates = set()

    for line in sys.stdin:
        claim_id, margin_left, margin_top, width, height = tuple(
            map(int, re.search(r'#(\w+) @ (\w+),(\w+): (\w+)x(\w+)', line).groups()))

        patch = fabric[margin_top:margin_top + height,
                       margin_left:margin_left + width]

        if patch.sum() == 0:
            candidates.add(claim_id)
        else:
            candidates -= set(np.unique(patch))

        fabric[margin_top:margin_top + height,
               margin_left:margin_left + width] = claim_id

    print(candidates)


if __name__ == '__main__':
    main()
