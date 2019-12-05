using DelimitedFiles

function day5(inputs::Array)
    program = vec(readdlm("./05/input.txt", ',', Int))

    # Julia is 1-indexed
    pos(x) = x + 1
    get(x) = program[pos(x)]
    set!(x, value) = (program[pos(x)] = value)
    get_digit(number, pos) = number ÷ 10^(pos-1) % 10

    # Execute Intcode program
    i = 0
    while get(i) != 99
        instruction = get(i)
        opcode = get_digit(instruction, 1)
        mode_1 = Bool(get_digit(instruction, 3))
        mode_2 = Bool(get_digit(instruction, 4))
        mode_3 = Bool(get_digit(instruction, 5))

        # @show opcode mode_1 mode_2 mode_3

        if opcode == 1      # Opcode: sum
            val1 = mode_1 ? get(i + 1) : get(get(i + 1))
            val2 = mode_2 ? get(i + 2) : get(get(i + 2))
            dest = get(i + 3)
            set!(dest, val1 + val2)

        elseif opcode == 2  # Opcode: product
            val1 = mode_1 ? get(i + 1) : get(get(i + 1))
            val2 = mode_2 ? get(i + 2) : get(get(i + 2))
            dest = get(i + 3)
            set!(dest, val1 * val2)

        elseif opcode == 3  # Opcode: input
            dest = get(i + 1)
            val1 = popfirst!(inputs)
            set!(dest, val1)
            println("[INPUT] $(val1)")

        elseif opcode == 4  # Opcode: output
            val1 = mode_1 ? get(i + 1) : get(get(i + 1))
            println("[OUTPUT] $(val1)")

        elseif opcode == 5  # Opcode: jump-if-true
            val1 = mode_1 ? get(i + 1) : get(get(i + 1))
            val2 = mode_2 ? get(i + 2) : get(get(i + 2))
            (val1 != 0) && (i = val2; continue)

        elseif opcode == 6  # Opcode: jump-if-false
            val1 = mode_1 ? get(i + 1) : get(get(i + 1))
            val2 = mode_2 ? get(i + 2) : get(get(i + 2))
            (val1 == 0) && (i = val2; continue)

        elseif opcode == 7  # Opcode: less than
            val1 = mode_1 ? get(i + 1) : get(get(i + 1))
            val2 = mode_2 ? get(i + 2) : get(get(i + 2))
            dest = get(i + 3)
            set!(dest, Int(val1 < val2))

        elseif opcode == 8  # Opcode: equals
            val1 = mode_1 ? get(i + 1) : get(get(i + 1))
            val2 = mode_2 ? get(i + 2) : get(get(i + 2))
            dest = get(i + 3)
            set!(dest, Int(val1 == val2))
        end

        # @show program

        # Move to next instruction
        if opcode ∈ [1, 2, 7, 8]
            i += 4
        elseif opcode ∈ [3, 4]
            i += 2
        elseif opcode ∈ [5, 6]
            i += 3
        end
    end
end

export day5
