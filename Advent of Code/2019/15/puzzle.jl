function day15()
    program = [vec(readdlm("./15/input.txt", ',', Int)) ; zeros(Int, 1000)]

    function next_pos(pos::CartesianIndex, dir::Int)
        dir == 1 && return pos + CartesianIndex( 0, -1)
        dir == 2 && return pos + CartesianIndex( 0,  1)
        dir == 3 && return pos + CartesianIndex(-1,  0)
        dir == 4 && return pos + CartesianIndex( 1,  0)
    end

    # Helper data-structures
    droid, steps = CartesianIndex(0, 0), 0
    # Add droid's starting position
    area = Dict(droid => ('.', 0))
    # Last input sent
    last_input = 0

    counter = 0
    patience = 10_000_000
    patience_val = 0

    result₁ = nothing

    function compute()
        # Julia is 1-indexed
        pos(x) = x + 1
        get(x) = program[pos(x)]
        set!(x, value) = (program[pos(x)] = value)
        get_digit(number, pos) = number ÷ 10^(pos - 1) % 10

        # Execute Intcode program
        i = 0
        rel_base = 0
        while get(i) != 99
            instruction = get(i)
            opcode = get_digit(instruction, 1)
            mode_1 = get_digit(instruction, 3)
            mode_2 = get_digit(instruction, 4)
            mode_3 = get_digit(instruction, 5)

            # @show opcode mode_1 mode_2 mode_3
            # println("$(instruction) → mode=$(mode_3) mode=$(mode_2) mode=$(mode_1) op=$(opcode)")

            if opcode == 1      # Opcode: sum
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                val2 = mode_2 == 1 ? get(i + 2) : mode_2 == 0 ? get(get(i + 2)) : get(rel_base + get(i + 2))
                dest = mode_3 == 0 ? get(i + 3) : rel_base + get(i + 3)
                set!(dest, val1 + val2)

            elseif opcode == 2  # Opcode: product
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                val2 = mode_2 == 1 ? get(i + 2) : mode_2 == 0 ? get(get(i + 2)) : get(rel_base + get(i + 2))
                dest = mode_3 == 0 ? get(i + 3) : rel_base + get(i + 3)
                set!(dest, val1 * val2)

            elseif opcode == 3  # Opcode: input
                dest = mode_1 == 0 ? get(i + 1) : rel_base + get(i + 1)
                # Pick a random direction to explore
                last_input = rand(1:4)
                set!(dest, last_input)
                # println("[INPUT] $(last_input)")

            elseif opcode == 4  # Opcode: output
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                if val1 == 0
                    area[next_pos(droid, last_input)] = ('#', -1)
                elseif val1 in [1, 2]
                    # Move one step in requested direction
                    droid = next_pos(droid, last_input)
                    steps += 1
                    # Update area map
                    if any(c->c[1] == droid, area)
                        # Get previously visited spot's value
                        _, spot_steps = first(filter(c->c[1] == droid, area))[2]
                        # @show spot_steps
                        # @show spot[2]
                        if steps < spot_steps
                            area[droid] = (val1 == 2 ? 'O' : '.', steps)
                        elseif steps > spot_steps
                            steps = spot_steps
                        end
                    else
                        area[droid] = (val1 == 2 ? 'O' : '.', steps)
                    end
                    # Check for oxygen system
                    if val1 == 2 && isnothing(result₁)
                        println("Oxygen system has been found!")
                        println("Droid took $(area[droid][2]) steps")
                        result₁ = area[droid][2]
                    end
                else
                    println("Received unexpected output $(val1)")
                end
                # println("[OUTPUT] $(val1)")

            elseif opcode == 5  # Opcode: jump-if-true
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                val2 = mode_2 == 1 ? get(i + 2) : mode_2 == 0 ? get(get(i + 2)) : get(rel_base + get(i + 2))
                (val1 != 0) && (i = val2; continue)

            elseif opcode == 6  # Opcode: jump-if-false
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                val2 = mode_2 == 1 ? get(i + 2) : mode_2 == 0 ? get(get(i + 2)) : get(rel_base + get(i + 2))
                (val1 == 0) && (i = val2; continue)

            elseif opcode == 7  # Opcode: less than
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                val2 = mode_2 == 1 ? get(i + 2) : mode_2 == 0 ? get(get(i + 2)) : get(rel_base + get(i + 2))
                dest = mode_3 == 0 ? get(i + 3) : rel_base + get(i + 3)
                set!(dest, Int(val1 < val2))

            elseif opcode == 8  # Opcode: equals
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                val2 = mode_2 == 1 ? get(i + 2) : mode_2 == 0 ? get(get(i + 2)) : get(rel_base + get(i + 2))
                dest = mode_3 == 0 ? get(i + 3) : rel_base + get(i + 3)
                set!(dest, Int(val1 == val2))

            elseif opcode == 9  # Opcode: relative base offset
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                rel_base += val1
            end

            # @show program

            # Move to next instruction
            if opcode ∈ [1, 2, 7, 8]
                i += 4
            elseif opcode ∈ [3, 4, 9]
                i += 2
            elseif opcode ∈ [5, 6]
                i += 3
            end

            # Continue exploration
            # for a certain patience
            if !isnothing(result₁)
                if length(area) ≠ patience_val
                    patience_val = length(area)
                    counter = 0
                else
                    counter += 1
                    counter > patience && break
                end
            end
        end
    end

    compute()

    function print_area(d::Array{Char})
        for r in eachcol(d)
            for x in r
                print(x)
            end
            println()
        end
    end

    top_left_corner = CartesianIndex([minimum(i->i.I[1], keys(area)), minimum(i->i.I[2], keys(area))]...)
    bottom_right_corner = CartesianIndex([maximum(i->i.I[1], keys(area)), maximum(i->i.I[2], keys(area))]...)
    area_size = bottom_right_corner - top_left_corner + CartesianIndex(1, 1)
    area_cp = fill(' ', (area_size.I...))
    for (k, v) in area; area_cp[k - top_left_corner + CartesianIndex(1, 1)] = v[1] end
    print_area(area_cp)

    # Flood area with oxygen
    visited = [(findfirst(==('O'), area_cp), 0)]
    flood_queue = [(findfirst(==('O'), area_cp), 0)]
    function add_to_queue(x::CartesianIndex, dist::Int)
        if area_cp[x] ≠ '#' && !any(v->x == v[1], visited)
            push!(visited, (x, dist))
            push!(flood_queue, (x, dist))
        end
    end
    while !isempty(flood_queue)
        idx, dist = popfirst!(flood_queue)
        add_to_queue(idx + CartesianIndex( 0, -1), dist + 1)
        add_to_queue(idx + CartesianIndex( 0,  1), dist + 1)
        add_to_queue(idx + CartesianIndex(-1,  0), dist + 1)
        add_to_queue(idx + CartesianIndex( 1,  0), dist + 1)
    end
    result₂ = maximum(x->x[2], visited)

    result₁, result₂
end

export day15
