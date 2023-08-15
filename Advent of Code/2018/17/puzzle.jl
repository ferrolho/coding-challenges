function day17()
    input = joinpath(@__DIR__, "input.txt")

    function look(state, i, dir)
        found_c = false
        c = i
        while !found_c
            side = c + dir
            below = c + CartesianIndex(0, 1)

            !checkbounds(Bool, state, side) && break

            if state[below] ∈ ('#', '~')
                if state[side] ∈ ('.', '|')
                    c += dir  # scan next
                elseif state[side] ∈ ('#', '~')
                    found_c = true
                end
            else
                break  # overflow
            end
        end
        found_c, c
    end

    look_left(state, i) = look(state, i, CartesianIndex(-1, 0))
    look_right(state, i) = look(state, i, CartesianIndex(1, 0))

    function flood(state, i)
        found_l, l = look_left(state, i)
        found_r, r = look_right(state, i)

        ( found_l &  found_r) && (state[l:r] .= '~'; return [i])
        ( found_l & !found_r) && (state[l:r] .= '|'; return [r])
        (!found_l &  found_r) && (state[l:r] .= '|'; return [l])
        (!found_l & !found_r) && (state[l:r] .= '|'; return [l,r])
    end

    # Calculate regions with clay
    clay_CIs = mapreduce(∪, eachline(input)) do line
        m = eachmatch(r"(\w)=(\d+), (\w)=(\d+)..(\d+)", line)
        a, b, c, d, e = only(m).captures |> x ->
                        (x[1] == "x" ? 1 : 2, parse(Int, x[2]),
                         x[3] == "x" ? 1 : 2, parse(Int, x[4]), parse(Int, x[5]),)

        clay_cis = Array{Union{Int,UnitRange{Int}}}(undef, 2)
        clay_cis[a] = b
        clay_cis[c] = d:e

        CartesianIndices((clay_cis...,))
    end

    # Calculate size of the grid
    spring_CI = CartesianIndex(500, 0)
    min_CI, max_CI = extrema([clay_CIs; spring_CI])
    min_CI -= CartesianIndex(2, 1)
    max_CI += CartesianIndex(1, 0)

    # Build initial state
    state = fill('.', (max_CI - min_CI).I)
    state[spring_CI - min_CI] = '+'
    foreach(x -> state[x - min_CI] = '#', clay_CIs)

    gravity = CartesianIndex(0, 1)

    streams = [spring_CI - min_CI + gravity]
    paths = [Set([streams[1]])]

    while !isempty(streams)
        tobedeleted = Int[]

        for i = 1:length(streams)
            # Delete stream if it reaches the end
            if !checkbounds(Bool, state, streams[i])
                push!(tobedeleted, i)
                continue
            end

            if state[streams[i]] ∈ ('.', '|')
                state[streams[i]] = '|'
                streams[i] += gravity

            elseif state[streams[i]] ∈ ('#', '~')
                # `flood()` will return the new position for the stream.
                # It may return a second stream if its source was forked.
                ret = flood(state, streams[i] - gravity)

                # Update main stream
                streams[i] = ret[1]
                push!(paths[i], streams[i])

                # Add a stream if this path has not been explored yet
                if length(ret) > 1 && !any(ret[2] ∈ p for p in paths)
                    push!(streams, ret[2])
                    push!(paths, Set([ret[2]]))
                end
            end
        end

        deleteat!(streams, tobedeleted)
        deleteat!(paths, tobedeleted)
    end

    crop_top =  minimum(clay_CIs)[2] + 1
    state = state[:,crop_top:end]

    still_water = count(==('~'), state)
    running_water = count(==('|'), state)

    result₁ = still_water + running_water
    result₂ = still_water

    # @assert result₁ == 34775
    # @assert result₂ == 27086

    result₁, result₂
end

export day17
