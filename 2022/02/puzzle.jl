function day2_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    map(eachline(filename)) do x
        a = x[1] - 'A' + 1
        b = x[3] - 'X' + 1
        (a, b)
    end
end

function day2_part1(input)
    sum(input) do (a, b)
        # draw, win, lose
        if b == a
            b + 3
        elseif mod1(b - a, 3) == 1
            b + 6
        else
            b
        end
    end
end

function day2_part2(input)
    sum(input) do (a, c)
        # lose, draw, win
        if c == 1
            mod1(a - 1, 3)
        elseif c == 2
            a + 3
        elseif c == 3
            mod1(a + 1, 3) + 6
        end
    end
end

@testset "day02" begin
    input = day2_parseinput()
    @test day2_part1(input) == 12586
    @test day2_part2(input) == 13193
end

export day2_parseinput, day2_part1, day2_part2
