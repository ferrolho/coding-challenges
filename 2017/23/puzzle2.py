#!/usr/bin/python3


def main():
    h = 0

    for b in range(108100, 125100 + 1, 17):
        for d in range(2, b):
            if (b % d == 0):
                h += 1
                break

    print(h)


if __name__ == '__main__':
    main()
