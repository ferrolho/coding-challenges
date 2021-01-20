#!/usr/bin/python3

import sys


def id_diff(id1, id2):
    """
    Returns difference metric between two IDs:
      0: IDs are exactly the same
      1: IDs only differ by one char
      2: IDs differ by one char or more
    """
    diff = 0

    for i in range(len(id1)):
        if id1[i] is not id2[i]:
            diff += 1

        if diff >= 2:
            break

    return diff


def main():
    list_of_ids = [line.strip() for line in sys.stdin]

    done = False

    for i in range(len(list_of_ids)):
        id1 = list_of_ids[i]

        for j in range(i + 1, len(list_of_ids)):
            id2 = list_of_ids[j]

            if id_diff(id1, id2) == 1:
                print(id1)
                print(id2)
                done = True
                break

        if done:
            break


if __name__ == '__main__':
    main()
