#!/usr/bin/python3

import collections
import sys


def main():
    twice_count = 0
    thrice_count = 0

    for line in sys.stdin:
        char_to_count = collections.defaultdict(int)

        for c in line:
            char_to_count[c] += 1

        set_id_char_count = set(char_to_count.values())

        # print(set_id_char_count)

        if 2 in set_id_char_count:
            twice_count += 1

        if 3 in set_id_char_count:
            thrice_count += 1

    print(twice_count * thrice_count)


if __name__ == '__main__':
    main()
