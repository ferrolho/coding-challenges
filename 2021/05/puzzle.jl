function day5_parseinput()
    input = read(joinpath(@__DIR__, "input.txt"), String)
    split(input, "\n", keepempty = false) .|> x -> split(x) |>
    x -> (parse.(Int, split(x[1], ",")) |> SVector{2,Int},
          parse.(Int, split(x[3], ",")) |> SVector{2,Int})
end

function day5_drawline!(diagram, p1, p2; keepdiagonals = false)
    !keepdiagonals && (p1[1] != p2[1] && p1[2] != p2[2]) && return

    dir = normalize(p2 - p1, Inf) .|> round .|> Int
    num_steps = norm(p2 - p1, Inf) |> Int

    foreach(0:num_steps) do steps
        x, y = p1 + steps * dir
        diagram[x, y] += 1
    end
end

day5_drawline!(diagram, (p1, p2); keepdiagonals = false) = day5_drawline!(diagram, p1, p2; keepdiagonals)

function day5_solve(input; keepdiagonals = false)
    diagram = DefaultDict{Tuple{Int,Int},Int}(0)
    foreach(x -> day5_drawline!(diagram, x; keepdiagonals), input)
    count(>(1), values(diagram))
end

day5_part1(input) = day5_solve(input; keepdiagonals = false)
day5_part2(input) = day5_solve(input; keepdiagonals = true)

@testset "day05" begin
    input = day5_parseinput()
    @test day5_part1(input) == 5632
    @test day5_part2(input) == 22213
end

export day5_parseinput, day5_part1, day5_part2
