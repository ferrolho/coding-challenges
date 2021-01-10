function day25()
    input = joinpath(@__DIR__, "input.txt")
    r, c = (r"row (\d+), column (\d+)", readline(input)) |>
           x -> only(eachmatch(x...)) |> x -> parse.(Int, x.captures)

    function nth(r, c)
        if c == 1
            r == 1 ? 1 : nth(1, r - 1)
        else
            nth(r + c - 1, 1) + c
        end
    end

    code₀ = 20151125

    x = 252533
    p = nth(r, c) - 1
    m = 33554393

    result₁ = code₀ * powermod(x, p, m) % m

    # @assert result₁ == 8997277

    result₁, nothing
end

export day25
