function day19()
    input = joinpath(@__DIR__, "input.txt")

    replacements, molecule = split(read(input, String), "\n\n") |>
                             x -> (split(x[1], '\n') .|> x -> Pair(split(x, " => ")...),
                                   eachmatch(r"([A-Z][a-z]*)", x[2]) |> collect .|> x -> only(x.captures))

    function part₁(s)
        next = []
        for (in, out) ∈ replacements
            for (i, c) = enumerate(s)
                if in == string(c)
                    a = i > 1 ? s[1:i - 1] : ""
                    c = i < length(s) ? s[i + 1:end] : ""
                    push!(next, join([a; out; c]))
                end
            end
        end
        next |> unique |> length
    end

    function part₂(s)
        s = join(s)
        counter = 0
        while s != "e"
            for (k, v) ∈ replacements
                counter += count(v, s)
                s = replace(s, v => k)
            end
        end
        counter
    end

    result₁ = part₁(molecule)
    result₂ = part₂(molecule)

    # @assert result₁ == 518
    # @assert result₂ == 200

    result₁, result₂
end

export day19
