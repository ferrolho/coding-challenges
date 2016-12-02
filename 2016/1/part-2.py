#!/usr/bin/python3

import sys

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def updateDirection(letter):
	global orientation

	if   letter == 'R': orientation += 1
	elif letter == 'L': orientation -= 1

	orientation %= 4

def walk(amount):
	global done

	axis  = ~ orientation % 2
	start = coord[axis]
	step  = 1 if orientation in (1, 2) else -1

	if   orientation == 0: coord[axis] -= amount
	elif orientation == 1: coord[axis] += amount
	elif orientation == 2: coord[axis] += amount
	elif orientation == 3: coord[axis] -= amount

	for i in range(start, coord[axis], step):
		temp_coord = None

		if   axis == 0: temp_coord = (i, coord[1])
		elif axis == 1: temp_coord = (coord[0], i)

		if temp_coord in visited:
			done = True
			return temp_coord
		
		visited.add(temp_coord)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

instructions = sys.stdin.readline()
instructions = instructions.strip().split(', ')

# 0 - north, 1 - east, 2 - south, 3 - west
orientation = 0
coord = [0, 0]

easterBunnyHQ = None
done = False
visited = set()

for instruction in instructions:
	if done: break

	turn, amount = instruction[0], int(instruction[1:])
	updateDirection(turn)
	easterBunnyHQ = walk(amount)

print(sum(abs(i) for i in easterBunnyHQ))
