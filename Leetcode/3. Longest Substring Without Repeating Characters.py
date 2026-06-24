class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        ptr_left, ptr_right = 0, 0
        window, max_len = set(), 0
        while ptr_right < len(s):
            while s[ptr_right] in window:
                window.remove(s[ptr_left])
                ptr_left += 1
            window.add(s[ptr_right])
            ptr_right += 1
            if len(window) > max_len:
                max_len = len(window)
        return max_len
