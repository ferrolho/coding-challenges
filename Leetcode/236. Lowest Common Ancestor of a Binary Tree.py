# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def lowestCommonAncestor(self, root: "TreeNode", p: "TreeNode", q: "TreeNode") -> "TreeNode":
        search_set = {p.val, q.val}
        answer = None

        def dfs(node):
            """Returns how many targets present in this subtree."""
            nonlocal answer

            if not node or answer is not None:
                return 0

            count = int(node.val in search_set)
            count += dfs(node.left)
            count += dfs(node.right)

            if count == len(search_set) and answer is None:
                answer = node

            return count

        dfs(root)

        return answer
