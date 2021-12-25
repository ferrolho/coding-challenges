function day7_parseinput()
    input = joinpath(@__DIR__, "input.txt") |> readline
    parse.(Int, split(input, ","))
end

function day7_part1(input)
    target = median(input) |> Int
    sum(x -> abs(x - target), input)
end

function day7_part2(input)
    target = mean(input) |> floor |> Int
    sum(x -> sum(1:abs(x - target)), input)
end

@testset "day07" begin
    input = day7_parseinput()
    @test day7_part1(input) == 333755
    @test day7_part2(input) == 94017638
end

export day7_parseinput, day7_part1, day7_part2
