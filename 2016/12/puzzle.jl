function day12()
    input = joinpath(@__DIR__, "input.txt")
    program = split.(readlines(input))

    function compute!(registers; ip=1)
        while 1 <= ip <= length(program)
            tokens = program[ip]
            instruction = first(tokens)

            if instruction == "cpy"
                x, xi = tokens[2], tryparse(Int, tokens[2])
                x = isnothing(xi) ? registers[x] : xi
                y = tokens[3]
                registers[y] = x
                ip += 1
            elseif instruction == "inc"
                x = tokens[2]
                registers[x] += 1
                ip += 1
            elseif instruction == "dec"
                x = tokens[2]
                registers[x] -= 1
                ip += 1
            elseif instruction == "jnz"
                x, xi = tokens[2], tryparse(Int, tokens[2])
                x = isnothing(xi) ? registers[x] : xi
                y = parse(Int, tokens[3])
                ip += (!iszero(x) ? y : 1)
            end
        end

        registers
    end

    result₁ = compute!(Dict(("a", "b", "c", "d") .=> (0, 0, 0, 0)))["a"]
    result₂ = compute!(Dict(("a", "b", "c", "d") .=> (0, 0, 1, 0)))["a"]

    # @assert result₁ == 318003
    # @assert result₂ == 9227657

    result₁, result₂
end

export day12
