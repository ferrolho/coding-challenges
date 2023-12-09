# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    a = None
    b = None
    prev = None

    def traverse(self, node):
        if node == None:
            return

        self.traverse(node.left)

        if self.prev != None and self.prev.val >= node.val:
            if self.a == None:
                self.a = self.prev
            if self.a != None:
                self.b = node
        self.prev = node

        self.traverse(node.right)

    def recoverTree(self, root: Optional[TreeNode]) -> None:
        self.traverse(root)
        self.a.val, self.b.val = self.b.val, self.a.val
