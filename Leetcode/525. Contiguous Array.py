class Solution:
    def findMaxLength(self, nums: List[int]) -> int:
        answer = 0
        total, total_to_index = 0, {0: -1}
        for i, num in enumerate(nums):
            total += 1 if num == 1 else -1
            if total in total_to_index:
                answer = max(answer, i - total_to_index[total])
            else:
                total_to_index[total] = i
        return answer
