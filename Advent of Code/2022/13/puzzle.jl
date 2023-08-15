function day13_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    chunks = split(read(filename, String), "\n\n")
    f(x) = split(x) .|> eval ∘ Meta.parse
    map(f, chunks)
end

day13_compare(a::Int, b::Int) = sign(a - b)
day13_compare(a::Int, b::Vector) = day13_compare([a], b)
day13_compare(a::Vector, b::Int) = day13_compare(a, [b])

function day13_compare(a::Vector, b::Vector)
    for (l, r) in zip(a, b)
        result = day13_compare(l, r)
        result != 0 && return result
    end
    day13_compare(length(a), length(b))
end

day13_isless(x, y) = day13_compare(x, y) < 0

function day13_part1(input)
    sum(day13_isless(pair...) ? i : 0
        for (i, pair) in enumerate(input))
end

function day13_part2(input)
    divider_packets = [[[2]], [[6]]]
    packets = vcat(input..., divider_packets)
    sort!(packets, lt=day13_isless)
    prod(findfirst(==(p), packets)
         for p in divider_packets)
end

@testset "day13" begin
    input = day13_parseinput()
    @test day13_part1(input) == 5366
    @test day13_part2(input) == 23391
end

export day13_parseinput, day13_part1, day13_part2
