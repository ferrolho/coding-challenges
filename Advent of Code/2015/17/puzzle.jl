function day17()
    input = joinpath(@__DIR__, "input.txt")
    containers = parse.(Int, readlines(input))

    part₁ = filter!(x -> sum(x) == 150, collect(combinations(containers)))
    result₁ = length(part₁)

    part₂ = filter!(x -> length(x) == minimum(length, part₁), part₁)
    result₂ = length(part₂)

    # @assert result₁ == 654
    # @assert result₂ == 57

    result₁, result₂
end

export day17
