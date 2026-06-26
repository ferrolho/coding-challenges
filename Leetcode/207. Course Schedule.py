class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        # `graph[course]` gives the direct requirements for `course`
        graph = [[] for _ in range(numCourses)]
        for a, b in prerequisites:
            graph[a].append(b)
        print(f"{graph=}")

        # global running state for each course
        # 0 = unvisited, 1 = visiting, 2 = done
        state = [0] * numCourses

        def isAcyclic(node):
            if state[node] == 1: return False  # found a cycle
            if state[node] == 2: return True   # already checked
            state[node] = 1  # update node state 0 -> 1
            for dep in graph[node]:
                if not isAcyclic(dep):
                    return False
            state[node] = 2  # update node state 1 -> 2
            return True

        return all(isAcyclic(c) for c in range(numCourses))
