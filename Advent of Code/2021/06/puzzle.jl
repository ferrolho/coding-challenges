function day6_parseinput()
    input = joinpath(@__DIR__, "input.txt") |> readline
    parse.(Int, split(input, ","))
end

function day6_slow(input, days)
    state = fill(Int8(8), 1_000_000)
    num_fish = length(input)
    state[1:num_fish] = input
    for _ = 1:days
        state[1:num_fish] .-= 1
        inds = findall(<(0), state)
        num_fish += length(inds)
        state[inds] .= 6
    end
    num_fish
end

function day6_fast(input, days)
    state = @MVector [count(==(t), input) for t = 0:8]
    for _ = 1:days
        state[8] += state[1]
        state = circshift(state, -1)
    end
    sum(state)
end

day6_part1(input) = day6_fast(input,  80)
day6_part2(input) = day6_fast(input, 256)

@testset "day06" begin
    input = day6_parseinput()
    @test day6_part1(input) == 374927
    @test day6_part2(input) == 1687617803407
end

export day6_parseinput, day6_part1, day6_part2
