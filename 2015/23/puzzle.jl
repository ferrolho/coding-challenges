function day23()
    input = joinpath(@__DIR__, "input.txt")
    program = readlines(input) .|> x -> split(replace(x, "," => ""))

    function compute!(registers; ip=1)
        while 1 <= ip <= length(program)
            tokens = program[ip]
            instruction = first(tokens)

            if instruction == "hlf"
                r = tokens[2]
                registers[r] ÷= 2
                ip += 1
            elseif instruction == "tpl"
                r = tokens[2]
                registers[r] *= 3
                ip += 1
            elseif instruction == "inc"
                r = tokens[2]
                registers[r] += 1
                ip += 1
            elseif instruction == "jmp"
                offset = parse(Int, tokens[2])
                ip += offset
            elseif instruction == "jie"
                r = tokens[2]
                offset = parse(Int, tokens[3])
                iseven(registers[r]) ? (ip += offset) : (ip += 1)
            elseif instruction == "jio"
                r = tokens[2]
                offset = parse(Int, tokens[3])
                isone(registers[r]) ? (ip += offset) : (ip += 1)
            end
        end

        registers
    end

    result₁ = compute!(Dict("a" => 0, "b" => 0))["b"]
    result₂ = compute!(Dict("a" => 1, "b" => 0))["b"]

    # @assert result₁ == 307
    # @assert result₂ == 160

    result₁, result₂
end

export day23
