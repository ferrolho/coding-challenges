#!/usr/bin/python3

import operator
import sys

ops = {
    '<': operator.lt, '<=': operator.le,
    '==': operator.eq, '!=': operator.ne,
    '>=': operator.ge, '>': operator.gt
}


def main():
    registers = {}
    maximumObserved = 0

    for line in sys.stdin:
        instruction, condition = line.strip().split('if')

        register, sign, amount = instruction.split()
        lhs, op, rhs = condition.split()

        sign = +1 if sign == 'inc' else -1
        amount = int(amount)
        rhs = int(rhs)

        if register not in registers:
            registers[register] = 0
        if lhs not in registers:
            registers[lhs] = 0

        if ops[op](registers[lhs], rhs):
            registers[register] += sign * amount

        if registers[register] > maximumObserved:
            maximumObserved = registers[register]

    maximum = max(registers, key=registers.get)

    print('  Maximum at the end:', registers[maximum])
    print('    Maximum observed:', maximumObserved)


if __name__ == '__main__':
    main()
