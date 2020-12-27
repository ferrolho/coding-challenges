function day20()
    input = joinpath(@__DIR__, "input.txt")
    chunks = split(read(input, String), "\n\n")

    data = Dict{Int,Array{Char,2}}()

    for chunk ∈ chunks
        header, image_str = Iterators.peel(split(chunk, "\n", keepempty=false))
        m = match(r"Tile (\d+):", header)
        id = parse(Int, only(m.captures))
        image = mapreduce(collect, hcat, image_str)
        data[id] = image
    end

    # Side length of the image
    l = length(data) |> sqrt |> Int

    counter = Dict{Int,Int}()

    for k₁ ∈ keys(data)
        counter[k₁] = 0

        # Gather the borders of _this_ tile
        strs₁ = [data[k₁][:,1], data[k₁][:,end],
                 data[k₁][1,:], data[k₁][end,:]]

        for k₂ ∈ keys(data)
            k₁ == k₂ && continue

            # Gather the borders of _another_ tile
            strs₂ = [data[k₂][:,1], data[k₂][:,end],
                     data[k₂][1,:], data[k₂][end,:]]

            # Consider they may be flipped
            strs₂ = [strs₂; reverse.(strs₂)]

            counter[k₁] += length(strs₁ ∩ strs₂)  # Number of matching edges
        end
    end

    corners = findall(==(2), counter)
    edges = findall(==(3), counter)
    middle = findall(==(4), counter)

    result₁ = prod(corners)

    # Helper functions
    hmatch(l, r) = l[:,end] == r[:,1]
    vmatch(t, b) = t[end,:] == b[1,:]

    function find_and_place!(puzzle, ci, candidates)
        for (i, tile_id) in enumerate(candidates)
            tile = data[tile_id]

            for _ = 1:2       tile = permutedims(tile)
                for _ = 1:4   tile = rotr90(tile)

                    isvalid = true

                    # Check vertical and horizontal connection
                    ci[1] > 1 && (isvalid &= vmatch(puzzle[ci + CartesianIndex(-1, 0)], tile))
                    ci[2] > 1 && (isvalid &= hmatch(puzzle[ci + CartesianIndex(0, -1)], tile))

                    if isvalid
                        puzzle[ci] = tile
                        popat!(candidates, i)
                        return true  # Found valid tile
                    end
                end
            end
        end

        return false  # Could not find a valid tile
    end

    # CartesianIndices of corners, edges, and middle pieces
    corner_cis = [(1, 1), (1, l), (l, 1), (l, l)] .|> CartesianIndex
    middle_cis = CartesianIndex(2, 2):CartesianIndex(l - 1, l - 1) |> collect
    edge_cis = filter(CartesianIndex(1, 1):CartesianIndex(l, l)) do x
        x ∉ corner_cis ∪ middle_cis
    end

    first_corner = data[pop!(corners)]
    puzzle = nothing

    for k = 0:3  # Assemble the puzzle
        puzzle = Array{Array{Char,2},2}(undef, l, l)

        _corners = corners |> copy
        _edges   = edges   |> copy
        _middle  = middle  |> copy

        # Place first piece (corner)
        puzzle[1] = rotr90(first_corner, k)

        done = false

        # Place next pieces
        for ci ∈ CartesianIndices(puzzle)[2:end]
            ci ∈ corner_cis && (candidates = _corners)
            ci ∈ edge_cis   && (candidates = _edges  )
            ci ∈ middle_cis && (candidates = _middle )

            ret = find_and_place!(puzzle, ci, candidates)

            !ret && break  # Could not place a piece

            ci == CartesianIndices(puzzle)[end] && (done = true)
        end

        done && break
    end

    remove_borders(tiles) = [tile[2:end - 1, 2:end - 1] for tile in tiles]
    remove_gaps(tiles) = mapreduce(r -> reduce(hcat, r), vcat, eachrow(tiles))

    image = puzzle |> remove_borders |> remove_gaps

    function water_roughness(image)
        pattern_str = ["                  # "
                       "#    ##    ##    ###"
                       " #  #  #  #  #  #   "]

        pattern = mapreduce(collect, hcat, pattern_str)
        cis_p = findall(==('#'), pattern)

        ci_begin = CartesianIndex(1, 1)
        ci_end = CartesianIndex(size(image)) - CartesianIndex(size(pattern))

        for _ = 1:2       image = permutedims(image)
            for _ = 1:4   image = rotr90(image)

                # Count `n` monsters
                n = count(ci_begin:ci_end) do offset
                    cis = map(x -> x + offset, cis_p)
                    all(==('#'), image[cis])
                end

                # If monster(s) found, calculate and return 'water roughness'.
                n > 0 && return count(==('#'), image) - n * count(==('#'), pattern)
            end
        end
    end

    result₂ = water_roughness(image)

    # @assert result₁ == 8581320593371
    # @assert result₂ == 2031

    result₁, result₂
end

export day20
