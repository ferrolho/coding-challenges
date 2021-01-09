function day20()
    input = joinpath(@__DIR__, "input.txt")
    target = parse(Int, readline(input))

    houses = 1_000_000
    counters = zeros(Int, houses)
    for elfᵢ = 1:houses
        housesᵢ = range(elfᵢ, step=elfᵢ, stop=houses)
        counters[housesᵢ] .+= 10 * elfᵢ
    end
    result₁ = findfirst(>=(target), counters)

    houses = 100_000_000
    counters = zeros(Int, houses)
    for elfᵢ = 1:1_000_000
        housesᵢ = range(elfᵢ, step=elfᵢ, length=50)
        counters[housesᵢ] .+= 11 * elfᵢ
    end
    result₂ = findfirst(>=(target), counters)

    # @assert result₁ == 831600
    # @assert result₂ == 884520

    result₁, result₂
end

export day20
