function day4_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    map(eachline(filename)) do line
        tokens = split(line, (',', '-'))
        aₛ, aₜ, bₛ, bₜ = parse.(Int, tokens)
        aₛ:aₜ, bₛ:bₜ
    end
end

function day4_part1(input)
    count(input) do (a, b)
        a ⊆ b || a ⊇ b
    end
end

function day4_part2(input)
    count(input) do (a, b)
        a ∩ b |> !isempty
    end
end

@testset "day04" begin
    input = day4_parseinput()
    @test day4_part1(input) == 605
    @test day4_part2(input) == 914
end

export day4_parseinput, day4_part1, day4_part2
