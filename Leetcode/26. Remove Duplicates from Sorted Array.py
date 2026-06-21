class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        write_ptr, read_ptr = 1, 1  # skip the first element
        while read_ptr < len(nums):
            if nums[read_ptr] != nums[write_ptr - 1]:
                nums[write_ptr] = nums[read_ptr]
                write_ptr += 1
            read_ptr += 1
        return write_ptr
