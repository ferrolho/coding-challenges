class Solution:
    def smallestEqual(self, nums: List[int]) -> int:
        for i, val in enumerate(nums):
            if i % 10 == val:
                return i
        return -1
