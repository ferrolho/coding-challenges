function day10()
    input = joinpath(@__DIR__, "input.txt")
    seed = readline(input)

    function solve(seed, steps)
        curr = seed
        for step = 1:steps
            print("Current step: ", step)
            next = ""
            for m = eachmatch(r"(\d)\1*", curr)
                next = next * string(length(m.match)) * only(m.captures)
            end
            curr = next
            println(" --- ", length(curr))
        end
        length(curr)
    end

    result₁ = solve(seed, 40)
    result₂ = solve(seed, 50)

    # @assert result₁ == 492982
    # @assert result₂ == 6989950

    result₁, result₂
end

export day10
