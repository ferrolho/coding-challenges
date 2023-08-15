#!/usr/bin/python3

import sys

flatten = lambda l: [item for sublist in l for item in sublist]


class Particle():
    def __init__(self, pos_x, pos_y, pos_z, vel_x, vel_y, vel_z, acc_x, acc_y, acc_z):
        self.pos_x = pos_x
        self.pos_y = pos_y
        self.pos_z = pos_z

        self.vel_x = vel_x
        self.vel_y = vel_y
        self.vel_z = vel_z

        self.acc_x = acc_x
        self.acc_y = acc_y
        self.acc_z = acc_z

    def update(self):
        self.vel_x += self.acc_x
        self.vel_y += self.acc_y
        self.vel_z += self.acc_z

        self.pos_x += self.vel_x
        self.pos_y += self.vel_y
        self.pos_z += self.vel_z

    def distanceToOrigin(self):
        return abs(self.pos_x) + abs(self.pos_y) + abs(self.pos_z)


def main():
    particles = [[[int(value)
                   for value in token[3:-1].split(',')]
                  for token in line.strip().split(', ')]
                 for line in sys.stdin.readlines()]

    particles = [Particle(*flatten(particle)) for particle in particles]

    for i in range(int(1e3)):
        for particle in particles:
            particle.update()

    distances = [particle.distanceToOrigin() for particle in particles]
    print(distances.index(min(distances)))


if __name__ == '__main__':
    main()
