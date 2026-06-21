class Solution:
    def isItPossible(self, word1: str, word2: str) -> bool:
        alphabet = [chr(ord('a') + i) for i in range(26)]

        d1 = {c: word1.count(c) for c in alphabet}
        d2 = {c: word2.count(c) for c in alphabet}

        s1 = {ch for ch, n in d1.items() if n > 0}
        s2 = {ch for ch, n in d2.items() if n > 0}

        def swap(c1, c2) -> bool:
            # remove from source
            d1[c1] -= 1
            d2[c2] -= 1
            # add to destination
            d1[c2] += 1
            d2[c1] += 1

        def found():
            sum1 = sum(n > 0 for n in d1.values())
            sum2 = sum(n > 0 for n in d2.values())
            return sum1 == sum2

        for c1 in s1:
            for c2 in s2:
                swap(c1, c2)  # try swap
                if found():
                    return True
                swap(c2, c1)  # swap back
        return False
