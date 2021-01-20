#!/usr/bin/python3

import sys


def main():
    counterValid = 0
    counterInvalid = 0

    for line in sys.stdin:
        tokens = line.strip().split()

        if len(tokens) != len(set(tokens)):
            counterInvalid += 1
        else:
            counterValid += 1

    print("Valid:", counterValid)
    print("Invalid:", counterInvalid)


if __name__ == '__main__':
    main()
