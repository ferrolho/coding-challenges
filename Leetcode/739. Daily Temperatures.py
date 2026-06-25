class Solution:
    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
        days_until_warmer = [0] * len(temperatures)

        unresolved_days = []  # stack
        for index, temperature in enumerate(temperatures):
            while unresolved_days and unresolved_days[-1][0] < temperature:
                resolved_temperature, resolved_index = unresolved_days.pop()
                days_until_warmer[resolved_index] = index - resolved_index
            unresolved_days.append((temperature, index))

        return days_until_warmer
