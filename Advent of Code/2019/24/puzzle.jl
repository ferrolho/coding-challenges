function day24_part1(input)
    # Helper functions
    show_grid(x) = foreach(x->println(x...), eachcol(x))
    bug_at(A::Array, I::CartesianIndex) = checkbounds(Bool, A, I) && (A[I] == '#')
    count_adjacent(A::Array, I::CartesianIndex) =
        count(x->bug_at(A, I + x), [CartesianIndex( 1, 0), CartesianIndex(0, 1),
                                    CartesianIndex(-1, 0), CartesianIndex(0,-1)])

    gridᵢ = copy(input)
    gridᵢ₊₁ = copy(input)
    seen = Set([copy(gridᵢ₊₁)])

    for i = 1:100
        for i in CartesianIndices(gridᵢ)
            num_bugs = count_adjacent(gridᵢ, i)
            if gridᵢ[i] ≠ '.' && num_bugs ≠ 1
                gridᵢ₊₁[i] = '.'  # A bug dies
            elseif gridᵢ[i] ≠ '#' && num_bugs ∈ [1,2]
                gridᵢ₊₁[i] = '#'  # A bug is spawn
            end
        end

        # --- Print info
        # println("After $(i) minutes:")
        # show_grid(gridᵢ₊₁)
        # println()

        gridᵢ₊₁ ∈ seen && break
        push!(seen, copy(gridᵢ₊₁))
        gridᵢ[:] = gridᵢ₊₁
    end

    [2^(i - 1) for i in eachindex(gridᵢ₊₁) if gridᵢ₊₁[i] == '#'] |> sum
end

function day24_part2(input)
    # Helper functions
    show_grid(x) = foreach(x->println(x...), eachcol(x))
    function count_adjacent(dd::DefaultDict, k::Int, I::CartesianIndex)
        total = 0
        for (step, rs) ∈ zip([CartesianIndex( 1, 0), CartesianIndex(0, 1),
                              CartesianIndex(-1, 0), CartesianIndex(0,-1)],
                             [(1, :), (:, 1), (5, :), (:, 5)])
            idx = I + step
            # Index inside this level
            if checkbounds(Bool, dd[k], idx)
                if dd[k][idx] == '?'      # Linking to contained level
                    total += count(==('#'), dd[k + 1][rs...])
                elseif dd[k][idx] == '#'  # Normal level indexation
                    total += 1
                end
            # Index outside this level
            elseif dd[k - 1][CartesianIndex(3, 3) + step] == '#'
                total += 1
            end
        end
        total
    end

    erisᵢ = DefaultDict{Int,Array{Char}}(()->hcat(collect.(["....."
                                                            "....."
                                                            "..?.."
                                                            "....."
                                                            "....."])...))
    erisᵢ[0] = copy(input)

    for i = 1:200
        erisᵢ₊₁ = erisᵢ |> deepcopy
        lo, hi = erisᵢ |> keys |> extrema
        for k ∈ (lo - 1:hi + 1)
            for I in CartesianIndices(erisᵢ[k])
                I == CartesianIndex(3, 3) && continue
                num_bugs = count_adjacent(erisᵢ, k, I)
                if erisᵢ[k][I] == '#' && num_bugs ≠ 1
                    erisᵢ₊₁[k][I] = '.'  # A bug dies
                elseif erisᵢ[k][I] == '.' && num_bugs ∈ [1,2]
                    erisᵢ₊₁[k][I] = '#'  # A bug is spawn
                end
            end
        end
        erisᵢ = erisᵢ₊₁
    end

    # # --- Print info
    # for k ∈ keys(erisᵢ) |> collect |> sort
    #     println("Depth $(k):")
    #     show_grid(erisᵢ[k])
    #     println()
    # end

    count.(==('#'), values(erisᵢ)) |> sum
end

function day24()
    input = hcat(collect.(readdlm("./24/input.txt", String))...)
    result₁ = day24_part1(input)
    result₂ = day24_part2(input)
    result₁, result₂
end

export day24
