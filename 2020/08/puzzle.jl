function day8()
    input = joinpath(@__DIR__, "input.txt")
    code = split.(readlines(input)) .|> x -> (op = x[1], arg = parse(Int, x[2]))

    function part1(code)
        ip = 1  # instruction pointer
        visited = falses(length(code))  # counts instruction executions

        accumulator = 0

        while !visited[ip]  # break if already visited
            visited[ip] = true  # mark as visited

            op, arg = code[ip]

            if op == "acc"
                accumulator += arg
                ip += 1
            elseif op == "jmp"
                ip += arg
            elseif op == "nop"
                ip += 1
            end

            ip = mod1(ip, length(code))
        end

        accumulator
    end

    function repair(swap_idx)
        terminates = false  # termination flag

        ip = 1  # instruction pointer
        visited = falses(length(code))  # counts instruction executions

        accumulator = 0

        while !visited[ip]  # break if already visited
            visited[ip] = true  # mark as visited

            op, arg = code[ip]

            if ip == swap_idx
                op = (op == "jmp" ? "nop" : "jmp")
            end

            if op == "acc"
                accumulator += arg
                ip += 1
            elseif op == "jmp"
                ip += arg
            elseif op == "nop"
                ip += 1
            end

            if ip == length(code) + 1
                (terminates = true) && break
            end

            ip = mod1(ip, length(code))
        end

        terminates ? accumulator : nothing
    end

    function part2(code)
        for swap_idx = 1:length(code)
            op, _ = code[swap_idx]
            op == "acc" && continue

            accumulator = repair(swap_idx)
            !isnothing(accumulator) && return accumulator
        end
    end

    result₁ = part1(code)
    result₂ = part2(code)

    # result₁ = @btime $part1($code)
    # result₂ = @btime $part2($code)

    result₁, result₂
end

export day8
