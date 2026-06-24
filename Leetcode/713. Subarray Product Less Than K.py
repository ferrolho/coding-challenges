class Solution:
    def numSubarrayProductLessThanK(self, nums: List[int], k: int) -> int:
        if k <= 1:  # no positive product can be < 1
            return 0
        answer = 0
        left, product = 0, 1
        for right, num in enumerate(nums):
            product *= num
            while product >= k:
                product //= nums[left]  # shrink until window is valid again
                left += 1
            answer += right - left + 1  # count all subarrays ending at right
        return answer
