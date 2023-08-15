function day5_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    state = Dict(
        1 => ['F', 'G', 'V', 'R', 'J', 'L', 'D'],
        2 => ['S', 'J', 'H', 'V', 'B', 'M', 'P', 'T'],
        3 => ['C', 'P', 'G', 'D', 'F', 'M', 'H', 'V'],
        4 => ['Q', 'G', 'N', 'P', 'D', 'M'],
        5 => ['F', 'N', 'H', 'L', 'J'],
        6 => ['Z', 'T', 'G', 'D', 'Q', 'V', 'F', 'N'],
        7 => ['L', 'B', 'D', 'F'],
        8 => ['N', 'D', 'V', 'S', 'B', 'J', 'M'],
        9 => ['D', 'L', 'G'],
    )

    steps = map(eachline(filename)) do line
        split(line) |> x -> parse.(Int, x[[2, 4, 6]])
    end

    state, steps
end

function day5_aux(state, steps, fn)
    for (num, src, dst) in steps
        crates = state[src][1:num] |> fn
        pushfirst!(state[dst], crates...)
        splice!(state[src], 1:num)
    end
    mapreduce(x -> state[x][begin], string, 1:length(state))
end

day5_part1(args...) = day5_aux(args..., reverse!)
day5_part2(args...) = day5_aux(args..., identity)

@testset "day05" begin
    state, steps = day5_parseinput()
    @test day5_part1(deepcopy(state), steps) == "QMBMJDFTD"
    @test day5_part2(deepcopy(state), steps) == "NBTVTJNFJ"
end

export day5_parseinput, day5_part1, day5_part2
