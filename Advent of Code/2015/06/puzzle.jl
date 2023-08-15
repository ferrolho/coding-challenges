function day6()
    input = joinpath(@__DIR__, "input.txt")
    instructions = readlines(input)

    # -- Part One -- #

    lights = falses((1000, 1000))

    for instruction in instructions
        x₁, y₁, x₂, y₂ = split(instruction) |>
                         x -> parse.(Int, [split(x[end - 2], ',')
                                           split(x[end    ], ',')]) .+ 1

        if startswith(instruction, "turn on")
            lights[x₁:x₂,y₁:y₂] .= true
        elseif startswith(instruction, "turn off")
            lights[x₁:x₂,y₁:y₂] .= false
        elseif startswith(instruction, "toggle")
            lights[x₁:x₂,y₁:y₂] .= .!lights[x₁:x₂,y₁:y₂]
        end
    end

    result₁ = count(lights)

    # -- Part Two -- #

    lights = zeros(Int, (1000, 1000))

    for instruction in instructions
        x₁, y₁, x₂, y₂ = split(instruction) |>
                         x -> parse.(Int, [split(x[end - 2], ',')
                                           split(x[end    ], ',')]) .+ 1

        if startswith(instruction, "turn on")
            lights[x₁:x₂,y₁:y₂] .+= 1
        elseif startswith(instruction, "turn off")
            lights[x₁:x₂,y₁:y₂] .= max.(lights[x₁:x₂,y₁:y₂] .- 1, 0)
        elseif startswith(instruction, "toggle")
            lights[x₁:x₂,y₁:y₂] .+= 2
        end
    end

    result₂ = sum(lights)

    # @assert result₁ == 400410
    # @assert result₂ == 15343601

    result₁, result₂
end

export day6
