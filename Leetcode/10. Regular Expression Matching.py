class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        memo = {}

        def matches(i: int, j: int) -> bool:
            if (i, j) in memo:
                return memo[(i, j)]

            if j == len(p):  # if we have reached the end of the pattern
                ans = i == len(s)  # success iff we also reached end of string
            else:
                first_matches = i < len(s) and p[j] in (s[i], ".")
                next_pattern_char_is_star = j + 1 < len(p) and p[j + 1] == "*"

                if next_pattern_char_is_star:
                    # skip "x*" in pattern, or consume one char and keep "x*"
                    ans = matches(i, j + 2) or (first_matches and matches(i + 1, j))
                else:
                    ans = first_matches and matches(i + 1, j + 1)

            memo[(i, j)] = ans
            return ans

        return matches(0, 0)
