#!/usr/bin/python3

import sys

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def buttonAt(coord):
	return keypad[coord[1]][coord[0]]

def validMove(x, y):
	return 0 <= x < 5 and 0 <= y < 5 and keypad[y][x]

def processLine(line):
	global code

	for move in line:
		if   move == 'L' and validMove(coord[0] - 1, coord[1]): coord[0] -= 1
		elif move == 'R' and validMove(coord[0] + 1, coord[1]): coord[0] += 1
		elif move == 'U' and validMove(coord[0], coord[1] - 1): coord[1] -= 1
		elif move == 'D' and validMove(coord[0], coord[1] + 1): coord[1] += 1

	code += buttonAt(coord)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

keypad = (
	( '',  '', '1',  '',  ''),
	( '', '2', '3', '4',  ''),
	('5', '6', '7', '8', '9'),
	( '', 'A', 'B', 'C',  ''),
	( '',  '', 'D',  '',  ''))

# start is the '5' button
coord = [0, 2]

code = ''

for line in sys.stdin:
	processLine(line)

print(code)
