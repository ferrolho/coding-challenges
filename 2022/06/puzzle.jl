function day6_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    readline(filename)
end

function day6_aux(input, N)
    findfirst(
        i -> allunique(input[i-N+1:i]),
        N:lastindex(input)
    ) + N - 1
end

day6_part1(input) = day6_aux(input, 4)
day6_part2(input) = day6_aux(input, 14)

@testset "day06" begin
    input = day6_parseinput()
    @test day6_part1(input) == 1175
    @test day6_part2(input) == 3217
end

export day6_parseinput, day6_part1, day6_part2
