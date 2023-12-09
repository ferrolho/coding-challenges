class Solution:
    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        M, N = len(nums1), len(nums2)
        total = M + N
        is_even = total % 2 == 0

        # number of items to be consumed
        n = total // 2
        if is_even:
            n -= 1

        idx1 = 0
        idx2 = 0

        while n > 0:
            # choose which array to consume from
            if idx1 >= M:
                idx2 += 1
            elif idx2 >= N or nums1[idx1] < nums2[idx2]:
                idx1 += 1
            else:
                idx2 += 1

            n -= 1  # decrease number of items to be consumed

        arr = []
        n = 2 if is_even else 1
        for i in range(n):
            if idx1 >= M:
                arr.append(nums2[idx2])
                idx2 += 1
            elif idx2 >= N or nums1[idx1] < nums2[idx2]:
                arr.append(nums1[idx1])
                idx1 += 1
            else:
                arr.append(nums2[idx2])
                idx2 += 1

        return sum(arr) / n
