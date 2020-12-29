function day12()
    input = joinpath(@__DIR__, "input.txt")
    a, b = split(read(input, String), "\n\n")

    plants = findall(==('#'), replace(a, "initial state: " => "")) .- 1

    rules = split.(split(b, '\n', keepempty=false), " => ") |>
            (x -> filter(x -> x[2] == "#", x)) .|> first |>
            (x -> findall.(==('#'), x)) .|>
            (x -> (x...,) .- 3) |> Set

    neighbours(pot) = pot .+ (-2:2)
    spawns(p) = (sort(plants ∩ neighbours(p) .- p)...,) ∈ rules

    function simulate(generations)
        result = zeros(Int16, generations)
        for gen = 1:generations
            l, r = extrema(plants) .+ (-2, 2)
            plants = Set{Int16}(p for p = l:r if spawns(p))
            result[gen] = sum(plants)
        end
        result
    end

    N = 150
    result = simulate(N)
    calculate(n) = n < N ? result[n] : result[end] + 22 * (n - N)

    result₁ = calculate(20)
    result₂ = calculate(50_000_000_000)

    # @assert result₁ == 1991
    # @assert result₂ == 1100000000511

    result₁, result₂
end

export day12
