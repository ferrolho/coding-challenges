# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        INF = float("inf")

        def valid(root, low, high):
            if not root:
                return True
            elif low < root.val < high:
                l_valid = valid(root.left, low, root.val)
                r_valid = valid(root.right, root.val, high)
                return l_valid and r_valid
            else:
                return False

        return valid(root, -INF, INF)
