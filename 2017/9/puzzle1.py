#!/usr/bin/python3

from enum import Enum
import sys


class State(Enum):
    NOMINAL = 0
    GARBAGE = 1
    IGNORE = 2


def main():
    for line in sys.stdin:
        state = State.NOMINAL
        level = 0
        score = 0

        for char in line.strip():
            if state is State.NOMINAL:
                if char == '{':
                    level += 1
                elif char == '}':
                    score += level
                    level -= 1
                elif char == '<':
                    state = State.GARBAGE
            elif state is State.GARBAGE:
                if char == '>':
                    state = State.NOMINAL
                elif char == '!':
                    state = state.IGNORE
            elif state is State.IGNORE:
                state = State.GARBAGE

        print(score)


if __name__ == '__main__':
    main()
