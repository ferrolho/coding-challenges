#!/usr/bin/python3

import sys


def main():
    for line in sys.stdin:
        seenStates = set()

        counter = 0
        state = [int(blocks) for blocks in line.strip().split()]
        print(state)

        seenCounter = 0

        while seenCounter < 2:
            maxBankIndex = state.index(max(state))
            blocks = state[maxBankIndex]
            state[maxBankIndex] = 0

            while (blocks):
                maxBankIndex = (maxBankIndex + 1) % len(state)
                state[maxBankIndex] += 1
                blocks -= 1

            counter += 1

            if tuple(state) in seenStates:
                print(counter)
                seenStates.clear()
                seenCounter += 1
                counter = 0

            seenStates.add(tuple(state))


if __name__ == '__main__':
    main()
