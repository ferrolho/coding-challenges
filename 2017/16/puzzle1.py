#!/usr/bin/python3

import sys


def main():
    programs = list('abcdefghijklmnop')
    dance = sys.stdin.readline().strip().split(',')

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

    print(''.join(programs))


if __name__ == '__main__':
    main()
