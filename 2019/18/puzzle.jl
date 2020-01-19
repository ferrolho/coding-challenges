struct Day18_State
    pos::CartesianIndex
    keys::Int64
end

function day18()
    input = hcat(collect.(readdlm("./18/input.txt", String))...)
    # foreach(x->x |> join |> println, eachcol(input))

    function shortest_path(grid::Array{Char})
        pos_start = findfirst(==('@'), grid)
        state_start = Day18_State(pos_start, 0)

        q = Queue{Day18_State}()
        visited = Set{Day18_State}()

        enqueue!(q, state_start)
        push!(visited, state_start)

        n_keys = count(islowercase, grid)
        val_all_keys = 2^n_keys - 1
        n_steps = 0

        while !isempty(q)
            q_size = length(q)
            for _ = 1:q_size
                state = dequeue!(q)
                state.keys == val_all_keys && return n_steps
                for dir ∈ [CartesianIndex(1, 0), CartesianIndex(0, 1),
                           CartesianIndex(-1, 0), CartesianIndex(0, -1)]
                    pos_next = state.pos + dir
                    keys_next = state.keys
                    if grid[pos_next] == '#'
                        # got to a wall
                        continue
                    end
                    if grid[pos_next] |> isuppercase &&
                       (state.keys >> (grid[pos_next] - 'A')) & 1 == 0
                        # got to a door for which we do not have the key
                        continue
                    end
                    if grid[pos_next] |> islowercase
                        # a new key has been found
                        keys_next = state.keys | (1 << (grid[pos_next] - 'a'))
                    end
                    state_next = Day18_State(pos_next, keys_next)
                    if state_next ∉ visited
                        enqueue!(q, state_next)
                        push!(visited, state_next)
                    end
                end
            end
            n_steps += 1
        end
        return -1
    end

    result₁ = shortest_path(input)

    # result₁, result₂
end

export day18
