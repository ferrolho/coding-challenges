#!/usr/bin/python3

import collections
import re
import sys


def main():
    tree = collections.defaultdict(set)
    tree_inv = collections.defaultdict(set)
    available = set()
    instructions = ''

    for line in sys.stdin:
        step, next_step = re.search(
            r'Step (.) must be finished before step (.) can begin.', line).groups()
        tree[step].add(next_step)
        tree_inv[next_step].add(step)

    # Finding the roots
    for _, children in tree_inv.items():
        for node in children:
            if node not in tree_inv.keys():
                available.add(node)

    while len(available) != 0:
        node = next(candidate for candidate in sorted(available)
                    if all(elem in instructions for elem in tree_inv[candidate]))

        instructions += node
        available.update(tree[node])
        available.remove(node)

    print('Part 1:', instructions)


if __name__ == '__main__':
    main()
