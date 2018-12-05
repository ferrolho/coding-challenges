#!/usr/bin/python3

import sys

def react(polymer):
    i, unstable = 0, True

    while unstable:
        if polymer[i] != polymer[i+1] and \
           polymer[i].lower() == polymer[i+1].lower():
            polymer = polymer[:i] + polymer[i+2:]
            i = max(0, i-1)
        else:
            i += 1

        unstable = i != len(polymer) - 1

    return polymer


def main():
    polymer = sys.stdin.readline()
    print('Part 1: {}'.format(len(react(polymer))))

    stats = {}
    units = ''.join(set(polymer.lower()))

    for c in units:
        res = polymer.replace(c, '').replace(c.upper(), '')
        stats[c] = len(react(res))

    print('Part 2: {}'.format(min(stats.values())))


if __name__ == '__main__':
    main()
