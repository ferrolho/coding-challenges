function day18()
    input = joinpath(@__DIR__, "input.txt")
    state₀ = mapreduce(collect, hcat, eachline(input))

    neighbours = let
        steps = filter(!iszero, CartesianIndices(ntuple(_ -> -1:1, 2)))
        (A, I) -> map(steps) do step
            checkbounds(Bool, A, I + step) ? A[I + step] : nothing
        end
    end

    function turn_on_corners(state)
        state[1,1] = state[1,end] = state[end,1] = state[end,end] = '#'
    end

    function solve(state⁺, steps; part₂=false)
        state⁺ = copy(state⁺)
        state⁻ = similar(state⁺)  # We need to track the previous state

        part₂ && turn_on_corners(state⁺)

        for step = 1:steps
            copyto!(state⁻, state⁺)

            @inbounds for i ∈ CartesianIndices(state⁺)

                if state⁻[i] == ('.')
                    n = count(==('#'), neighbours(state⁻, i))
                    n == 3 && (state⁺[i] = '#')  # turns on

                elseif state⁻[i] == ('#')
                    n = count(==('#'), neighbours(state⁻, i))
                    !(2 <= n <= 3) && (state⁺[i] = '.')  # turns off

                end
            end

            part₂ && turn_on_corners(state⁺)
        end

        count(==('#'), state⁺)
    end

    result₁ = solve(state₀, 100, part₂=false)
    result₂ = solve(state₀, 100, part₂=true)

    # @assert result₁ == 1061
    # @assert result₂ == 1006

    result₁, result₂
end

export day18
