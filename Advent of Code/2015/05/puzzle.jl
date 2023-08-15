function day5()
    input = joinpath(@__DIR__, "input.txt")
    strings = readlines(input)

    function isnice₁(s::String)
        cond₁ = count(c -> c ∈ "aeiou", s) >= 3
        cond₂ = 0 ∈ diff(collect(s))
        cond₃ = !contains(s, r"ab|cd|pq|xy")
        cond₁ & cond₂ & cond₃
    end

    function isnice₂(s::String)
        cond₁ = contains(s, r"(\w{2}).*\1")
        cond₂ = contains(s, r"(\w).\1")
        cond₁ & cond₂
    end

    result₁ = count(isnice₁, strings)
    result₂ = count(isnice₂, strings)

    # @assert result₁ == 255
    # @assert result₂ == 55

    result₁, result₂
end

export day5
