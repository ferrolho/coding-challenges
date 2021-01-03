function day8()
    input = joinpath(@__DIR__, "input.txt")
    strings = readlines(input)

    result₁ = sum(strings) do s
        length(s) - length(Meta.parse(s))
    end

    result₂ = sum(strings) do s₀
        s₁ = replace(s₀, "\\" => "\\\\")
        s₂ = replace(s₁, "\"" => "\\\"")
        s₃ = "\"" * s₂ * "\""
        # @assert Meta.parse(s₃) == s₀
        length(codeunits(s₃)) - length(s₀)
    end

    # @assert result₁ == 1342
    # @assert result₂ == 2074

    result₁, result₂
end

export day8
