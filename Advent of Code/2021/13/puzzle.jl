function day13_parseinput()
    input = read(joinpath(@__DIR__, "input.txt"), String)
    raw_points, raw_instructions = split(input, "\n\n")
    points = split.(split(raw_points), ",") .|>
             x -> parse.(Int, x) |> x -> CartesianIndex(x...) + CartesianIndex(1, 1)
    instructions = split(raw_instructions, "\n", keepempty = false) .|>
                   x -> split(split(x)[3], "=") |> x -> (x[1] == "x" ? 1 : 2, parse(Int, x[2]))
    points, instructions
end

function day13_fold(points, dim, at)
    static_points = filter(x -> x[dim] ≤ at, points)
    moving_points = filter(x -> x[dim] > at, points)

    moving_points = map(moving_points) do x
        dim == 1 ?
        CartesianIndex(x[1] - 2(x[1] - 1 - at), x[2]) :
        CartesianIndex(x[1], x[2] - 2(x[2] - 1 - at))
    end

    static_points ∪ moving_points
end

function day13_part1(points, instructions)
    dim, at = first(instructions)
    points = day13_fold(points, dim, at)
    return length(points)
end

function day13_part2(points, instructions)
    for (dim, at) in instructions
        points = day13_fold(points, dim, at)
    end

    # # Uncomment the lines below to display the result.
    # origami = fill(" ", maximum(points).I)
    # origami[points] .= "#"
    # origami = permutedims(origami)
    # foreach(x -> println(join(x)), eachrow(origami))

    return length(points)
end

@testset "day13" begin
    points, instructions = day13_parseinput()
    @test day13_part1(points, instructions) == 666
    @test day13_part2(points, instructions) == 97  # CJHAZHKU
end

export day13_parseinput, day13_part1, day13_part2
