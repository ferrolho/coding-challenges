class Solution:
    def ttos(self, t) -> str:
        return f"{t[0]}->{t[1]}" if t[0] != t[1] else f"{t[0]}"

    def summaryRanges(self, nums: List[int]) -> List[str]:
        ranges = []
        i = 0
        while i < len(nums):
            j = i
            while j + 1 < len(nums) and nums[j + 1] == nums[j] + 1:
                j += 1
            ranges.append((nums[i], nums[j]))
            i = j + 1
        return map(self.ttos, ranges)
