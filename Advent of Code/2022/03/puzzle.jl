function day3_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    readlines(filename)
end

function day3_char_to_priority(c)
    c - (islowercase(c) ? 'a' : 'A' - 26) + 1
end

function day3_part1(input)
    sum(input) do x
        N = length(x)
        str₁, str₂ = x[1:N÷2], x[N÷2+1:N]
        s₁, s₂ = Set(str₁), Set(str₂)
        only(s₁ ∩ s₂) |> day3_char_to_priority
    end
end

function day3_part2(input)
    sum(Iterators.partition(input, 3)) do x
        only(reduce(∩, x)) |> day3_char_to_priority
    end
end

@testset "day03" begin
    input = day3_parseinput()
    @test day3_part1(input) == 7878
    @test day3_part2(input) == 2760
end

export day3_parseinput, day3_part1, day3_part2
