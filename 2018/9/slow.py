#!/usr/bin/python3

import collections
import numpy as np
import re
import sys

INPUT_FORMAT = r'(\w+) players; last marble is worth (\w+) points'


def main():
    for line in sys.stdin:
        players, last_marble = map(int, re.search(INPUT_FORMAT, line).groups())

        current = 1
        marbles = np.array([0, 1])
        scoreboard = collections.defaultdict(int)

        for i in range(1, last_marble):
            player = i % players + 1
            marble_value = i + 1

            if marble_value % 23 == 0:
                current = (current - 7) % len(marbles)
                scoreboard[player] += marble_value + marbles[current]
                # print('Player {} scored {} ({} + {})'.format(player,
                #                                              marble_value + marbles[current],
                #                                              marble_value, marbles[current]))
                marbles = np.delete(marbles, current)
            else:
                current += 2
                if current > len(marbles):
                    current %= len(marbles)
                marbles = np.insert(marbles, current, marble_value)

                # print('{}: {} ({}) next at: {} actual: {}'.format(
                #     player, marbles, marbles[aux], aux+2, current))

            if (i % 0.5e5 == 0):
                print('\r{:.2f}% done'.format(i * 100 / last_marble))
        # print(marbles)

        print(max(scoreboard.values()))
        # break

    # print('Part 1:', root.checksum())
    # print('Part 2:', root.value())


if __name__ == '__main__':
    main()
