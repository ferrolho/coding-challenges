#!/usr/bin/python3

import networkx as nx
import sys


def main():
    village = nx.Graph()

    for line in sys.stdin:
        node, neighbours = line.strip().split(' <-> ')

        node = int(node)
        neighbours = [int(x.strip()) for x in neighbours.split(',')]

        for neighbour in neighbours:
            village.add_edge(node, neighbour)

    print(nx.number_connected_components(village))


if __name__ == '__main__':
    main()
