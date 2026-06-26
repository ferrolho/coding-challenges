# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def swapPairsRecursive(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if head is None or head.next is None:
            return head

        a = head
        b = head.next
        a.next = self.swapPairsRecursive(b.next)
        b.next = a

        return b

    def swapPairsIterative(self, head: Optional[ListNode]) -> Optional[ListNode]:
        dummy = ListNode(0, head)

        prev = dummy
        while prev.next and prev.next.next:
            # START = prev -> a -> b -> rest
            a, b, rest = prev.next, prev.next.next, prev.next.next.next

            # FINAL = prev -> b -> a -> rest
            a.next = rest  # a -> rest
            b.next = a     # b -> a
            prev.next = b  # prev -> b

            # advance `prev` by two nodes
            prev = a

        return dummy.next
