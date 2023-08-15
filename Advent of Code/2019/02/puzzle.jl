function day2_part1(program, noun, verb)
    # Julia is 1-indexed
    pos(x) = x + 1
    get(x) = program[pos(x)]
    set!(x, value) = (program[pos(x)] = value)

    # Restore the gravity assist program
    set!(1, noun)
    set!(2, verb)

    # Execute Intcode program
    i = 0
    while get(i) != 99
        opcode = get(i)
        val1 = get(i + 1)
        val2 = get(i + 2)
        dest = get(i + 3)

        # @show opcode val1 val2 dest

        if opcode == 1
            set!(dest, get(val1) + get(val2))
        elseif opcode == 2
            set!(dest, get(val1) * get(val2))
        end

        # Move to next instruction
        i += 4
    end

    get(0)
end

function day2()
    program = vec(readdlm("./02/input.txt", ',', Int))
    result_1 = day2_part1(copy(program), 12, 2)

    result_2 = 0
    for noun = 0:99, verb = 0:99  # Brute force
        output = day2_part1(copy(program), noun, verb)
        if output == 19690720
            result_2 = 100 * noun + verb
            break
        end
    end

    result_1, result_2
end

export day2
