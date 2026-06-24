class Solution:
    def subarraysWithKDistinct(self, nums: List[int], k: int) -> int:
        def atMost(k):
            """Return the number of subarrays with at most k distinct integers."""
            answer = 0
            left, window = 0, {}
            for right, r_num in enumerate(nums):
                # add new element to window
                window[r_num] = window.get(r_num, 0) + 1
                while len(window) > k:
                    # remove element from window
                    l_num = nums[left]
                    window[l_num] -= 1
                    if window[l_num] == 0:
                        del window[l_num]
                    left += 1  # advance left pointer
                answer += right - left + 1
            return answer

        return atMost(k) - atMost(k - 1)
