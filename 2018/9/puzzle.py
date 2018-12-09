#!/usr/bin/python3

import collections
import numpy as np
import re
import sys


class Node:
    """ Circular doubly linked list node. """

    def __init__(self, cargo, root=False):
        self.cargo = cargo
        self.root = root
        self._left = self
        self._right = self

    def insert_right(self, node):
        rightmost = self._right

        self._right = node
        rightmost._left = node

        node._left = self
        node._right = rightmost

        return node

    def delete(self):
        """
        Removes node from cdll.
        Returns node to the right of the removed node.
        """
        left = self._left
        right = self._right

        right._left = left
        left._right = right

        if self.root:
            right.root = True

        return right

    def flatten(self):
        node = self
        while not node.root:
            node = node._right

        cargos = [node.cargo]
        node = node._right

        while not node.root:
            cargos.append(node.cargo)
            node = node._right

        return np.array(cargos)


INPUT_FORMAT = r'(\w+) players; last marble is worth (\w+) points'


def main():
    for line in sys.stdin:
        players, last_marble = map(int, re.search(INPUT_FORMAT, line).groups())

        current = Node(0, True)
        scoreboard = collections.defaultdict(int)

        for i in range(last_marble):
            player = i % players + 1
            marble_value = i + 1

            if marble_value % 23 == 0:
                for _ in range(7):
                    current = current._left

                scoreboard[player] += marble_value + current.cargo

                # print('Player {} scored {} ({} + {})'.format(player,
                #                                              marble_value + current.cargo,
                #                                              marble_value, current.cargo))

                current = current.delete()
            else:
                current = current._right
                current = current.insert_right(Node(marble_value))

            # print('{}: {} ({})'.format(
            #     player, current.flatten(), marble_value))

        print('{} => {}'.format(line.strip(), max(scoreboard.values())))


if __name__ == '__main__':
    main()
