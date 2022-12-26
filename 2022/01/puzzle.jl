function day1_parseinput()
    filename = joinpath(@__DIR__, "input.txt")
    chunks = split(read(filename, String), "\n\n")
    parsed_chunks = map(chunks) do chunk
        parse.(Int, split(chunk))
    end
    return parsed_chunks
end

day1_part1(input) = sum.(input) |> maximum
day1_part2(input) = sum.(input) |> x -> partialsort!(x, 1:3, rev=true) |> sum

@testset "day01" begin
    day1_input = day1_parseinput()
    @test day1_part1(day1_input) == 71506
    @test day1_part2(day1_input) == 209603
end

export day1_parseinput, day1_part1, day1_part2
