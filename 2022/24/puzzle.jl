import LinearAlgebra: CartesianIndex as CI
import LinearAlgebra: CartesianIndices as CIs

function day24_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    char_to_direction = Dict(
        '^' => CI(-1, 0),
        '<' => CI(0, -1),
        '>' => CI(0, 1),
        'v' => CI(1, 0),
    )

    valley = mapreduce(collect, hcat, eachline(filename)) |> permutedims

    blizzards = [(ci, char_to_direction[c])
                 for (ci, c) in zip(CIs(valley), valley)
                 if c ∈ keys(char_to_direction)]

    a, b = size(valley)
    S = CI(1, 1 + 1)  # start position
    E = CI(a, b - 1)  # target position

    valley, blizzards, S, E
end

function day24_bfs(valley, blizzards, S, targets)
    # auxiliary function for clamping moving blizzards
    clamp(ci) = CI(mod1.(ci.I .- 1, size(valley) .- 2) .+ 1)

    # cache blizzards for O(1) lookup
    cache = Dict(0 => blizzards)

    function calculate(minute)
        prev_blizzards = blizzards_at(minute - 1)
        cache[minute] = map(prev_blizzards) do (ci, direction)
            next_pos = clamp(ci + direction)
            (next_pos, direction)
        end
    end

    function blizzards_at(minute)
        haskey(cache, minute) ? cache[minute] : calculate(minute)
    end

    function try_to_step!(ci, num_steps)
        ci ∉ CIs(valley) && return  # cannot step outside the map
        valley[ci] == '#' && return  # cannot step into the walls

        # cannot step into a blizzard
        any(x -> x[1] == ci, blizzards_at(num_steps)) && return

        node = (ci, num_steps)
        node ∈ visited && return  # already visited this one

        push!(queue, node)
        push!(visited, node)
    end

    node = (S, 0)
    queue = [node]
    visited = Set([node])

    while !isempty(queue)
        ci, num_steps = popfirst!(queue)

        if ci == targets[1]
            empty!(queue)
            empty!(visited)
            popfirst!(targets)
        end

        isempty(targets) && return num_steps

        # try to... go up, go left, wait, go right, go down
        try_to_step!(ci + CI(-1, 0), num_steps + 1)
        try_to_step!(ci + CI(0, -1), num_steps + 1)
        try_to_step!(ci + CI(0, 0), num_steps + 1)
        try_to_step!(ci + CI(0, 1), num_steps + 1)
        try_to_step!(ci + CI(1, 0), num_steps + 1)
    end
end

day24_part1(valley, blizzards, S, E) = day24_bfs(valley, blizzards, S, [E])
day24_part2(valley, blizzards, S, E) = day24_bfs(valley, blizzards, S, [E, S, E])

@testset "day24" begin
    input = day24_parseinput()
    @test day24_part1(input...) == 240
    @test day24_part2(input...) == 717
end

export day24_parseinput, day24_part1, day24_part2
