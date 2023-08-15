function day15()
    position(disc, t) = mod(disc.offset + t, disc.period)

    function solve(discs)
        accum_period = 1
        time_wait = 0
        for (i, discᵢ) = enumerate(discs)
            new_period = lcm(accum_period, discᵢ.period)
            for t = time_wait:accum_period:new_period
                if position(discᵢ, t + i) == 0
                    accum_period = new_period
                    time_wait = t
                    break
                end
            end
        end
        time_wait
    end

    # -- Parse Input -- #

    rx = r"Disc #\d+ has (\d+) positions; at time=\d+, it is at position (\d+)."
    input = joinpath(@__DIR__, "input.txt")

    discs = map(eachmatch(rx, read(input, String))) do m
        a, b = parse.(Int, m.captures)
        (period = a, offset = b)
    end

    # -- Part One -- #

    result₁ = solve(discs)

    # -- Part Two -- #

    new_disc = (period = 11, offset = 0)
    push!(discs, new_disc)

    result₂ = solve(discs)

    # @assert result₁ == 148737
    # @assert result₂ == 2353212

    result₁, result₂
end

export day15
