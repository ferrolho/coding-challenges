function day16()
    input = joinpath(@__DIR__, "input.txt")

    sample = Dict("children"    => 3,
                  "cats"        => 7,
                  "samoyeds"    => 2,
                  "pomeranians" => 3,
                  "akitas"      => 0,
                  "vizslas"     => 0,
                  "goldfish"    => 5,
                  "trees"       => 3,
                  "cars"        => 2,
                  "perfumes"    => 1)

    list = map(eachline(input)) do line
        Dict(replace(line, r"Sue \d+: " => "") |>
             x -> split.(split(x, ", "), ": ") .|>
             x -> (x[1] => parse(Int, x[2])))
    end

    list₁ = copy(list)
    list₂ = copy(list)

    for (k, v) ∈ sample
        filter!(x -> !haskey(x, k) || x[k] == v, list₁)
    end

    for (k, v) ∈ sample
        if k ∈ ("cats", "trees")
            filter!(x -> !haskey(x, k) || x[k] > v, list₂)
        elseif k ∈ ("pomeranians", "goldfish")
            filter!(x -> !haskey(x, k) || x[k] < v, list₂)
        else
            filter!(x -> !haskey(x, k) || x[k] == v, list₂)
        end
    end

    result₁ = findall(==(list₁ |> only), list) |> only
    result₂ = findall(==(list₂ |> only), list) |> only

    # @assert result₁ == 103
    # @assert result₂ == 405

    result₁, result₂
end

export day16
