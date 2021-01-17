function day13()
    input = joinpath(@__DIR__, "input.txt")
    n = parse(Int, readline(input))

    function reveal(ci::CartesianIndex)
        x, y = ci.I
        (x < 0 || y < 0) && return '#'
        t₁ = x * x + 3 * x + 2 * x * y + y + y * y + n
        t₂ = count(==('1'), string(t₁, base=2))
        iseven(t₂) ? '.' : '#'
    end

    function render(grid, path)
        offset = CartesianIndex(2, 2)
        a, b = extrema(keys(grid))
        s = map(x -> ' ', a:b)
        for (k, v) ∈ grid
            s[k + offset] = v
        end
        foreach(x -> s[x + offset] = 'O', path)
        foreach(x -> println(x...), eachcol(s))
    end

    function bfs(target; start=CartesianIndex(1, 1))
        steps = CartesianIndex.(((1, 0), (0, 1), (-1, 0), (0, -1)))
        grid = Dict{CartesianIndex,Char}()
        nodes = [(start, 0, CartesianIndex[])]
        visited = Set{CartesianIndex}()

        while !isempty(nodes)
            pos, distance, prev = popfirst!(nodes)

            # Stopping criteria
            if pos == target
                # render(grid, [prev; pos])
                return distance
            end

            for step in steps
                next = pos + step
                !haskey(grid, next) && (grid[next] = reveal(next))
                if grid[next] == '.' && next ∉ visited
                    push!(nodes, (next, distance + 1, [prev; pos]))
                    push!(visited, next)
                end
            end
        end
    end

    result₁ = bfs(CartesianIndex(31, 39))

    result₂ = count(CartesianIndices((0:25, 0:25))) do ci
        steps = bfs(ci)
        !isnothing(steps) && steps <= 50
    end

    # @assert result₁ == 96
    # @assert result₂ == 141

    result₁, result₂
end

export day13
