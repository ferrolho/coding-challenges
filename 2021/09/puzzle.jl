function day9_parseinput()
    input = joinpath(@__DIR__, "input.txt")
    mapreduce(collect, hcat, eachline(input)) |>
    permutedims .|> x -> parse(Int, x)
end

day9_select(A, I, steps) = [A[I + step] for step in steps if checkbounds(Bool, A, I + step)]

function day9_lowpoints(heightmap)
    steps = [CartesianIndex( 1, 0), CartesianIndex(0,  1),
             CartesianIndex(-1, 0), CartesianIndex(0, -1)]

    low_points = CartesianIndex{2}[]

    for ci ∈ CartesianIndices(heightmap)
        this_height = heightmap[ci]
        adjacent_heights = day9_select(heightmap, ci, steps)
        all(>(this_height), adjacent_heights) && push!(low_points, ci)
    end

    low_points
end

function day9_basin(heightmap, low_point)
    steps = [CartesianIndex( 1, 0), CartesianIndex(0,  1),
             CartesianIndex(-1, 0), CartesianIndex(0, -1)]

    to_be_checked = Set([low_point])
    basin = Set(CartesianIndex{2}[])

    while !isempty(to_be_checked)
        ci = pop!(to_be_checked)
        push!(basin, ci)

        for step in steps
            neighbour = ci + step

            checkbounds(Bool, heightmap, neighbour) &&  # if the neighbour is within bounds, and
                (heightmap[neighbour] < 9) &&           # its height is less than 9, and
                (neighbour ∉ basin) &&                  # it is not in the basin yet, then
                push!(to_be_checked, neighbour)         # add it to the basin
        end
    end

    basin
end

function day9_part1(heightmap)
    low_points = day9_lowpoints(heightmap)
    risk_levels = heightmap[low_points] .+ 1
    sum(risk_levels)
end

function day9_part2(heightmap)
    low_points = day9_lowpoints(heightmap)
    basins = [day9_basin(heightmap, x) for x in low_points]
    length.(basins) |> sort! |> x -> x[end-2:end] |> prod
end

@testset "day09" begin
    heightmap = day9_parseinput()
    @test day9_part1(heightmap) == 491
    @test day9_part2(heightmap) == 1075536
end

export day9_parseinput, day9_part1, day9_part2
