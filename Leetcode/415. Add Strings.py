class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        result, carry = [], 0
        i, j = len(num1) - 1, len(num2) - 1
        while i >= 0 or j >= 0 or carry:
            d1 = ord(num1[i]) - ord("0") if i >= 0 else 0
            d2 = ord(num2[j]) - ord("0") if j >= 0 else 0
            total = d1 + d2 + carry
            carry, digit = divmod(total, 10)
            result.append(chr(ord("0") + digit))
            i -= 1
            j -= 1
        return "".join(reversed(result))
