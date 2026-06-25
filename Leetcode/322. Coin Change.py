class Solution:
    def coinChange(self, coins: List[int], amount: int) -> int:
        # dp[a] gives the fewest number of coins required for amount a
        dp = [float("inf")] * (amount + 1)
        dp[0] = 0  # zero coins needed for zero amount
        for a in range(1, amount + 1):
            for c in coins:
                if c <= a:
                    # fewest coins for a is the minimum between
                    # 'current fewest' and '1 + fewest for a-c'
                    dp[a] = min(dp[a], dp[a - c] + 1)
        return dp[amount] if dp[amount] != float("inf") else -1
