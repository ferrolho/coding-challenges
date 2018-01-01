#!/usr/bin/python3

import operator
import sys

ops = {'add': operator.add, 'mod': operator.mod, 'mul': operator.mul}


class Program:
    def __init__(self, id):
        self.current = 0
        self.counter_snd = 0
        self.out_queue = []
        self.regs = {'p': id}


def main():
    instructions = [instruction.strip() for instruction in sys.stdin.readlines()]

    programs = [Program(0), Program(1)]
    programs[0].inbox = programs[1].out_queue
    programs[1].inbox = programs[0].out_queue

    done = False

    while not done:
        waitCounter = 0

        for p in programs:
            cmd, x, *y = instructions[p.current].split()
            if y: y = y[0]

            if cmd == 'snd':
                p.counter_snd += 1
                p.out_queue.append(p.regs[x])

            elif cmd == 'set':
                p.regs[x] = int(y) if y.lstrip('-').isdigit() else p.regs[y]

            elif cmd in ops.keys():
                p.regs[x] = ops[cmd](p.regs[x] if x in p.regs else 0, int(y) if y.lstrip('-').isdigit() else p.regs[y])

            elif cmd == 'rcv':
                if p.inbox:
                    p.regs[x] = p.inbox.pop(0)
                else:
                    waitCounter += 1
                    p.current -= 1

            elif cmd == 'jgz':
                if x.lstrip('-').isdigit() > 0 or p.regs[x] > 0:
                    p.current += (int(y) if y.lstrip('-').isdigit() else p.regs[y]) - 1

            p.current += 1

        if waitCounter == 2:  # Deadlock
            done = True

    print(programs[1].counter_snd)


if __name__ == '__main__':
    main()
