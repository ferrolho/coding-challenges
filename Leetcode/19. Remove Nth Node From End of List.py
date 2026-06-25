# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        # allows `head` removal without a special case
        dummy = ListNode(0, head)

        follower, leader = dummy, dummy.next

        # move `leader` pointer `n` nodes ahead
        for _ in range(n):
            leader = leader.next

        # march lockstep to keep the gap fixed. when `leader`
        # hits the end, `follower` is just before the target
        while leader:
            leader = leader.next
            follower = follower.next

        # unlink the n-th-from-end node
        follower.next = follower.next.next

        # `head` may have been the unlinked node,
        # so we return the node after the dummy
        return dummy.next
