function day19_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    map(readlines(filename)) do line
        tuple((parse(Int, x) for x in split(line)
               if !isnothing(tryparse(Int, x)))...)
    end  # blueprints
end

function day19_solve(blueprints, num_minutes)
    blueprint = blueprints[1]

    # ore, clay, obsidian, geode
    robots = [1, 0, 0, 0]
    loot = [0, 0, 0, 0]

    for minute = 1:num_minutes
        # println("== Minute $(minute) ==")

        new_robots = [0, 0, 0, 0]

        if loot[1] ≥ blueprint[1]
            # build an ore-collecting robot
            # println("build an ore-collecting robot")
            loot[1] -= blueprint[1]
            new_robots[1] += 1
        end

        if loot[1] ≥ blueprint[2]
            # build a clay-collecting robot
            # println("build a clay-collecting robot")
            loot[1] -= blueprint[2]
            new_robots[2] += 1
        end

        if loot[1] ≥ blueprint[3] && loot[2] ≥ blueprint[4]
            # build an obsidian-collecting robot
            # println("build an obsidian-collecting robot")
            loot[1] -= blueprint[3]
            loot[2] -= blueprint[4]
            new_robots[3] += 1
        end

        if loot[1] ≥ blueprint[5] && loot[3] ≥ blueprint[6]
            # build a geode-collecting robot
            # println("build a geode-collecting robot")
            loot[1] -= blueprint[5]
            loot[3] -= blueprint[6]
            new_robots[4] += 1
        end

        loot += robots
        robots += new_robots

        # println("loot = $(loot)")
        # println("robots = $(robots)")
        # println()
    end

    loot[4]
end

day19_part1(input) = day19_solve(input, 24)
# day19_part2(input) = 

@testset "day19" begin
    input = day19_parseinput()
    # @test day19_part1(input) == 
    # @test day19_part2(input) == 
end

export day19_parseinput, day19_part1, day19_part2
