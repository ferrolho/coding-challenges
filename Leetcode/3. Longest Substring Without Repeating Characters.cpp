#include <algorithm>
#include <iostream>
#include <unordered_set>
using namespace std;

class Solution
{
public:
    int lengthOfLongestSubstring(string s)
    {
        unordered_set<char> myset;

        int max_so_far = 0;
        int start_pos = 0;

        for (size_t i = 0; i < s.size(); ++i)
        {
            if (myset.count(s[i])) // char is already in set
            {
                // find previous position of repeated char
                int pos = s.find(s[i], start_pos);

                // remove all chars from set until that point
                for (size_t j = start_pos; j < pos; j++)
                {
                    myset.erase(s[j]);
                }

                // update start position of current candidate
                start_pos = pos + 1;
            }

            myset.insert(s[i]);

            // save max size given the current substring
            max_so_far = max(max_so_far, (int)myset.size());
        }

        return max_so_far;
    }
};
