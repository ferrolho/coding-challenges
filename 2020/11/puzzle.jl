function day11()
    input = joinpath(@__DIR__, "input.txt")
    state = mapreduce(collect, hcat, eachline(input)) |> permutedims

    printstate(x) = foreach(x -> println(x...), eachrow(x))

    directions = CartesianIndex.([(-1, -1), (-1, 0), (-1, 1),
                                  ( 0, -1),          ( 0, 1),
                                  ( 1, -1), ( 1, 0), ( 1, 1)])

    function adjacent(A, I::CartesianIndex)
        map(directions) do dir
            checkbounds(Bool, A, I + dir) ? A[I + dir] : return nothing
        end
    end

    function visible(A, I::CartesianIndex)
        map(dir -> scan_dir(A, I, dir), directions)
    end

    function scan_dir(A, I, dir)
        !checkbounds(Bool, A, I + dir) && return nothing
        A[I + dir] == '.' ? scan_dir(A, I + dir, dir) : return A[I + dir]
    end

    function solve(state; tolerance=4, eval=adjacent)
        state = copy(state)
        prev_state = similar(state)

        while prev_state != state

            copyto!(prev_state, state)

            for i ∈ CartesianIndices(state)

                if state[i] == 'L'  # seat is empty
                    occupied = count(==('#'), eval(prev_state, i))
                    (occupied == 0) && (state[i] = '#')  # becomes occupied

                elseif state[i] == '#'  # seat is occupied
                    occupied = count(==('#'), eval(prev_state, i))
                    (occupied >= tolerance) && (state[i] = 'L')  # becomes empty

                elseif state[i] == '.'  # floor
                    continue

                end
            end

            # printstate(state)
            # println()
        end

        count(==('#'), state)
    end

    result₁ = solve(state, tolerance=4, eval=adjacent)
    result₂ = solve(state, tolerance=5, eval=visible)

    # @btime $solve($state, tolerance=4, eval=$adjacent)
    # @btime $solve($state, tolerance=5, eval=$visible)

    result₁, result₂
end

export day11
