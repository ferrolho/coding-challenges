function day17()
    input = joinpath(@__DIR__, "input.txt")
    state₀ = mapreduce(collect, hcat, eachline(input))

    neighbours3D = [(i, j, k)
                    for i = -1:1, j = -1:1, k = -1:1
                    if !all(iszero, (i, j, k))] .|> CartesianIndex

    neighbours4D = [(i, j, k, l)
                    for i = -1:1, j = -1:1, k = -1:1, l = -1:1
                    if !all(iszero, (i, j, k, l))] .|> CartesianIndex

    isactive = ==('#')

    select(A, I, neighbours) = map(neighbours) do step
        checkbounds(Bool, A, I + step) ? A[I + step] : return nothing
    end

    function solve(state₀, neighbours; cycles=6)
        dims = length(first(neighbours))  # Infer dimensionality from `neighbours`

        state₀ = reshape(state₀, size(state₀)..., fill(1, dims - 2)...)

        state⁺ = fill('.', fill(19, dims)...)  # Create world
        offset = cld.(size(state⁺), 2) .- cld.(size(state₀), 2)
        Rdest = CartesianIndices(state₀) .+ CartesianIndex(offset)
        state⁺[Rdest] = state₀  # Copy initial state to the center

        state⁻ = similar(state⁺)  # We need to track the previous state

        for i = 1:cycles

            copyto!(state⁻, state⁺)

            for i ∈ CartesianIndices(state⁺)

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

    result₁ = solve(state₀, neighbours3D)
    result₂ = solve(state₀, neighbours4D)

    @assert result₁ == 265
    @assert result₂ == 1936

    result₁, result₂
end

export day17
