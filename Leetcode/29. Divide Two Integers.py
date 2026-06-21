class Solution:
    def divide(self, dividend: int, divisor: int) -> int:
        MIN, MAX = -2**31, 2**31 - 1

        if dividend == MIN and divisor == -1:
            return MAX
        
        negative = (dividend < 0) != (divisor < 0)
        a, b = abs(dividend), abs(divisor)

        quotient = 0

        while a >= b:
            chunk, count = b, 1

            while (chunk << 1) <= a:
                chunk <<= 1
                count <<= 1

            a -= chunk
            quotient += count

        return -quotient if negative else quotient
