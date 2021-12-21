function day2_parseinput()
    input = joinpath(@__DIR__, "input.txt")
    map(eachline(input)) do cmd
        dir, units = split(cmd) |> x -> (x[1], parse(Int, x[2]))
        if dir == "forward"
            CartesianIndex(units, 0)
        elseif dir == "down"
            CartesianIndex(0, units)
        elseif dir == "up"
            CartesianIndex(0, -units)
        end
    end
end

day2_part1(input) = sum(input) |> x -> prod(x.I)

function day2_part2(input)
    pos, aim = CartesianIndex(0, 0), 0
    for cmd in input
        aim += cmd[2]
        pos += CartesianIndex(cmd[1], aim * cmd[1])
    end
    prod(pos.I)
end

@testset "day02" begin
    input = day2_parseinput()
    @test day2_part1(input) == 1693300
    @test day2_part2(input) == 1857958050
end

export day2_parseinput, day2_part1, day2_part2
