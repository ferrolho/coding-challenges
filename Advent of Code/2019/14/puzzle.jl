abstract type Day14_Chemical end

struct ChemInput <: Day14_Chemical
    name::String
    amount::Int
    ChemInput(s) = split(s) |> x->new(x[2], parse(Int, x[1]))
end

struct ChemOutput <: Day14_Chemical
    name::String
    amount::Int
    ChemOutput(s) = split(s) |> x->new(x[2], parse(Int, x[1]))
end

function day14()
    reactions = split.(readlines("./14/input.txt"), " => ")
    ξ = Dict(ChemOutput(x[2]) => ChemInput.(split(x[1], ", "))
             for x ∈ reactions)

    function cost(c::Day14_Chemical)
        # println("Producing $(c.name)")
        sum([x.name == "ORE" ? x.amount : cost(x.name, x.amount) for x ∈ ξ[c]])
    end

    function cost(elem::String, amount::Int)
        # Find reaction to produce `elem`
        ξₖ = filter(k->k.name == elem, keys(ξ)) |> first
        # How many reactions needed given current stock?
        n = ceil(Int, max(0, amount - stock[ξₖ.name]) / ξₖ.amount)
        # Update stock
        stock[ξₖ.name] = (n * ξₖ.amount + stock[ξₖ.name]) - amount
        # Execute `n` reactions
        n == 0 ? 0 : sum([cost(ξₖ) for _ = 1:n])
    end

    stock = DefaultDict{String,Int}(0)
    result₁ = cost("FUEL", 1)

    stock = DefaultDict{String,Int}(0)
    cargo_avail = 1_000_000_000_000

    step = 10_000
    cost_step = cost("FUEL", step)
    stock_step = copy(stock)

    max_fuel = 0
    while cargo_avail > 5*cost_step
        # @show cargo_avail
        # @show stock
        max_fuel += step
        cargo_avail -= cost_step
        for k in keys(stock); stock[k] += stock_step[k] end
    end
    while cargo_avail > 0
        if max_fuel % 100 == 0
            println("cargo_avail = $(cargo_avail)    max_fuel = $(max_fuel)")
            # @show cargo_avail
        end
        cargo_avail -= cost("FUEL", 1)
        max_fuel += 1
    end
    # @show stock
    result₂ = max_fuel-1

    result₁, result₂
end

export day14
