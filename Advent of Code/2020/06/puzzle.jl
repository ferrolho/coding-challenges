function day6()
    input = joinpath(@__DIR__, "input.txt")
    groups = split(read(input, String), "\n\n")

    group_chars = map(groups) do s
        replace(s, "\n" => "") |> unique
    end

    result₁ = sum(length.(group_chars))

    result₂ = 0

    for (chars, ppl) in zip(group_chars, split.(groups))
        result₂ += count(chars) do c  # Count the chars that occur
            all(occursin.(c, ppl))  # in all people from that group.
        end
    end

    result₁, result₂
end

export day6
