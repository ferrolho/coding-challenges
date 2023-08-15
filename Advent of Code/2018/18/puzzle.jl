function day18()
    input = joinpath(@__DIR__, "input.txt")
    state⁺ = mapreduce(collect, hcat, eachline(input))

    function resourcevalue(state)
        trees = count(==('|'), state)
        lumberyards = count(==('#'), state)
        trees * lumberyards
    end

    select(A, I, neighbours) = map(neighbours) do step
        checkbounds(Bool, A, I + step) ? A[I + step] : nothing
    end

    neighbours = filter(!iszero, CartesianIndices(ntuple(_ -> -1:1, 2)))
    state⁻ = similar(state⁺)  # We need to track the previous state

    minute2value = map(1:1000) do minute
        copyto!(state⁻, state⁺)

        @inbounds for i ∈ CartesianIndices(state⁺)

            if state⁻[i] == ('.')
                trees = count(==('|'), select(state⁻, i, neighbours))
                (trees >= 3) && (state⁺[i] = '|')  # becomes trees

            elseif state⁻[i] == ('|')
                lumberyards = count(==('#'), select(state⁻, i, neighbours))
                (lumberyards >= 3) && (state⁺[i] = '#')  # becomes a lumberyard

            elseif state⁻[i] == ('#')
                trees = count(==('|'), select(state⁻, i, neighbours))
                lumberyards = count(==('#'), select(state⁻, i, neighbours))
                !(lumberyards >= 1 && trees >= 1) && (state⁺[i] = '.')  # becomes open

            end
        end

        resourcevalue(state⁺)
    end

    result₁ = minute2value[10]
    result₂ = minute2value[801:end][mod1(1_000_000_000, 200)]

    # @assert result₁ == 589931
    # @assert result₂ == 222332

    result₁, result₂
end

export day18
