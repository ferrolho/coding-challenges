#!/usr/bin/python3

import sys

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def buttonAt(coord):
	return keypad[coord[1]][coord[0]]

def clamp(minvalue, value, maxvalue):
	return max(minvalue, min(value, maxvalue))

def processLine(line):
	global code

	for move in line:
		if   move == 'L': coord[0] -= 1
		elif move == 'R': coord[0] += 1
		elif move == 'U': coord[1] -= 1
		elif move == 'D': coord[1] += 1

		coord[0] = clamp(0, coord[0], 2)
		coord[1] = clamp(0, coord[1], 2)

	code += buttonAt(coord)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

keypad = (('1', '2', '3'), ('4', '5', '6'), ('7', '8', '9'))

# start is the '5' button
coord = [1, 1]

code = ''

for line in sys.stdin:
	processLine(line)

print(code)
