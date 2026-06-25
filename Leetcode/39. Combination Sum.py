class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        answer = []  # answer with all combinations

        combination = []

        def backtrack(start=0, total=0):
            if total == target:  # found a valid combination
                answer.append(combination[:])
                return
            if total > target:  # overshot
                return
            for i in range(start, len(candidates)):
                combination.append(candidates[i])
                total += candidates[i]
                backtrack(i, total)
                combination.pop()
                total -= candidates[i]

        backtrack()

        return answer
