class Solution:
    def addBinary(self, a: str, b: str) -> str:
        result, carry = [], 0
        i, j = len(a) - 1, len(b) - 1
        while i >= 0 or j >= 0 or carry:
            d1 = ord(a[i]) - ord("0") if i >= 0 else 0
            d2 = ord(b[j]) - ord("0") if j >= 0 else 0
            total = d1 + d2 + carry
            carry, digit = divmod(total, 2)
            result.append(chr(ord("0") + digit))
            i -= 1
            j -= 1
        return "".join(reversed(result))
