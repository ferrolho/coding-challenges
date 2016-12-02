#!/usr/bin/python3

import sys

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def updateDirection(letter):
	global orientation

	if   letter == 'R': orientation += 1
	elif letter == 'L': orientation -= 1

	orientation %= 4

def walk(amount):
	if   orientation == 0: coord[1] -= amount
	elif orientation == 1: coord[0] += amount
	elif orientation == 2: coord[1] += amount
	elif orientation == 3: coord[0] -= amount

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

instructions = sys.stdin.readline()
instructions = instructions.strip().split(', ')

# 0 - north, 1 - east, 2 - south, 3 - west
orientation = 0
coord = [0, 0]

for instruction in instructions:
	turn, amount = instruction[0], int(instruction[1:])
	updateDirection(turn)
	walk(amount)

print(sum(abs(i) for i in coord))
