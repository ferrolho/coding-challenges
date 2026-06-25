class Solution:
    def rob(self, nums: List[int]) -> int:
        n = len(nums)

        # Let dp[i] = the maximum money you can
        # rob considering only houses 0 through i
        dp = [0] * n

        if n > 0:
            dp[0] = nums[0]

        if n > 1:
            dp[1] = max(nums[0], nums[1])

        for i in range(2, n):
            dp[i] = max(dp[i - 1], nums[i] + dp[i - 2])

        return dp[n - 1]
