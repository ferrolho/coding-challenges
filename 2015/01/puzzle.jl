function day1()
    input = joinpath(@__DIR__, "input.txt")

    result = map(readline(input) |> collect) do c
        c == '(' ? 1 : -1
    end |> cumsum

    result₁ = last(result)
    result₂ =  findfirst(==(-1), result)

    # @assert result₁ == 138
    # @assert result₂ == 1771

    result₁, result₂
end

export day1
