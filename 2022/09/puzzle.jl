function day9_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    char_to_direction = Dict{Char,Tuple{Float64,Float64}}(
        'R' => (1, 0), 'L' => (-1, 0),
        'U' => (0, 1), 'D' => (0, -1))
    f(x) = char_to_direction[x[1]], parse(Int, (x[3:end]))
    map(f, eachline(filename))
end

function day9_move_rope!(rope)
    # difference vector and its infinity-norm
    diff = rope[1] .- rope[2]
    dist = norm(diff, Inf)

    if dist ≥ 2
        # calculate where to move
        move = round.(diff ./ dist, RoundNearestTiesAway)
        # move the immediate next knot
        rope[2] = rope[2] .+ move
        # move remaining knots (if any)
        length(rope) > 2 && day9_move_rope!(@view rope[2:end])
    end
end

function day9_simulate!(input, rope, visited)
    for (direction, num_steps) in input
        for _ in 1:num_steps
            # move leading knot
            rope[begin] = rope[begin] .+ direction
            # move the rest of the rope
            day9_move_rope!(rope)
            # keep track of the tail position
            push!(visited, rope[end])
        end
    end
end

function day9_simulate_rope(input, num_knots)
    # create a rope with <num_knots> knots
    rope = repeat([(1.0, 1.0)], num_knots)

    visited = Set([rope[end]])
    day9_simulate!(input, rope, visited)
    length(visited)
end

day9_part1(input) = day9_simulate_rope(input, 2)
day9_part2(input) = day9_simulate_rope(input, 10)

@testset "day09" begin
    input = day9_parseinput()
    @test day9_part1(input) == 6037
    @test day9_part2(input) == 2485
end

export day9_parseinput, day9_part1, day9_part2
