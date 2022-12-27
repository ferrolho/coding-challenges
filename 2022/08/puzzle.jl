function day8_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    f(x) = parse.(Int, collect(x))
    mapreduce(f, hcat, eachline(filename)) |> permutedims
end

function day8_part1(input; dims=size(input))
    visible = Set{CartesianIndex}()

    edges = (  # left, right, top, bottom
        (1:dims[1], 1:1), (1:dims[1], dims[2]:dims[2]),
        (1:1, 1:dims[2]), (dims[1]:dims[1], 1:dims[2]))

    headings = (  # going... right, left, down, up
        CartesianIndex(0, 1), CartesianIndex(0, -1),
        CartesianIndex(1, 0), CartesianIndex(-1, 0))

    for (edge, heading) in zip(edges, headings)
        for ci in CartesianIndices(edge)
            prev_height = -1
            while ci ∈ CartesianIndices(input)
                height = input[ci]
                if height > prev_height
                    push!(visible, ci)
                    prev_height = height
                end
                ci += heading  # march on...
            end
        end
    end

    length(visible)
end

function day8_part2(input; cis=CartesianIndices(input))
    maximum(cis) do ci
        headings = (  # going... right, left, down, up
            CartesianIndex(0, 1), CartesianIndex(0, -1),
            CartesianIndex(1, 0), CartesianIndex(-1, 0))

        prod(headings) do heading
            marching_ci = ci
            while marching_ci + heading ∈ cis
                marching_ci += heading  # march on...
                input[marching_ci] ≥ input[ci] && break
            end
            norm((marching_ci - ci).I)  # viewing distance
        end  # scenic score
    end
end

@testset "day08" begin
    input = day8_parseinput()
    @test day8_part1(input) == 1803
    @test day8_part2(input) == 268912
end

export day8_parseinput, day8_part1, day8_part2
