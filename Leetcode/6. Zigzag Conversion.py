import numpy as np


class Solution:
    def convert(self, s: str, numRows: int) -> str:
        if numRows == 1:
            return s

        ZIG = np.array([1, 0])
        ZAG = np.array([-1, 1])

        charar = np.full((numRows, 1000), " ", dtype=str)

        pos = np.array([0, 0])
        vel = ZIG

        for c in s:
            charar[tuple(pos)] = c
            if np.array_equal(vel, ZIG) and pos[0] + 1 == numRows or \
               np.array_equal(vel, ZAG) and pos[0] == 0:
                vel = ZIG if np.array_equal(vel, ZAG) else ZAG
            pos += vel

        print(charar)

        result = "".join(str(c) for row in charar for c in row if c != " ")

        return result
