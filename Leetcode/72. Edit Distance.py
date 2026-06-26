class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        m, n = len(word1), len(word2)

        # `dp[i][j]` gives the minimum number of operations
        # required to convert `word1[0:i]` to `word2[0:j]`
        dp = [[0] * (n + 1) for _ in range(m + 1)]

        # base cases. rows = deletion, columns = insertion
        for i in range(m + 1): dp[i][0] = i  # delete i chars
        for j in range(n + 1): dp[0][j] = j  # insert j chars

        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if word1[i - 1] == word2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1]  # match i.e. no operation needed
                else:
                    dp[i][j] = 1 + min(
                        dp[i - 1][j - 1],  # replace
                        dp[i - 1][j],  # delete
                        dp[i][j - 1],  # insert
                    )

        return dp[m][n]
