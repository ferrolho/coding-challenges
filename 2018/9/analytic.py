#!/usr/bin/python3

from itertools import cycle
import collections
import numpy as np
import re
import sys

INPUT_FORMAT = r'(\w+) players; last marble is worth (\w+) points'
MULTIPLE = 23


def scoring_order(num_players):
    players = []
    current_round = 0
    marbles_counter = 1

    while len(players) != num_players:
        player = current_round % num_players + 1

        if (current_round + 1) % MULTIPLE == 0:
            marbles_counter -= 1
            players.append(player)
        else:
            marbles_counter += 1

        current_round += 1

    return players


def main():
    for line in sys.stdin:
        num_players, last_marble = map(
            int, re.search(INPUT_FORMAT, line).groups())

        players_scoring_order = cycle(scoring_order(num_players))
        game_rounds = round(last_marble / MULTIPLE) + 1

        scoreboard = collections.defaultdict(int)

        for i in np.arange(1, game_rounds):
            player = next(players_scoring_order)

            scoreboard[player] += i * MULTIPLE + 0

            print('Player {:3d} scored {:5d} + {:5d} = {:5d}'.format(
                player, i * MULTIPLE, 0, i * MULTIPLE + 0))

        print(max(scoreboard.values()))


if __name__ == '__main__':
    main()
