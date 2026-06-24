class Solution:
    def minWindow(self, s: str, t: str) -> str:
        needed = {}
        for c in t:
            needed[c] = needed.get(c, 0) + 1

        # `formed` counts distinct chars satisfied
        required, formed = len(needed), 0

        best_left, best_len = 0, float("inf")

        window, left = {}, 0
        for right, rc in enumerate(s):
            window[rc] = window.get(rc, 0) + 1
            if rc in needed and window[rc] == needed[rc]:
                formed += 1
            while formed == required:
                current_len = right - left + 1
                if current_len < best_len:
                    best_left, best_len = left, current_len
                lc = s[left]
                window[lc] -= 1
                if lc in needed and window[lc] < needed[lc]:
                    formed -= 1
                left += 1

        return "" if best_len == float("inf") else s[best_left : best_left + best_len]
