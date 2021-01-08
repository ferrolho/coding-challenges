function day9()
    input = joinpath(@__DIR__, "input.txt")

    locations = Set{String}()
    edge2dist = Dict{Tuple{String,String},Int}()

    for line = eachline(input)
        ts = split(line)
        push!(locations, ts[1])
        push!(locations, ts[3])
        edge2dist[(ts[1], ts[3])] = parse(Int, ts[5])
        edge2dist[(ts[3], ts[1])] = parse(Int, ts[5])
    end

    visited = Set{Array{String,1}}()

    for p = permutations(collect(locations))
        if p ∉ visited && reverse(p) ∉ visited
            push!(visited, p)
        end
    end

    distances = map(collect(visited)) do path
        sum(1:length(path) - 1) do i
            edge2dist[(path[i], path[i + 1])]
        end
    end

    result₁, result₂ = extrema(distances)

    # @assert result₁ == 117
    # @assert result₂ == 909

    result₁, result₂
end

export day9
