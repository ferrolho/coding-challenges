class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        write_ptr, read_ptr = 0, 0
        while read_ptr < len(nums):
            if nums[read_ptr] != val:
                nums[write_ptr] = nums[read_ptr]
                write_ptr += 1
            read_ptr += 1
        return write_ptr
