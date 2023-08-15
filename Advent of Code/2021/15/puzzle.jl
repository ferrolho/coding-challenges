function day15_parseinput()
    input = joinpath(@__DIR__, "input.txt")
    mapreduce(collect, hcat, eachline(input)) |>
    permutedims .|> x -> parse(Int, x)
end

function day15_solve(cave)
    target = CartesianIndex(size(cave))

    queue = [(cave[target], target)]
    costmap = fill(Inf, size(cave))

    dirs = [CartesianIndex( 1, 0), CartesianIndex(0,  1),
            CartesianIndex(-1, 0), CartesianIndex(0, -1)]

    while queue |> !isempty
        cost, ci = popfirst!(queue)
        if cost < costmap[ci]
            costmap[ci] = cost
            for dir in dirs
                neighbour = ci + dir
                if checkbounds(Bool, cave, neighbour)
                    node = (cave[neighbour] + cost, neighbour)
                    push!(queue, node)
                end
            end
        end
    end

    costmap
end

function day15_part1(cave)
    costmap = day15_solve(cave)
    costmap[1] - cave[1] |> Int
end

function day15_part2(cave)
    full_cave = repeat(cave, 5, 5)
    correction = [ 0 1 2 3 4 ;
                   1 2 3 4 5 ;
                   2 3 4 5 6 ;
                   3 4 5 6 7 ;
                   4 5 6 7 8 ]
    correction = map(x -> fill(x, size(cave)), correction)
    correction = mapreduce(x -> vcat(x...), hcat, eachrow(correction))
    @. full_cave = mod1(full_cave + correction, 9)
    # foreach(x -> println(join(x)), eachrow(full_cave))

    costmap = day15_solve(full_cave)
    costmap[1] - full_cave[1] |> Int
end

@testset "day15" begin
    cave = day15_parseinput()
    @test day15_part1(cave) == 40
    @test day15_part2(cave) == 315
end

export day15_parseinput, day15_part1, day15_part2
