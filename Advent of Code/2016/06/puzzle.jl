function day6()
    input = joinpath(@__DIR__, "input.txt")
    messages = readlines(input)

    stats = [Dict() for _ = 1:length(first(messages))]

    for m ∈ messages
        for (i, c) ∈ enumerate(m)
            d = stats[i]
            d[c] = get(d, c, 0) + 1
        end
    end

    result₁, result₂ = map(stats) do d
        sd = sort(collect(d), by=x -> x[2])
        first(last(sd)), first(first(sd))
    end |> x -> join.((first.(x), last.(x)))

    # @assert result₁ == "usccerug"
    # @assert result₂ == "cnvvtafc"

    result₁, result₂
end

export day6
