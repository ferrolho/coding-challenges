#!/usr/bin/python3

import numpy as np

STEPS = 12317297
TAPE_SIZE = 25000000


def main():
    pos = 0
    state = 'a'
    tape = np.zeros(TAPE_SIZE, dtype=int)

    for _ in range(STEPS):
        if state == 'a':
            if tape[pos] == 0:
                tape[pos] = 1
                pos = (pos + 1) % TAPE_SIZE
                state = 'b'
            elif tape[pos] == 1:
                tape[pos] = 0
                pos = (pos - 1) % TAPE_SIZE
                state = 'd'

        elif state == 'b':
            if tape[pos] == 0:
                tape[pos] = 1
                pos = (pos + 1) % TAPE_SIZE
                state = 'c'
            elif tape[pos] == 1:
                tape[pos] = 0
                pos = (pos + 1) % TAPE_SIZE
                state = 'f'

        elif state == 'c':
            if tape[pos] == 0:
                tape[pos] = 1
                pos = (pos - 1) % TAPE_SIZE
                state = 'c'
            elif tape[pos] == 1:
                tape[pos] = 1
                pos = (pos - 1) % TAPE_SIZE
                state = 'a'

        elif state == 'd':
            if tape[pos] == 0:
                tape[pos] = 0
                pos = (pos - 1) % TAPE_SIZE
                state = 'e'
            elif tape[pos] == 1:
                tape[pos] = 1
                pos = (pos + 1) % TAPE_SIZE
                state = 'a'

        elif state == 'e':
            if tape[pos] == 0:
                tape[pos] = 1
                pos = (pos - 1) % TAPE_SIZE
                state = 'a'
            elif tape[pos] == 1:
                tape[pos] = 0
                pos = (pos + 1) % TAPE_SIZE
                state = 'b'

        elif state == 'f':
            if tape[pos] == 0:
                tape[pos] = 0
                pos = (pos + 1) % TAPE_SIZE
                state = 'c'
            elif tape[pos] == 1:
                tape[pos] = 0
                pos = (pos + 1) % TAPE_SIZE
                state = 'e'

    print(sum(tape))


if __name__ == '__main__':
    main()
