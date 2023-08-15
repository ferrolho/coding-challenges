struct Day18_State
    pos::CartesianIndex
    keys::Int64
end

struct Day18_Part2_State
    pos₁::CartesianIndex
    pos₂::CartesianIndex
    pos₃::CartesianIndex
    pos₄::CartesianIndex
    keys::Int64
    active_robot::Int
end

function day18()
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

    function get_robot_pos(s::Day18_Part2_State, id::Int)
        return [s.pos₁, s.pos₂, s.pos₃, s.pos₄][id]
    end

    function part2(grid::Array{Char})
        pos_start = findall(==('@'), grid)
        start_states = [Day18_Part2_State(pos_start..., 0, 1),
                        Day18_Part2_State(pos_start..., 0, 2),
                        Day18_Part2_State(pos_start..., 0, 3),
                        Day18_Part2_State(pos_start..., 0, 4)]

        q = Queue{Day18_Part2_State}()
        visited = Set{Day18_Part2_State}()

        foreach(x->enqueue!(q, x), start_states)
        foreach(x->push!(visited, x), start_states)

        n_keys = count(islowercase, grid)
        val_all_keys = 2^n_keys - 1
        n_steps = 0

        while !isempty(q)
            q_size = length(q)
            for _ = 1:q_size
                state = dequeue!(q)
                state.keys == val_all_keys && return n_steps
                robot = state.active_robot
                for dir ∈ [CartesianIndex(1, 0), CartesianIndex(0, 1),
                            CartesianIndex(-1, 0), CartesianIndex(0, -1)]
                    pos_next = get_robot_pos(state, robot) + dir
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
                    new_key_found = false
                    if grid[pos_next] |> islowercase
                        # a new key has been found
                        keys_next = state.keys | (1 << (grid[pos_next] - 'a'))
                        new_key_found = true
                    end
                    state_pos_next = [state.pos₁, state.pos₂, state.pos₃, state.pos₄]
                    state_pos_next[robot] = pos_next
                    if new_key_found
                        for r = 1:4
                            state_next = Day18_Part2_State(state_pos_next..., keys_next, r)
                            if state_next ∉ visited
                                enqueue!(q, state_next)
                                push!(visited, state_next)
                            end
                        end
                    else
                        state_next = Day18_Part2_State(state_pos_next..., keys_next, robot)
                        if state_next ∉ visited
                            enqueue!(q, state_next)
                            push!(visited, state_next)
                        end
                    end
                end
            end
            n_steps += 1
            # println("Steps: $(n_steps)")
        end
        return -1
    end

    input = hcat(collect.(readdlm("./18/input.txt", String))...)
    # foreach(x->x |> join |> println, eachcol(input))

    result₁ = shortest_path(input)

    #   ...       @#@
    #   .@.  -->  ###
    #   ...       @#@

    pos = findfirst(==('@'), input)
    for k ∈ [CartesianIndex(0, 0),
             CartesianIndex(1, 0), CartesianIndex(0, 1),
             CartesianIndex(-1, 0), CartesianIndex(0, -1)]
        input[pos + k] = '#'
    end
    for k ∈ [CartesianIndex(1, 1), CartesianIndex(-1, 1),
             CartesianIndex(-1, -1), CartesianIndex(1, -1)]
        input[pos + k] = '@'
    end

    result₂ = part2(input)

    result₁, result₂
end

export day18
