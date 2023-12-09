# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def traverse(self, n1, n2) -> bool:
        if n1 == None and n2 == None:
            return True
        elif n1 == None or n2 == None:
            return False
        elif n1.val != n2.val:
            return False
        else:
            return self.traverse(n1.left, n2.left) and self.traverse(n1.right, n2.right)

    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
        return self.traverse(p, q)
