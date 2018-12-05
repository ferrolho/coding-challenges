#!/usr/bin/python3

import numpy as np
import re
import sys


def main():
    data = sorted([line.strip() for line in sys.stdin])

    stats = {}
    guard_id, last_start = 0, 0

    for entry in data:
        _, _, _, _, minute, event = re.search(
            r'\[(\w+)-(\w+)-(\w+) (\w+):(\w+)\] (.*)', entry).groups()
        minute = int(minute)

        if event[0] == 'w':
            # 'wakes up'
            if guard_id not in stats:
                stats[guard_id] = np.zeros(60, dtype=int)
            stats[guard_id][last_start:minute] += 1
        elif event[0] == 'f':
            # 'falls asleep'
            last_start = minute
        else:
            guard_id = int(re.findall(r'\d+', event)[0])

    guard_id = max(stats.keys(), key=(lambda k: stats[k].sum()))
    print('Part 1: {}'.format(guard_id * np.argmax(stats[guard_id])))

    guard_id = max(stats.keys(), key=(lambda k: np.max(stats[k])))
    print('Part 2: {}'.format(guard_id * np.argmax(stats[guard_id])))


if __name__ == '__main__':
    main()
