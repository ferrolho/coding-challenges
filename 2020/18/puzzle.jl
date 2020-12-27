⟰ = ⩎ = +  # Define unicode operators to override precedence

"""
"Borrowed" from @dgkf's solution. :-)

For a complete list of *every* Julia operator's precedence, see the top of this file:
[`src/julia-parser.scm`](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm).
"""
function day18()
    input = joinpath(@__DIR__, "input.txt")
    expressions = readlines(input)

    result₁, result₂ = (sum(expressions) do expression
        replace(expression, '+' => ch) |> Meta.parse |> eval
    end for ch ∈ ('⩎', '⟰'))

    # @assert result₁ == 86311597203806
    # @assert result₂ == 276894767062189

    result₁, result₂
end

export day18
