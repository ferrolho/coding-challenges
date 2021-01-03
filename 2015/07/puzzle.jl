function day7()
    input = joinpath(@__DIR__, "input.txt")
    instructions = readlines(input)

    circuit = Dict(begin
        tokens, var = split(instruction, " -> ") |>
                      x -> ((split(x[1])...,), x[2])
        var => tokens
    end for instruction in instructions)

    wires = Dict{String,UInt16}()

    function calculate(var)
        haskey(wires, var) && return wires[var]

        line = circuit[var]

        if length(line) == 1
            a = only(line)
            x = tryparse(UInt16, a)
            isnothing(x) && (x = calculate(a))
            output = x
        elseif "OR" ∈ line
            a, b = line[[1,3]]
            output = calculate(a) | calculate(b)
        elseif "AND" ∈ line
            a, b = line[[1,3]]
            x = tryparse(UInt16, a)
            y = tryparse(UInt16, b)
            isnothing(x) && (x = calculate(a))
            isnothing(y) && (y = calculate(b))
            output = x & y
        elseif "LSHIFT" ∈ line
            a, b = line[[1,3]]
            output = calculate(a) << parse(UInt16, b)
        elseif "RSHIFT" ∈ line
            a, b = line[[1,3]]
            output = calculate(a) >> parse(UInt16, b)
        elseif "NOT" ∈ line
            a = line[2]
            output = ~calculate(a)
        else
            @error "Unknown instruction: " line
        end

        wires[var] = output
    end

    # -- Part One -- #

    result₁ = calculate("a") |> Int32

    # -- Part Two -- #

    empty!(wires)
    wires["b"] = result₁

    result₂ = calculate("a") |> Int32

    # @assert result₁ == 956
    # @assert result₂ == 40149

    result₁, result₂
end

export day7
