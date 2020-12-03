function day3()
    lines = readdlm(joinpath(@__DIR__, "input.txt"), String)  # Read lines from input file
    trees = map(==('#'), hcat(collect.(lines)...))'  # Transform input to ::Array{Bool,2}

    function count_trees_for_slope(trees, slope)
        # Number of coordinates to be checked
        n = cld(size(trees, 1), slope.down)

        # Row- and column-coordinates to be checked
        rs = range(1, step=slope.down, length=n)
        cs = range(0, step=slope.right, length=n)

        # The problem says the tree pattern repeats to the right indefinitely.
        # Trick: we don't actually need to copy the pattern; instead,
        #        we can simply wrap the column-coordinates around.
        cs = map(x -> x % size(trees, 2) + 1, cs)

        idxs = CartesianIndex.(rs, cs)
        count(trees[idxs])
    end

    function part1(trees)
        slope = (right = 3, down = 1)
        count_trees_for_slope(trees, slope)
    end

    function part2(trees)
        slopes = [(right = 1, down = 1)
                  (right = 3, down = 1)
                  (right = 5, down = 1)
                  (right = 7, down = 1)
                  (right = 1, down = 2)]

        mapreduce(x -> count_trees_for_slope(trees, x), *, slopes)
    end

    result₁ = part1(trees)
    result₂ = part2(trees)

    # result₁ = @btime $part1($trees)
    # result₂ = @btime $part2($trees)

    result₁, result₂
end

export day3
