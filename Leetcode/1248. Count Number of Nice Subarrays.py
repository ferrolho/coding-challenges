class Solution:
    def numberOfSubarrays(self, nums: List[int], k: int) -> int:
        answer = 0  # number of nice sub-arrays
        l_ptr, odds = 0, 0
        valid_starts = 0
        for (r_ptr, num) in enumerate(nums):
            if nums[r_ptr] % 2 == 1:
                valid_starts = 0
                odds += 1
            while odds >= k:
                valid_starts += 1
                if nums[l_ptr] % 2 == 1:
                    odds -= 1
                l_ptr += 1
            answer += valid_starts
        return answer
