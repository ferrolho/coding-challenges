function day7()
    program = vec(readdlm("./07/input.txt", ',', Int))

    function compute(state, inputs::Array)
        # Restore computer state
        program, i = state

        # This will carry the latest output value
        output = 0

        # Helper functions
        pos(x) = x + 1 # Julia is 1-indexed
        get(x) = program[pos(x)]
        set!(x, value) = (program[pos(x)] = value)
        get_digit(number, pos) = number ÷ 10^(pos-1) % 10

        # Execute Intcode program
        while get(i) != 99
            instruction = get(i)
            opcode = get_digit(instruction, 1)
            mode_1 = Bool(get_digit(instruction, 3))
            mode_2 = Bool(get_digit(instruction, 4))
            mode_3 = Bool(get_digit(instruction, 5))

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

            elseif opcode == 4  # Opcode: output
                val1 = mode_1 ? get(i + 1) : get(get(i + 1))
                output = val1
                i += 2  # Move to next instruction
                return (program, i), [output]

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

            # Move to next instruction
            if opcode ∈ [1, 2, 7, 8]
                i += 4
            elseif opcode ∈ [3, 4]
                i += 2
            elseif opcode ∈ [5, 6]
                i += 3
            end
        end

        # Return after software has halted
        return (program, i), []
    end

    # Every combination of phase settings on the amplifiers.
    phases = [(a,b,c,d,e) for a=0:4 for b=0:4 for c=0:4 for d=0:4 for e=0:4
                          if length(unique((a,b,c,d,e))) == 5]

    # Try each phase combination
    thruster_signals = []
    for phase in phases
        _, out₁ = compute((copy(program), 0), [phase[1] ; [0] ])
        _, out₂ = compute((copy(program), 0), [phase[2] ; out₁])
        _, out₃ = compute((copy(program), 0), [phase[3] ; out₂])
        _, out₄ = compute((copy(program), 0), [phase[4] ; out₃])
        _, out₅ = compute((copy(program), 0), [phase[5] ; out₄])
        append!(thruster_signals, out₅)
    end
    result₁ = maximum(thruster_signals)


    # Every combination of phase settings on the amplifiers.
    phases = [(a,b,c,d,e) for a=5:9 for b=5:9 for c=5:9 for d=5:9 for e=5:9
                          if length(unique((a,b,c,d,e))) == 5]

    # Try each phase combination
    thruster_signals = []
    for phase in phases
        signal = 0  # Will carry the last signal to the thrusters
        state₁, out₁ = compute((copy(program), 0), [phase[1] ; [0] ])
        state₂, out₂ = compute((copy(program), 0), [phase[2] ; out₁])
        state₃, out₃ = compute((copy(program), 0), [phase[3] ; out₂])
        state₄, out₄ = compute((copy(program), 0), [phase[4] ; out₃])
        state₅, out₅ = compute((copy(program), 0), [phase[5] ; out₄])
        while !isempty(out₅)
            state₁, out₁ = compute(state₁, out₅)
            state₂, out₂ = compute(state₂, out₁)
            state₃, out₃ = compute(state₃, out₂)
            state₄, out₄ = compute(state₄, out₃)
            state₅, out₅ = compute(state₅, out₄)
            !isempty(out₅) && (signal = out₅[1])
        end
        append!(thruster_signals, signal)
    end
    result₂ = maximum(thruster_signals)

    result₁, result₂
end

export day7
