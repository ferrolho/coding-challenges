function day8()
    input = joinpath(@__DIR__, "input.txt")

    showscreen(x) = foreach(x -> println(x...), eachrow(x))

    screen = fill(' ', (6, 50))

    for line = eachline(input)
        tokens = split(line)
        if tokens[1] == "rect"
            a, b = parse.(Int, split(tokens[2], 'x'))
            screen[1:b,1:a] .= '█'
        elseif tokens[1] == "rotate"
            if tokens[2] == "row"
                y = parse(Int, replace(tokens[3], "y=" => "")) + 1
                offset = parse(Int, tokens[5])
                new = fill(' ', size(screen, 2))
                for (i, c) = enumerate(screen[y,:])
                    new[mod1(i + offset, size(screen, 2))] = c
                end
                screen[y,:] = new
            elseif tokens[2] == "column"
                x = parse(Int, replace(tokens[3], "x=" => "")) + 1
                offset = parse(Int, tokens[5])
                new = fill(' ', size(screen, 1))
                for (i, c) = enumerate(screen[:,x])
                    new[mod1(i + offset, size(screen, 1))] = c
                end
                screen[:,x] = new
            end
        end
    end

    result₁ = count(==('█'), screen)
    result₂ = showscreen(screen)

    # @assert result₁ == 110
    # @assert result₂ == "ZJHRKCPLYJ"

    result₁, result₂
end

export day8
