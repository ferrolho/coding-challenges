class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        rows, cols = len(grid), len(grid[0])

        unexplored_land = {
            (r, c)
            for r in range(rows)  # for each row
            for c in range(cols)  # for each col
            if grid[r][c] == "1"
        }

        # `flood(coord)` "closes" over `moves`
        moves = ((1, 0), (0, 1), (-1, 0), (0, -1))

        def flood(coord):
            for dr, dc in moves:
                neighbour = coord[0] + dr, coord[1] + dc
                if neighbour in unexplored_land:
                    unexplored_land.remove(neighbour)
                    flood(neighbour)

        num_islands = 0
        while unexplored_land:
            num_islands += 1  # explore a new island
            coord = unexplored_land.pop()
            flood(coord)

        return num_islands
