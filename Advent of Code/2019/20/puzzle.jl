function day20()
    input = hcat(collect.(readlines("./20/input.txt"))...)
    # foreach(x->x |> join |> println, eachcol(input))

    labels = DefaultDict{String,Set{CartesianIndex}}(Set([]))

    for (i, s) in enumerate(eachcol(input))
        matches = eachmatch(r"[A-Z]{2}", join(s)) |> collect
        for m in matches
            candidates = [m.offset - 1, m.offset + 2]
            chosen = filter(c->checkbounds(Bool, s, c) && s[c] == '.', candidates) |> first
            push!(labels[m.match], CartesianIndex(chosen, i))
        end
    end

    for (i, s) in enumerate(eachrow(input))
        matches = eachmatch(r"[A-Z]{2}", join(s)) |> collect
        for m in matches
            candidates = [m.offset - 1, m.offset + 2]
            chosen = filter(c->checkbounds(Bool, s, c) && s[c] == '.', candidates) |> first
            push!(labels[m.match], CartesianIndex(i, chosen))
        end
    end

    # labels |> display

    function shortest_path(grid::Array{Char})
        start = labels["AA"] |> first
        final = labels["ZZ"] |> first
        # println(start)
        # println(final)

        q = Queue{CartesianIndex}()
        visited = Set{CartesianIndex}()

        enqueue!(q, start)
        push!(visited, start)

        n_steps = 0

        while !isempty(q)
            q_size = length(q)
            for _ = 1:q_size
                cur = dequeue!(q)
                cur == final && return n_steps
                for dir ∈ [CartesianIndex(1, 0), CartesianIndex(0, 1),
                           CartesianIndex(-1, 0), CartesianIndex(0, -1)]
                    next = cur + dir
                    if grid[next] == '#'
                        continue
                    end
                    if grid[next] |> isuppercase
                        coords = [v for (k, v) in labels if cur ∈ v] |> first
                        portal_exit = setdiff(coords, [cur])
                        isempty(portal_exit) ? continue : (next = first(portal_exit))
                    end
                    if next ∉ visited
                        enqueue!(q, next)
                        push!(visited, next)
                    end
                end
            end
            n_steps += 1
        end
        return -1
    end

    function shortest_path_part2(grid::Array{Char})
        start = labels["AA"] |> first
        final = labels["ZZ"] |> first
        # println(start)
        # println(final)

        q = Queue{Tuple{CartesianIndex,Int}}()
        visited = Set{Tuple{CartesianIndex,Int}}()

        enqueue!(q, (start, 0))
        push!(visited, (start, 0))

        n_steps = 0

        while !isempty(q)
            q_size = length(q)
            for _ = 1:q_size
                cur, lvl = dequeue!(q)
                (cur == final && lvl == 0) && return n_steps
                for dir ∈ [CartesianIndex(1, 0), CartesianIndex(0, 1),
                           CartesianIndex(-1, 0), CartesianIndex(0, -1)]
                    next = cur + dir
                    next_lvl = lvl
                    grid[next] == '#' && continue
                    if grid[next] |> isuppercase
                        coords = [v for (k, v) in labels if cur ∈ v] |> first
                        portal_exit = setdiff(coords, [cur])
                        if isempty(portal_exit)
                            continue  # Bumped against AA or ZZ
                        else
                            next = first(portal_exit)  # coordinate after warp
                            if any(==(3), cur.I) || any(==(2), size(grid) .- cur.I)
                                next_lvl > 0 ? (next_lvl -= 1) : continue  # Going out...
                            else
                                next_lvl += 1  # Going in...
                            end
                        end
                    end
                    if (next, next_lvl) ∉ visited
                        enqueue!(q, (next, next_lvl))
                        push!(visited, (next, next_lvl))
                    end
                end
            end
            n_steps += 1
            # print("\rSteps: $(n_steps)    Queue: $(length(q))")
        end
        return -1
    end

    result₁ = shortest_path(input)
    result₂ = shortest_path_part2(input)

    result₁, result₂
end

export day20
