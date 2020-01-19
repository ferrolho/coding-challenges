function day21()
    function compute(inputs::Array)
        # Julia is 1-indexed
        pos(x) = x + 1
        get(x) = program[pos(x)]
        set!(x, value) = (program[pos(x)] = value)
        get_digit(number, pos) = number ÷ 10^(pos - 1) % 10

        # Execute Intcode program
        i = 0
        rel_base = 0
        println("Starting computer...")
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
                # print("[INPUT] ")
                val1 = popfirst!(inputs)
                set!(dest, val1)
                print("$(val1 |> Char)")

            elseif opcode == 4  # Opcode: output
                val1 = mode_1 == 1 ? get(i + 1) : mode_1 == 0 ? get(get(i + 1)) : get(rel_base + get(i + 1))
                if val1 ≥ 128  # Max ASCII value
                    println("Amount of hull damage: $(val1)\n")
                    push!(results, val1)
                else
                    push!(output, val1)
                    print(val1 |> Char)
                end

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

    # Read Intcode program
    day_input = [vec(readdlm("./21/input.txt", ',', Int)) ; zeros(Int, 10000)]

    results = []

    # Script to make the droid jump
    springscript = ["NOT C J"  # J = abcd[3] == '.'
                    "AND D J"  # J = abcd[4] == '#' && J
                               # if "??.#" then J = true
                    "NOT A T"  # T = abcd[1] == '.'
                               # if ".???" then T = true
                    "OR  T J"  # J = T || J
                    "WALK"
                    ""]

    # Joining instructions with "\n"
    springscript = join(springscript, "\n")
    inputs = [Int(c) for c in springscript]

    # Run program
    program = day_input |> copy
    output = Char[]  # Output from Intcode will be saved here
    compute(inputs |> copy)

    # Script to make the droid jump
    springscript = [# Let us consider to jump right now:
                    "NOT E T \n OR  T J"  # if there is a hole immediately after (E)
                    "NOT H T \n AND T J"  # and nowhere to land for the 2nd jump (H)
                    "NOT J J"             # give up from jumping! (sets J = False)

                    "NOT A T \n OR  A T"  # T = true (this will act as a flag)

                    "AND A T \n AND B T \n AND C T"  # T = true iff no hole in A|B|C
                    "NOT T T"                        # T = true if there is a hole in A|B|C
                    "AND D T"                        # T still true iff D is '#'

                    "AND T J"  # JUMP only if the two conditions above are true

                    "RUN"
                    ""]

    # Joining instructions with "\n"
    springscript = join(springscript, "\n")
    inputs = [Int(c) for c in springscript]

    # Run program
    program = day_input |> copy
    output = Char[]  # Output from Intcode will be saved here
    compute(inputs |> copy)

    return tuple(results...)
end

export day21
