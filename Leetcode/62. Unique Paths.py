class Solution:
    def uniquePaths(self, m: int, n: int) -> int:
        # `dp[i][j]` represents all unique paths for an `i x j` grid
        dp = [[1] * n for _ in range(m)]

        # at this point, all elements are 1, but only
        # the first row and the first column are correct

        for i in range(1, m):
            for j in range(1, n):
                dp[i][j] = dp[i - 1][j] + dp[i][j - 1]

        return dp[m - 1][n - 1]
