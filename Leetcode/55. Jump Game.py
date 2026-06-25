class Solution:
    def canJump(self, nums: List[int]) -> bool:
        furthest = 0
        for i, num in enumerate(nums):
            if i > furthest:
                return False
            furthest = max(furthest, i + num)
        return furthest >= len(nums) - 1
