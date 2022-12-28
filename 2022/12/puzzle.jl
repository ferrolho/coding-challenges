function day12_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    function char_to_height(c)
        islowercase(c) && return c - 'a'
        c == 'S' && return 'a' - 'a'
        c == 'E' && return 'z' - 'a'
    end

    function find_special_char(c, collection)
        findall(==(c), collection) |> only  # |> ci -> ci.I
    end

    letters = mapreduce(collect, hcat, eachline(filename)) |> permutedims

    heights = char_to_height.(letters)

    S = find_special_char('S', letters)
    E = find_special_char('E', letters)

    heights, S, E
end

function day12_bfs(heights, start_ci, elevation_fn, goal_fn)
    queue = [(start_ci, 0)]
    visited = Set([start_ci])

    function try_to_step!(ci₁, ci₂, num_steps)
        # cannot step outside the map
        ci₂ ∉ CartesianIndices(heights) && return
        # cannot step higher than one unit
        elevation_fn(heights[ci₂] - heights[ci₁]) && return
        # already visited this one
        ci₂ ∈ visited && return

        # step there (add node to queue)
        push!(queue, (ci₂, num_steps + 1))
        # mark that CI as 'visited'
        push!(visited, ci₂)
    end

    while !isempty(queue)
        ci, num_steps = popfirst!(queue)
        goal_fn(ci) && return num_steps

        try_to_step!(ci, ci + CartesianIndex(-1, 0), num_steps)
        try_to_step!(ci, ci + CartesianIndex(1, 0), num_steps)
        try_to_step!(ci, ci + CartesianIndex(0, -1), num_steps)
        try_to_step!(ci, ci + CartesianIndex(0, 1), num_steps)
    end
end

day12_part1(heights, S, E) = day12_bfs(heights, S, >(1), ci -> ci == E)
day12_part2(heights, _, E) = day12_bfs(heights, E, <(-1), ci -> heights[ci] == 0)

@testset "day12" begin
    input = day12_parseinput()
    @test day12_part1(input...) == 534
    @test day12_part2(input...) == 525
end

export day12_parseinput, day12_part1, day12_part2
