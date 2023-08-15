#!/usr/bin/python3

import sys

ONE_BILLION = 1000000000


def main():
    programs = list('abcdefghijklmnop')
    dance = sys.stdin.readline().strip().split(',')
    cache = {}

    for i in range(ONE_BILLION):
        programs_str = ''.join(programs)

        if programs_str in cache:
            programs = cache[programs_str]
        else:
            prev = programs_str

            for step in dance:
                if step[0] == 's':
                    x = int(step[1:])
                    programs = programs[-x:] + programs[:-x]
                elif step[0] == 'x':
                    pos_a, pos_b = [int(program) for program in step[1:].split('/')]
                    programs[pos_a], programs[pos_b] = programs[pos_b], programs[pos_a]
                elif step[0] == 'p':
                    a, b = [program for program in step[1:].split('/')]
                    pos_a, pos_b = programs.index(a), programs.index(b)
                    programs[pos_a], programs[pos_b] = programs[pos_b], programs[pos_a]

            cache[prev] = ''.join(programs)

        if i % 1e2 == 0:
            print('Progress: %.2f %% (%d/%d)' % (i * 100 / ONE_BILLION, i, ONE_BILLION), end='\r')

    print(''.join(programs))


if __name__ == '__main__':
    main()
