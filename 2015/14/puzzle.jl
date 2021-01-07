function day14()
    input = joinpath(@__DIR__, "input.txt")

    reindeer = map(eachline(input)) do line
        rx = r"(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds."
        name, vel, t_fly, t_rest = only(eachmatch(rx, line)).captures
        name, parse.(Int, (vel, t_fly, t_rest))...
    end

    distances = zeros(Int, length(reindeer))
    points = zeros(Int, length(reindeer))

    for t = 1:2503
        for (i, (_, vel, t_fly, t_rest)) in enumerate(reindeer)
            if mod1(t, t_fly + t_rest) <= t_fly
                distances[i] += vel
            end
        end

        lead = maximum(distances)
        cis = findall(==(lead), distances)
        points[cis] .+= 1
    end

    result₁ = maximum(distances)
    result₂ = maximum(points)

    # @assert result₁ == 2655
    # @assert result₂ == 1059

    result₁, result₂
end

export day14
