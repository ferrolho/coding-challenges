function day1_parseinput()
    vec(readdlm(joinpath(@__DIR__, "input.txt"), Int))
end

day1_part1(input) = diff(input) |> x -> count(>(0), x)
day1_part2(input) = partition(input, 3, 1) .|> sum |> diff |> x -> count(>(0), x)

export day1_parseinput, day1_part1, day1_part2
