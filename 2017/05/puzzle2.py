#!/usr/bin/python3

import sys


def main():
    instructions = [int(jump.strip()) for jump in sys.stdin]
    current = 0
    counter = 0

    while 0 <= current and current < len(instructions):
        currentAux = current
        current += instructions[current]
        if instructions[currentAux] >= 3:
            instructions[currentAux] -= 1
        else:
            instructions[currentAux] += 1
        counter += 1

    print("  Steps taken until exit:", counter)


if __name__ == '__main__':
    main()
