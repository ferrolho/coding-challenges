function day10()
    input = joinpath(@__DIR__, "input.txt")

    instructions = readlines(input)
    str_values = filter(x -> startswith(x, "value"), instructions)
    str_bots = filter(x -> startswith(x, "bot"), instructions)

    function initialize(str_values)
        bots = Dict{Int,Array{Int,1}}()
        for line ∈ str_values
            k, v = split(line) |> x -> parse.(Int, (x[6], x[2]))
            bots[k] = get(bots, k, []) ∪ v
        end
        bots
    end

    function solve(bots, str_bots, chips)
        bots = copy(bots)
        outputs = Dict{Int,Array{Int,1}}()
        found₁, found₂ = false, false
        result₁, result₂ = nothing, nothing
        while !(found₁ && found₂)
            # Look for the bot that compares `chips`
            for (k, v) ∈ bots
                if all(x -> x ∈ v, chips)
                    found₁ = true
                    result₁ = k
                end
            end
            # Find the product of outputs 0, 1, and 2
            if all(x -> x ∈ keys(outputs), [0,1,2])
                found₂ = true
                result₂ = map(x -> outputs[x], [0,1,2]) .|> only |> prod
            end
            # Step the instructions (one at a time)
            for line ∈ str_bots
                tokens = split(line)
                k, kl, kh = parse.(Int, (tokens[2], tokens[7], tokens[12]))
                destl = tokens[6] == "output" ? outputs : bots
                desth = tokens[11] == "output" ? outputs : bots
                if length(get(bots, k, [])) == 2
                    l, h = extrema(bots[k])
                    destl[kl] = get(destl, kl, []) ∪ l
                    desth[kh] = get(desth, kh, []) ∪ h
                    empty!(bots[k])
                    break
                end
            end
        end
        result₁, result₂
    end

    bots = initialize(str_values)

    result₁, result₂ = solve(bots, str_bots, [61, 17])

    # @assert result₁ == 181
    # @assert result₂ == 12567

    result₁, result₂
end

export day10
