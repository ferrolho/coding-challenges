function day22_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    input = readlines(filename)
    board_lines, path = input[1:end-2], input[end]

    board = mapreduce(collect, hcat, board_lines) |> permutedims
    open_tiles = findall(==('.'), board)
    solid_walls = findall(==('#'), board)

    numbers = split(path, ('L', 'R')) .|> Base.Fix1(parse, Int)
    letters = [c for c in path if c ∈ ('L', 'R')]

    size(board), open_tiles, solid_walls, numbers, letters
end

function day22_facing2ci(x)
    s, c = sincosd(x * -90)
    CI(Int.(round.((-s, c))))
end

function day22_march1(dims, all_tiles, solid_walls, pos, facing)
    dir = day22_facing2ci(facing)
    clamp(ci) = CI(mod1.(ci.I, dims))

    next_pos = pos + dir
    while next_pos ∉ all_tiles
        next_pos = clamp(next_pos + dir)
    end

    # wrap around and do not walk into walls
    next_pos ∈ solid_walls ? (pos, facing) : (next_pos, facing)
end

# not proud of this one at all...
function day22_march2(_, _, solid_walls, pos, facing)
    next_pos, next_facing = pos, facing

    if pos[1] ∈ 1:50 && pos[2] == 51 && facing == 2  # face₁ <
        # face₁ left edge connects to face₄ left edge
        next_pos, next_facing = CI(reverse(101:150)[pos[1]-0], 1), 0

    elseif pos[1] == 1 && pos[2] ∈ 51:100 && facing == 3  # face₁ ^
        # face₁ top edge connects to face₆ left edge
        next_pos, next_facing = CI(identity(151:200)[pos[2]-50], 1), 0

    elseif pos[1] ∈ 1:50 && pos[2] == 150 && facing == 0  # face₂ >
        # face₂ right edge connects to face₅ right edge
        next_pos, next_facing = CI(reverse(101:150)[pos[1]-0], 100), 2

    elseif pos[1] == 50 && pos[2] ∈ 101:150 && facing == 1  # face₂ v
        # face₂ bottom edge connects to face₃ right edge
        next_pos, next_facing = CI(identity(51:100)[pos[2]-100], 100), 2

    elseif pos[1] == 1 && pos[2] ∈ 101:150 && facing == 3  # face₂ ^
        # face₂ top edge connects to face₆ bottom edge
        next_pos, next_facing = CI(200, identity(1:50)[pos[2]-100]), 3

    elseif pos[1] ∈ 51:100 && pos[2] == 100 && facing == 0  # face₃ >
        # face₃ right edge connects to face₂ bottom edge
        next_pos, next_facing = CI(50, identity(101:150)[pos[1]-50]), 3

    elseif pos[1] ∈ 51:100 && pos[2] == 51 && facing == 2  # face₃ <
        # face₃ left edge connects to face₄ top edge
        next_pos, next_facing = CI(101, identity(1:50)[pos[1]-50]), 1

    elseif pos[1] ∈ 101:150 && pos[2] == 1 && facing == 2  # face₄ <
        # face₄ left edge connects to face₁ left edge
        next_pos, next_facing = CI(reverse(1:50)[pos[1]-100], 51), 0

    elseif pos[1] == 101 && pos[2] ∈ 1:50 && facing == 3  # face₄ ^
        # face₄ top edge connects to face₃ left edge
        next_pos, next_facing = CI(identity(51:100)[pos[2]-0], 51), 0

    elseif pos[1] ∈ 101:150 && pos[2] == 100 && facing == 0  # face₅ >
        # face₅ right edge connects to face₂ right edge
        next_pos, next_facing = CI(reverse(1:50)[pos[1]-100], 150), 2

    elseif pos[1] == 150 && pos[2] ∈ 51:100 && facing == 1  # face₅ v
        # face₅ bottom edge connects to face₆ right edge
        next_pos, next_facing = CI(identity(151:200)[pos[2]-50], 50), 2

    elseif pos[1] ∈ 151:200 && pos[2] == 50 && facing == 0  # face₆ >
        # face₆ right edge connects to face₅ bottom edge
        next_pos, next_facing = CI(150, identity(51:100)[pos[1]-150]), 3

    elseif pos[1] == 200 && pos[2] ∈ 1:50 && facing == 1  # face₆ v
        # face₆ bottom edge connects to face₂ top edge
        next_pos, next_facing = CI(1, identity(101:150)[pos[2]-0]), 1

    elseif pos[1] ∈ 151:200 && pos[2] == 1 && facing == 2  # face₆ <
        # face₆ left edge connects to face₁ top edge
        next_pos, next_facing = CI(1, identity(51:100)[pos[1]-150]), 1

    else  # otherwise, normal marching
        next_pos, next_facing = pos + day22_facing2ci(facing), facing
    end

    next_pos ∈ solid_walls ? (pos, facing) : (next_pos, next_facing)
end

function day22_solve(dims, open_tiles, solid_walls, numbers, letters; march_fn)
    turn(facing, c) = mod(facing + (c == 'R' ? 1 : -1), 4)
    password(pos, facing) = 1000 * pos[1] + 4 * pos[2] + facing

    all_tiles = open_tiles ∪ solid_walls
    pos, facing = minimum(x for x in open_tiles if x.I[1] == 1), 0

    for i = eachindex(numbers)
        for _ = 1:numbers[i]
            pos, facing = march_fn(dims, all_tiles, solid_walls, pos, facing)
        end
        if i <= length(letters)
            facing = turn(facing, letters[i])
        end
    end

    password(pos, facing)
end

day22_part1(args...) = day22_solve(args..., march_fn=day22_march1)
day22_part2(args...) = day22_solve(args..., march_fn=day22_march2)

@testset "day22" begin
    input = day22_parseinput()
    @test day22_part1(input...) == 36518
    @test day22_part2(input...) == 143208
end

export day22_parseinput, day22_part1, day22_part2
