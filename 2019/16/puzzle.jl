function day16()
    input = parse.(Int, readline("./16/input.txt") |> collect)

    # Helper functions
    ones_digit(x::Number) = abs(x) % 10
    patternₖ(base::Array, x::Int) = repeat(base, inner = x, outer = ceil(Int, n / (4 * x) + 1))[2:n + 1]

    # Part 1
    signalᵢ   = copy(input)
    signalᵢ₊₁ = copy(input)
    n = length(signalᵢ)
    patterns = Dict(i => patternₖ([0, 1, 0, -1], i) for i = 1:n)

    for phaseᵢ = 1:100
        for i = 1:n; signalᵢ₊₁[i] = signalᵢ ⋅ patterns[i] |> ones_digit end
        signalᵢ = signalᵢ₊₁
    end
    result₁ = parse(Int, signalᵢ₊₁[1:8] |> join)

    # Part 2
    offset = parse(Int, input[1:7] |> join)
    signalᵢ   = copy(repeat(input, 10000))[offset + 1:end]
    n = length(signalᵢ)

    for phaseᵢ = 1:100
        signalᵢ = signalᵢ |> reverse |> cumsum |> reverse .|> ones_digit
    end
    result₂ = parse(Int, signalᵢ[1:8] |> join)

    result₁, result₂
end

export day16
