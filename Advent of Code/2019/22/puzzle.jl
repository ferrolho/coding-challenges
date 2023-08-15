function day22()
    input = readlines("./22/input.txt") .|> split

    N = 10007
    deck = 0:N - 1 |> collect
    perm = zeros(Int, N)

    for instruction ∈ input
        if instruction[1] == "deal"
            if instruction[2] == "into"
                reverse!(deck)
            elseif instruction[2] == "with"
                inc = parse(Int, instruction[end])
                for (i, j) in enumerate(range(0, step = inc, length = N))
                    perm[(j % N) + 1] = i
                end
                permute!(deck, perm)
            else
                return -1
            end
        elseif instruction[1] == "cut"
            shift = parse(Int, instruction[end])
            deck = circshift(deck, -shift)
        else
            return -1
        end
    end

    result₁ = findfirst(==(2019), deck) - 1

    # ! DISCLAIMER !
    # I was not able to solve part 2. The code below is not my own, and was adapted from this repository:
    # https://github.com/mebeim/aoc/blob/047a65b518d833aeb1b0c9c4274fe4b06c21c1e3/2019/day22_clean.py#L22-L42
    # The author even has a walkthrough here: https://github.com/mebeim/aoc/blob/master/2019/README.md#part-2-21

    function transform(start, step, size)
        for instruction ∈ input
            if instruction[1] == "deal"
                if instruction[2] == "into"
                    start = mod(start - step, size)
                    step = mod(-step, size)
                elseif instruction[2] == "with"
                    shift = parse(BigInt, instruction[end])
                    step = mod(step * powermod(shift, size - 2, size), size)
                end
            elseif instruction[1] == "cut"
                shift = parse(BigInt, instruction[end])
                shift < 0 && (shift += size)
                start = mod(start + step * shift, size)
            end
        end
        return start, step
    end

    function repeat(start, step, size, repetitions)
        final_step = powermod(step, repetitions, size)
        S = (1 - final_step) * powermod(1 - step, size - 2, size)
        final_start = mod(start * S, size)
        return final_start, final_step
    end

    start, step, size = 0, 1, BigInt(119315717514047)
    repetitions = BigInt(101741582076661)

    start, step = transform(start, step, size)
    start, step = repeat(start, step, size, repetitions)

    result₂ = mod(start + step * 2020, size)

    result₁, result₂
end

export day22
