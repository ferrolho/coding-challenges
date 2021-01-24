function day21()
    function scramble(password)
        password = collect(password)
        input = joinpath(@__DIR__, "input.txt")
        for line = eachline(input)
            tokens = split(line)
            if tokens[1] == "swap"
                if tokens[2] == "position"
                    x, y = parse.(Int, tokens[[3,6]]) .+ 1
                    temp = password[x]
                    password[x] = password[y]
                    password[y] = temp
                elseif tokens[2] == "letter"
                    x, y = only.(tokens[[3,6]])
                    i₁ = findfirst(==(x), password)
                    i₂ = findfirst(==(y), password)
                    password[i₁] = y
                    password[i₂] = x
                end
            elseif tokens[1] == "rotate"
                if tokens[2] ∈ ("left", "right")
                    dir = tokens[2] == "left" ? -1 : 1
                    steps = parse(Int, tokens[3])
                    password = circshift(password, dir * steps)
                else
                    x = only(tokens[7])
                    i = findfirst(==(x), password) - 1
                    steps = 1 + i + (i >= 4 ? 1 : 0)
                    password = circshift(password, steps)
                end
            elseif tokens[1] == "reverse"
                x, y = parse.(Int, tokens[[3,5]]) .+ 1
                password[x:y] = reverse(password[x:y])
            elseif tokens[1] == "move"
                x, y = parse.(Int, tokens[[3,6]]) .+ 1
                c = popat!(password, x)
                insert!(password, y, c)
            end
        end
        join(password)
    end

    result₁ = scramble("abcdefgh")

    result₂ = nothing
    for p = permutations("abcdefgh")
        if scramble(p) == "fbgdceah"
            result₂ = join(p)
            break
        end
    end

    # @assert result₁ == "cbeghdaf"
    # @assert result₂ == "bacdefgh"

    result₁, result₂
end

export day21
