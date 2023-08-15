function day19()
    input = joinpath(@__DIR__, "input.txt")

    # Addition
    addr!(regs, a, b, c) = regs[c + 1] = regs[a + 1] + regs[b + 1]
    addi!(regs, a, b, c) = regs[c + 1] = regs[a + 1] + b

    # Multiplication
    mulr!(regs, a, b, c) = regs[c + 1] = regs[a + 1] * regs[b + 1]
    muli!(regs, a, b, c) = regs[c + 1] = regs[a + 1] * b

    # Bitwise AND
    banr!(regs, a, b, c) = regs[c + 1] = regs[a + 1] & regs[b + 1]
    bani!(regs, a, b, c) = regs[c + 1] = regs[a + 1] & b

    # Bitwise OR
    borr!(regs, a, b, c) = regs[c + 1] = regs[a + 1] | regs[b + 1]
    bori!(regs, a, b, c) = regs[c + 1] = regs[a + 1] | b

    # Assignment
    setr!(regs, a, b, c) = regs[c + 1] = regs[a + 1]
    seti!(regs, a, b, c) = regs[c + 1] = a

    # Greater-than testing
    gtir!(regs, a, b, c) = regs[c + 1] = Int(a > regs[b + 1])
    gtri!(regs, a, b, c) = regs[c + 1] = Int(regs[a + 1] > b)
    gtrr!(regs, a, b, c) = regs[c + 1] = Int(regs[a + 1] > regs[b + 1])

    # Equality testing
    eqir!(regs, a, b, c) = regs[c + 1] = Int(a == regs[b + 1])
    eqri!(regs, a, b, c) = regs[c + 1] = Int(regs[a + 1] == b)
    eqrr!(regs, a, b, c) = regs[c + 1] = Int(regs[a + 1] == regs[b + 1])

    op2func = Dict("addr" => addr!, "addi" => addi!,
                   "mulr" => mulr!, "muli" => muli!,
                   "banr" => banr!, "bani" => bani!,
                   "borr" => borr!, "bori" => bori!,
                   "setr" => setr!, "seti" => seti!,
                   "gtir" => gtir!, "gtri" => gtri!, "gtrr" => gtrr!,
                   "eqir" => eqir!, "eqri" => eqri!, "eqrr" => eqrr!)

    ip, rawinstructions = readlines(input) |>
                          x -> (parse(Int, split(x[1]) |> last), x[2:end])

    instructions = map(rawinstructions) do rawinstruction
        tokens = rawinstruction |> split |>
                 x -> (x[1], parse.(Int, x[2:4]))
    end

    getip(registers) = registers[ip + 1] + 1
    incip!(registers, inc=1) = registers[ip + 1] += inc
    setip!(registers, dest) = registers[ip + 1] = dest - 1

    function compute!(registers)
        while 1 <= getip(registers) <= length(instructions)
            if getip(registers) == 4
                # Reverse engineered code (messy)
                if registers[3] * registers[5] == registers[6]
                    registers[1] += registers[5]
                    incip!(registers)
                else
                    if registers[3] < registers[6] ÷ registers[5]
                        registers[3] = registers[6] ÷ registers[5] - 1
                    end

                    registers[3] += 1  # count something

                    if registers[3] > registers[6] ÷ registers[5]
                        setip!(registers, 13)  # goto 13 (if cond)
                    else
                        setip!(registers, 4)  # goto 4 (default)
                    end
                end
            else
                op, args = instructions[getip(registers)]
                op2func[op](registers, args...)
                incip!(registers)
            end
        end
        registers
    end

    result₁ = compute!([0,0,0,0,0,0])[1]
    result₂ = compute!([1,0,0,0,0,0])[1]

    # @assert result₁ == 1430
    # @assert result₂ == 14266944

    result₁, result₂
end

export day19
