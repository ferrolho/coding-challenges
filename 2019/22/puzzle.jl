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
end

export day22
