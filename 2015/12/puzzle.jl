function day12()
    input = joinpath(@__DIR__, "input.txt")
    s = readline(input)

    m = eachmatch(r"(-*\d+)", s)
    result₁ = mapreduce(x -> parse.(Int, x.captures), sum ∘ vcat, m)

    solve(t::String) = 0
    solve(t::Number) = t
    solve(t::Array) = mapreduce(solve, +, t)
    solve(t::Dict; vs=values(t)) = "red" ∉ vs ? sum(solve.(vs)) : 0

    j = JSON.parse(s)
    result₂ = solve(j)

    # @assert result₁ == 111754
    # @assert result₂ == 65402

    result₁, result₂
end

export day12
