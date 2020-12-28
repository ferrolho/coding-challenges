function day24()
    input = joinpath(@__DIR__, "input.txt")

    cube_directions = Dict{String,Tuple}(
        "e" => (+1, -1, 0), "ne" => (+1, 0, -1), "nw" => (0, +1, -1),
        "w" => (-1, +1, 0), "sw" => (-1, 0, +1), "se" => (0, -1, +1),
        # See https://www.redblobgames.com/grids/hexagons/#neighbors-cube
    )

    counter = Dict{Tuple,Int}()

    for line = eachline(input)
        m = eachmatch(r"(e|ne|nw|w|sw|se)", line)
        instructions = map(x -> only(x.captures), collect(m))
        steps = map(x -> collect(cube_directions[x]), instructions)

        destination = sum(steps)
        key = tuple(destination...)
        counter[key] = get(counter, key, 0) + 1
    end

    black_tiles = Set(k for (k, v) ∈ counter if isodd(v))

    result₁ = length(black_tiles)
    # @assert result₁ == 488

    neighbours(coord) = map(x -> coord .+ x, values(cube_directions))

    for day = 1:100
        tobechecked = black_tiles ∪ reduce(∪, neighbours.(black_tiles))

        next_black_tiles = Set([])

        for tile ∈ tobechecked
            n = length(neighbours(tile) ∩ black_tiles)

            if n == 0 || n > 2
                # becomes white
            elseif n == 2 || tile ∈ black_tiles
                # becomes black
                push!(next_black_tiles, tile)
            end
        end

        black_tiles = next_black_tiles

        day % 10 == 0 && println("Day $(day): $(length(black_tiles))")
    end

    result₂ = length(black_tiles)
    # @assert result₂ == 4118

    result₁, result₂
end

export day24
