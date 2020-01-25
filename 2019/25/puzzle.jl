function day25()
    program = [vec(readdlm("./25/input.txt", ',', Int)) ; zeros(Int, 1000)]

    function compute(inputs::Array)
        # Julia is 1-indexed
        pos(x) = x + 1
        get(x) = program[pos(x)]
        set!(x, value) = (program[pos(x)] = value)
        get_digit(number, pos) = number ÷ 10^(pos-1) % 10

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
                if isempty(inputs)
                    test = string(readline(stdin), "\n")
                    append!(inputs, [c |> Int for c in test])
                end
                val1 = popfirst!(inputs)
                set!(dest, val1)

            elseif opcode == 4  # Opcode: output
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                print(val1 |> Char)

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

    compute([])
end

export day25
