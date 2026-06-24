class Solution:
    def subarraySum(self, nums: List[int], k: int) -> int:
        answer = 0  # number of subarrays that sum to k
        total, total_counts = 0, {0: 1}
        for num in nums:
            total += num
            answer += total_counts.get(total - k, 0)
            total_counts[total] = total_counts.get(total, 0) + 1
        return answer
