#!/usr/bin/python3

import operator
import sys

ops = {'add': operator.add, 'mod': operator.mod, 'mul': operator.mul}


def main():
    instructions = [instruction.strip() for instruction in sys.stdin.readlines()]

    current = 0
    lastFreq = None
    regs = {}

    while 0 <= current and current < len(instructions):
        cmd, x, *y = instructions[current].split()
        if y: y = y[0]

        if cmd == 'snd':
            lastFreq = regs[x]

        elif cmd == 'set':
            regs[x] = int(y) if y.lstrip('-').isdigit() else regs[y]

        elif cmd in ops.keys():
            regs[x] = ops[cmd](regs[x] if x in regs else 0, int(y) if y.lstrip('-').isdigit() else regs[y])

        elif cmd == 'rcv':
            if x != 0:
                print(lastFreq)
                break

        elif cmd == 'jgz':
            if x.lstrip('-').isdigit() > 0 or regs[x] > 0:
                current += (int(y) if y.lstrip('-').isdigit() else regs[y]) - 1

        current += 1


if __name__ == '__main__':
    main()
