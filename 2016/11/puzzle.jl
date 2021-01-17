function day11()
    input = joinpath(@__DIR__, "input.txt")

    function preparestate(elements, g2floor, m2floor)
        # Position of each element's generator and microchip
        pos_items = map(elements |> collect |> sort) do x
            [g2floor[x], m2floor[x]]
        end |> x -> reduce(vcat, x)
        [1, pos_items...]
    end

    function bfs(state₀)
        function tuple2int(t; result=0)
            for x in t
                result = 10 * result + x
            end
            result
        end

        # The solution to the problem.
        # (Elevator and every item at the 4th floor.)
        stateₛ = fill(4, length(state₀))

        state₀id = tuple2int(state₀)
        stateₛid = tuple2int(stateₛ)

        # This will map explored states to the
        # minimum steps required to reach them.
        cache = Dict{Int,Int}()

        # List of states to be explored next.
        next = Pair{Array{Int,1},Int}[state₀ => 0]

        function issafe(state)
            gs = state[2:2:end]  # Generators' floors (radioactive)
            ms = state[3:2:end]  # Microchips' floors
            all(enumerate(ms)) do (i, m)  # Each microchip must be:
                cond₁ = m == gs[i]        # - Paired with its generator; or
                cond₂ = m ∉ gs            # - In a floor without generators
                cond₁ || cond₂
            end
        end

        while !haskey(cache, stateₛid)
            state, steps = popfirst!(next)
            stateid = tuple2int(state)

            haskey(cache, stateid) && continue

            # Update cache. (IMPORTANT: Including redundant states.)
            pairs = Iterators.partition(state[2:end], 2) |> collect
            for p ∈ permutations(pairs)
                s = [state[1], reduce(vcat, p)...]
                sid = tuple2int(s)
                cache[sid] = steps
            end

            items = findall(==(state[1]), state)[2:end]
            c₁ = combinations(items, 1)
            c₂ = combinations(items, 2)

            for step = (-1, +1)
                if step == -1
                    # Skip if trying to move any item downstairs but all
                    # items are already at least as high as the elevator.
                    all(>=(state[1]), state) && continue
                    # Only move single items downstairs, if possible.
                    cs = !isempty(c₁) ? c₁ : c₂
                elseif step == +1
                    # Only move pairs upstairs, if possible.
                    cs = !isempty(c₂) ? c₂ : c₁
                end
                for c ∈ cs
                    if any(iseven, c) && any(isodd, c) &&
                       !(iseven(c[1]) && c[1] + 1 == c[2])
                        # If we are trying to transport a generator and a microchip,
                        # but those items are not related to each other,
                        # then we cannot take them in the elevator.
                    else
                        dst = state[1] + step
                        if 1 <= dst <= 4
                            state₊ = copy(state)
                            state₊[[1; c]] .= dst
                            issafe(state₊) && push!(next, state₊ => steps + 1)
                        end
                    end
                end
            end
        end

        cache[stateₛid]
    end

    # -- Parse Input -- #

    elements = Set{String}()
    g2floor = Dict{String,Int}()
    m2floor = Dict{String,Int}()

    for (floor, line) in enumerate(eachline(input))
        g_names = collect(eachmatch(r"(\w+) generator", line)) .|> x -> only(x.captures)
        m_names = collect(eachmatch(r"(\w+)-compatible", line)) .|> x -> only(x.captures)
        union!(elements, g_names, m_names)
        foreach(x -> g2floor[x] = floor, g_names)
        foreach(x -> m2floor[x] = floor, m_names)
    end

    state₁ = preparestate(elements, g2floor, m2floor)

    for x ∈ ("elerium", "dilithium")
        push!(elements, x)
        g2floor[x] = 1
        m2floor[x] = 1
    end

    state₂ = preparestate(elements, g2floor, m2floor)

    # -- Solve Puzzle -- #

    result₁ = bfs(state₁)
    result₂ = bfs(state₂)

    # @assert result₁ == 37
    # @assert result₂ == 61

    result₁, result₂
end

export day11
