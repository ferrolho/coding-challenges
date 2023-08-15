function day17()
    function compute(inputs::Array)
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
                val1 = popfirst!(inputs)
                set!(dest, val1)
                # println("[INPUT] $(val1)")

            elseif opcode == 4  # Opcode: output
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                push!(output, val1)
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
        end
    end

    # Helper functions
    show_grid(x) = foreach(x->println(x...), eachcol(x))
    isscaffold(A, I) = checkbounds(Bool, A, I) && A[I] == '#'
    isintersection(A, I) = count(x->isscaffold(A, I + x), [CartesianIndex( 0, 0),
                                                           CartesianIndex( 1, 0),
                                                           CartesianIndex( 0, 1),
                                                           CartesianIndex(-1, 0),
                                                           CartesianIndex( 0,-1)]) == 5

    # Read Intcode program
    input = [vec(readdlm("./17/input.txt", ',', Int)) ; zeros(Int, 10000)]

    # Run program
    program = input |> copy
    output = Char[]  # Output from Intcode will be saved here
    compute([])

    test_grid = hcat(collect.(["..#.........."
                               "..#.........."
                               "#######...###"
                               "#.#...#...#.#"
                               "#############"
                               "..#...#...#.."
                               "..#####...^.."])...)

    # Parse camera output
    grid = hcat(collect.(output |> join |> split)...)
    # grid = test_grid
    # show_grid(grid)
    grid_length = output |> length

    xs = filter(x->isintersection(grid, x), CartesianIndices(grid))
    map!(x->x - CartesianIndex(1, 1), xs, xs)  # Julia is 1-indexed...
    result₁ = [*(x.I...) for x in xs] |> sum

    # Part 2
    routine = "A,B,A,B,C,A,B,C,A,C\n"
    functions = Dict('A' => "R,6,L,6,L,10\n",
                     'B' => "L,8,L,6,L,10,L,6\n",
                     'C' => "R,6,L,8,L,10,R,6\n")
    rules = [c |> Int for c ∈ join([routine, functions['A'], functions['B'], functions['C'], "n\n"])]

    # Run program
    program = input |> copy
    program[1] = 2  # wake up vacuum robot
    output = Char[]  # Output from Intcode will be saved here
    compute(rules)
    # output |> join |> split .|> println
    result₂ = output |> last |> Int

    result₁, result₂
end

export day17
