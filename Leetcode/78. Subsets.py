class Solution:
    def subsets(self, nums: List[int]) -> List[List[int]]:
        answer = [[]]
        for num in nums:
            num_sets = len(answer)
            for i in range(num_sets):
                new_set = answer[i] + [num]
                answer.append(new_set)
        return answer
