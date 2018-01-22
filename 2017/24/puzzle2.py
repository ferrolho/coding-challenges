#!/usr/bin/python3

import copy
import numpy as np
import sys

flatten = lambda l: [item for sublist in l for item in sublist]
strength = lambda bridge: sum([sum([int(port) for port in component.split('/')]) for component in bridge])

max_length = 0
max_strength = 0


class Bridge():
    def __init__(self, head):
        self.components = [head]
        self.tailPins = sum([int(port) for port in head.split('/')])


def dfs(bridge, components_available):
    global max_length, max_strength

    if not components_available or \
       bridge.tailPins not in np.unique(flatten([[int(pin) for pin in c.split('/')] for c in components_available])):
        if len(bridge.components) > max_length or \
           len(bridge.components) == max_length and strength(bridge.components) > max_strength:
            max_length = len(bridge.components)
            max_strength = strength(bridge.components)
            print(max_strength, bridge.components)
    else:
        for component in components_available:
            if bridge.tailPins in [int(port) for port in component.split('/')]:
                extension = copy.deepcopy(bridge)
                extension.components.append(component)
                extension.tailPins = sum([int(port) for port in component.split('/')]) - extension.tailPins
                dfs(extension, [c for c in components_available if c != component])


def main():
    components = [component.strip() for component in sys.stdin.readlines()]
    zeroPinPorts = [component for component in components if 0 in [int(port) for port in component.split('/')]]

    for zeroPinPort in zeroPinPorts:
        dfs(Bridge(zeroPinPort), [c for c in components if c != zeroPinPort])

    print(max_strength)


if __name__ == '__main__':
    main()
