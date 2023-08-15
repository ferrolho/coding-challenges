#include <iostream>
#include <vector>
using namespace std;

// Definition for singly-linked list.
struct ListNode
{
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

class Solution
{
public:
    ListNode *addTwoNumbers(ListNode *l1, ListNode *l2, int carry = 0)
    {
        if (!l1 && !l2)
        {
            return carry == 0 ? nullptr : new ListNode(carry);
        }
        else if (!l1)
        {
            return carry == 0 ? l2 : addTwoNumbers(new ListNode(carry), l2);
        }
        else if (!l2)
        {
            return carry == 0 ? l1 : addTwoNumbers(new ListNode(carry), l1);
        }
        else
        {
            div_t dv = div(l1->val + l2->val + carry, 10);
            ListNode *next = addTwoNumbers(l1->next, l2->next, carry = dv.quot);
            return new ListNode(dv.rem, next);
        }
    }
};
