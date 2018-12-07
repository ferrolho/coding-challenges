#!/usr/bin/python3

import collections
import re
import sys

workers = 5
base_time = 60


def step_time(letter):
    return base_time + ord(letter) - ord('A') + 1


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

    ongoing = []
    counters = collections.defaultdict(int)
    iterations = 0

    while len(available) != 0:
        # Assign jobs to workers
        for candidate in sorted(available):
            if len(ongoing) >= workers:
                break
            elif candidate in ongoing:
                continue
            elif all(elem in instructions for elem in tree_inv[candidate]):
                ongoing.append(candidate)

        # print(iterations, end='\t')
        # for x in ongoing:
        #     print('{}: {}'.format(x, counters[x]), end='\t')
        # print()

        # Do work
        for step in reversed(ongoing):
            counters[step] += 1
            if counters[step] >= step_time(step):
                ongoing.remove(step)
                instructions += step
                available.update(tree[step])
                available.remove(step)

        # Count seconds
        iterations += 1

    print(instructions)
    print('Part 2:', iterations)


if __name__ == '__main__':
    main()
