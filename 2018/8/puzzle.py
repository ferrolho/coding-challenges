#!/usr/bin/python3

import sys


class Node:
    def __init__(self):
        self.children = []
        self.metadata = []

    def checksum(self):
        return sum(self.metadata) + sum(node.checksum()
                                        for node in self.children)

    def value(self):
        return self.checksum() if len(self.children) == 0 \
            else sum(self.children[i-1].value()
                     for i in self.metadata
                     if i <= len(self.children))

    def to_string(self, level=0):
        return '{}{}\n'.format('\t'*level, self.metadata) + \
            ''.join(node.to_string(level + 1)
                    for node in self.children)


def parse_node(data):
    node = Node()

    num_children = next(data)
    num_metadata = next(data)

    for _ in range(num_children):
        node.children.append(parse_node(data))

    for _ in range(num_metadata):
        node.metadata.append(next(data))

    return node


def main():
    data = map(int, sys.stdin.readline().split())

    root = parse_node(data)
    # print(root.to_string())

    print('Part 1:', root.checksum())
    print('Part 2:', root.value())


if __name__ == '__main__':
    main()
