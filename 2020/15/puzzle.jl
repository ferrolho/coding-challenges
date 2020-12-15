function day15()
    input = joinpath(@__DIR__, "input.txt")
    start = vec(readdlm(input, ',', Int))

    memory = Dict{Int,Array{Int,1}}(start .=> [[i] for i = 1:length(start)])

    prev = last(start)
    curr = nothing

    result₁ = nothing
    result₂ = nothing

    for i = length(start) + 1:30000000

        if length(memory[prev]) == 1
            curr = 0
        else
            tₙ   = memory[prev][end]
            tₙ₋₁ = memory[prev][end - 1]
            curr = tₙ - tₙ₋₁
        end

        (curr ∉ keys(memory)) && (memory[curr] = [])
        push!(memory[curr], i)

        (i ==     2020) && (result₁ = curr)
        (i == 30000000) && (result₂ = curr)

        prev = curr

    end

    result₁, result₂
end

export day15
