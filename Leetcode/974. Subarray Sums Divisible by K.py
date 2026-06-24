class Solution:
    def subarraysDivByK(self, nums: List[int], k: int) -> int:
        answer = 0
        total, remainder_counts = 0, {0: 1}
        for num in nums:
            total += num
            rem = total % k
            answer += remainder_counts.get(rem, 0)
            remainder_counts[rem] = remainder_counts.get(rem, 0) + 1
        return answer
