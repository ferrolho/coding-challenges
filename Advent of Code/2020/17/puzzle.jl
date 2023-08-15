function day17()
    input = joinpath(@__DIR__, "input.txt")
    state₀ = mapreduce(collect, hcat, eachline(input))

    isactive = ==('#')

    select(A, I, neighbours) = map(neighbours) do step
        checkbounds(Bool, A, I + step) ? A[I + step] : return nothing
    end

    function solve(state₀; cycles=6, dims=3)
        neighbours = filter(!iszero, CartesianIndices(ntuple(_ -> -1:1, dims)))

        state₀ = reshape(state₀, size(state₀)..., fill(1, dims - 2)...)

        state⁺ = fill('.', fill(19, dims)...)  # Create world
        offset = cld.(size(state⁺), 2) .- cld.(size(state₀), 2)
        Rdest = CartesianIndices(state₀) .+ CartesianIndex(offset)
        state⁺[Rdest] = state₀  # Copy initial state to the center

        state⁻ = similar(state⁺)  # We need to track the previous state

        for _ = 1:cycles

            copyto!(state⁻, state⁺)

            @inbounds for i ∈ CartesianIndices(state⁺)

                if state⁻[i] |> isactive
                    active = count(isactive, select(state⁻, i, neighbours))
                    !(2 <= active <= 3) && (state⁺[i] = '.')  # becomes empty

                else
                    active = count(isactive, select(state⁻, i, neighbours))
                    (active == 3) && (state⁺[i] = '#')  # becomes active

                end
            end
        end

        count(isactive, state⁺)
    end

    result₁ = solve(state₀, dims=3)
    result₂ = solve(state₀, dims=4)

    result₁, result₂
end

export day17
