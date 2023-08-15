function day10()
    input = joinpath(@__DIR__, "input.txt")
    data = parse.(Int, readlines(input)) |> sort
    data = [ 0 ; data ; data[end] + 3 ]

    function part1(data)
        diffs = diff(data)

        diff₁ = count(==(1), diffs)
        diff₃ = count(==(3), diffs)

        diff₁ * diff₃
    end

    function part2(data)
        strs = split(string(diff(data)...), "3", keepempty=false)

        l₂ = count(s -> length(s) == 2, strs)
        l₃ = count(s -> length(s) == 3, strs)
        l₄ = count(s -> length(s) == 4, strs)

        2^l₂ * 4^l₃ * 7^l₄
    end

    result₁ = part1(data)
    result₂ = part2(data)

    # @btime $part1($data)
    # @btime $part2($data)

    result₁, result₂
end

export day10
