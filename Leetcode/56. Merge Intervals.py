class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals.sort()  # O(n log n) time, O(n) space
        merged = []  # O(n) space (worst-case includes all intervals)
        for interval in intervals:  # O(n) time
            if not merged or merged[-1][1] < interval[0]:
                merged.append(interval)
            elif merged[-1][1] < interval[1]:
                merged[-1][1] = interval[1]
        return merged
