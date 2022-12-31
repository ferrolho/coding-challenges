function day23_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    input = mapreduce(collect, hcat, eachline(filename)) |> permutedims
    positions = findall(==('#'), input)
end

function day23(positions, num_elves=length(positions))
    increments = (
        # NW, N, NE, E, SE, S, SW, W, NW
        CI(-1,-1), CI(-1, 0), CI(-1, 1),
        CI( 0, 1), CI( 1, 1), CI( 1, 0),
        CI( 1,-1), CI( 0,-1), CI(-1,-1))

    occupancy(ci) = tuple((ci + x ∈ positions for x in increments)...)

    function scan(pos, dir)
        lookaround = occupancy(pos)
        !any(lookaround) && return 5  # do not move
        for _ = 1:4  # find direction
            dir = mod1(dir + 1, 4)
            ids = (1:3, 5:7, 7:9, 3:5)[dir]  # N, S, W, E
            !any(lookaround[ids]) && return dir
        end
        return 5  # do not move
    end

    propose(pos, dir) = pos +  # 1:5 => CI increment (N, S, W, E, wait)
                        (CI(-1, 0), CI(1, 0), CI(0, -1), CI(0, 1), CI(0, 0))[dir]

    move(ci₁, ci₂) = count(==(ci₂), proposals::Vector{CI{2}}) == 1 ? ci₂ : ci₁

    round_dir = 4
    num_empty = 0

    directions = fill(4, num_elves)
    proposals = fill(CI(1, 1), num_elves)

    for round = Iterators.countfrom(1)
        directions .= scan.(positions, round_dir)
        proposals .= propose.(positions, directions)
        positions .= move.(positions, proposals)

        if round == 10  # save solution to part 1
            ci₁, ci₂ = extrema(positions)
            dims = ci₂ - (ci₁ - CI(1, 1))
            num_empty = prod(dims.I) - num_elves
        end

        # we are done when none of the elves need to move
        all(==(5), directions) && return (num_empty, round)

        # on the next round, consider the next direction
        round_dir = mod1(round_dir + 1, 4)
    end
end

@testset "day23" begin
    input = day23_parseinput()
    @test day23(input) == (4254, 992)
end

export day23_parseinput, day23
