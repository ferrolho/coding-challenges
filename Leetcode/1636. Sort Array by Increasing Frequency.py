class Solution:
    def frequencySort(self, nums: List[int]) -> List[int]:
        num2freq = {}
        for num in nums:
            num2freq[num] = num2freq.get(num, 0) + 1
        return sorted(nums, key=lambda num: (num2freq[num], -num))
