function day16()
    input = joinpath(@__DIR__, "input.txt")

    rawsamples, test = read(input, String) |>
                       x -> split(x, "\n\n\n\n") |>
                       x -> (split(x[1], "\n\n", keepempty=false),
                             split(x[2], "\n", keepempty=false))

    samples = map(rawsamples) do rawsample
        regs⁻, instruction, regs⁺ = split(rawsample, "\n")
        instruction = parse.(Int, split(instruction))
        m⁻ = eachmatch(r"Before: \[(\d+), (\d+), (\d+), (\d+)\]", regs⁻)
        m⁺ = eachmatch(r"After:  \[(\d+), (\d+), (\d+), (\d+)\]", regs⁺)
        regs⁻ = parse.(Int, only(m⁻).captures)
        regs⁺ = parse.(Int, only(m⁺).captures)
        instruction, regs⁻, regs⁺
    end

    # Addition
    addr!(regs, a, b, c) = (regs[c + 1] = regs[a + 1] + regs[b + 1]; regs)
    addi!(regs, a, b, c) = (regs[c + 1] = regs[a + 1] + b; regs)

    # Multiplication
    mulr!(regs, a, b, c) = (regs[c + 1] = regs[a + 1] * regs[b + 1]; regs)
    muli!(regs, a, b, c) = (regs[c + 1] = regs[a + 1] * b; regs)

    # Bitwise AND
    banr!(regs, a, b, c) = (regs[c + 1] = regs[a + 1] & regs[b + 1]; regs)
    bani!(regs, a, b, c) = (regs[c + 1] = regs[a + 1] & b; regs)

    # Bitwise OR
    borr!(regs, a, b, c) = (regs[c + 1] = regs[a + 1] | regs[b + 1]; regs)
    bori!(regs, a, b, c) = (regs[c + 1] = regs[a + 1] | b; regs)

    # Assignment
    setr!(regs, a, b, c) = (regs[c + 1] = regs[a + 1]; regs)
    seti!(regs, a, b, c) = (regs[c + 1] = a; regs)

    # Greater-than testing
    gtir!(regs, a, b, c) = (regs[c + 1] = Int(a > regs[b + 1]); regs)
    gtri!(regs, a, b, c) = (regs[c + 1] = Int(regs[a + 1] > b); regs)
    gtrr!(regs, a, b, c) = (regs[c + 1] = Int(regs[a + 1] > regs[b + 1]); regs)

    # Equality testing
    eqir!(regs, a, b, c) = (regs[c + 1] = Int(a == regs[b + 1]); regs)
    eqri!(regs, a, b, c) = (regs[c + 1] = Int(regs[a + 1] == b); regs)
    eqrr!(regs, a, b, c) = (regs[c + 1] = Int(regs[a + 1] == regs[b + 1]); regs)

    # -- Part One -- #

    opcode_to_op = Dict(0:15 .=> map(0:15) do opcode
        opcode_samples = filter(x -> x[1][1] == opcode, samples)

        candidates = Set([addr!, addi!, mulr!, muli!,
                          banr!, bani!, borr!, bori!, setr!, seti!,
                          gtir!, gtri!, gtrr!, eqir!, eqri!, eqrr!,])

        filter(candidates) do op
            map(opcode_samples) do (instruction, regs⁻, regs⁺)
                _, a, b, c = instruction
                op(copy(regs⁻), a, b, c) == regs⁺
            end |> all
        end
    end)

    ambiguous_opcodes = Set(k for (k, v) ∈ opcode_to_op if length(v) >= 3)

    result₁ = count(samples) do (instruction, _, _)
        opcode, _, _, _ = instruction
        opcode ∈ ambiguous_opcodes
    end

    # -- Part Two -- #

    while !all(isone ∘ length, values(opcode_to_op))
        determined = reduce(∪, v for v ∈ values(opcode_to_op) if length(v) == 1)
        foreach(values(opcode_to_op)) do v
            length(v) > 1 && setdiff!(v, determined)
        end
    end

    registers = [0, 0, 0, 0]  # The device has four registers

    for instruction ∈ test
        opcode, in₁, in₂, out = parse.(Int, split(instruction))
        only(opcode_to_op[opcode])(registers, in₁, in₂, out)
    end

    result₂ = registers[1]

    # @assert result₁ == 618
    # @assert result₂ == 514

    result₁, result₂
end

export day16
