# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def addTwoNumbers(
        self, l1: Optional[ListNode], l2: Optional[ListNode]
    ) -> Optional[ListNode]:
        dummy = ListNode()
        current, carry = dummy, 0
        a, b = l1, l2
        while a or b or carry:
            d1 = a.val if a else 0
            d2 = b.val if b else 0
            total = d1 + d2 + carry
            carry, digit = divmod(total, 10)
            current.next = ListNode(digit)
            current = current.next
            # advance node pointers
            a = a.next if a else None
            b = b.next if b else None
        return dummy.next
