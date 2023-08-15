function day3()
    input = joinpath(@__DIR__, "input.txt")

    c2ci = Dict('^' => CartesianIndex( 0,  1),
                '>' => CartesianIndex( 1,  0),
                'v' => CartesianIndex( 0, -1),
                '<' => CartesianIndex(-1,  0))

    instructions = map(x -> c2ci[x], collect(readline(input)))

    # -- Part One -- #

    santa = CartesianIndex(0, 0)
    visited = Dict{CartesianIndex,Int}(santa => 1)

    foreach(instructions) do step
        santa += step
        visited[santa] = get(visited, santa, 0) + 1
    end

    result₁ = length(visited)

    # -- Part Two -- #

    santa = CartesianIndex(0, 0)
    robosanta = CartesianIndex(0, 0)
    visited = Dict{CartesianIndex,Int}(santa => 2)

    for (i, s) in enumerate((santa, robosanta))
        foreach(instructions[i:2:end]) do step
            s += step
            visited[s] = get(visited, s, 0) + 1
        end
    end

    result₂ = length(visited)

    # @assert result₁ == 2592
    # @assert result₂ == 2360

    result₁, result₂
end

export day3
