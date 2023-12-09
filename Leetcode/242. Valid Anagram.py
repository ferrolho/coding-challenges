class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        a = {c: s.count(c) for c in set(s)}
        b = {c: t.count(c) for c in set(t)}
        return a == b
