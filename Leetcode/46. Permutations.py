class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        permutations = []

        candidate = []  # permutation candidate
        used = [False] * len(nums)

        def extend_candidate():
            if len(candidate) == len(nums):
                permutations.append(candidate[:])
                return
            for i, num in enumerate(nums):
                if not used[i]:
                    used[i] = True
                    candidate.append(num)
                    extend_candidate()
                    candidate.pop()
                    used[i] = False

        extend_candidate()

        return permutations
