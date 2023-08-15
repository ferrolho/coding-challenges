function day11_parseinput()
    input = joinpath(@__DIR__, "input.txt")
    mapreduce(collect, hcat, eachline(input)) |>
    permutedims .|> x -> parse(Int, x)
end

function day11_neighbours(A, ci)
    steps = filter(!iszero, CartesianIndices(ntuple(_ -> -1:1, 2)))
    [ci + step for step in steps if checkbounds(Bool, A, ci + step)]
end

function day11(input)
    state = copy(input)
    total_flashes = 0

    result₁ = 0
    result₂ = 0

    flashed = Set(CartesianIndex{2}[])

    for step = Iterators.countfrom(1)
        state .+= 1

        empty!(flashed)

        while true
            overpowered = findall(>(9), state)
            isempty(overpowered) && break

            filter!(∉(flashed), overpowered)
            union!(flashed, overpowered)
            state[overpowered] .= 0

            for ci ∈ overpowered
                neighbours = day11_neighbours(state, ci)
                filter!(∉(flashed), neighbours)
                state[neighbours] .+= 1
            end
        end

        total_flashes += length(flashed)

        (step == 100) && (result₁ = total_flashes)
        (length(flashed) == length(state)) && (result₂ = step)

        all(!iszero, (result₁, result₂)) && break
    end

    result₁, result₂
end

@testset "day11" begin
    input = day11_parseinput()
    result₁, result₂ = day11(input)

    @test result₁ == 1647
    @test result₂ == 348
end

export day11_parseinput, day11
