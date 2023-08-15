mutable struct Day11_Monkey
    items::Vector{Int}
    worry_fn::Function
    modulo::Int
    test_fn::Function
    function Day11_Monkey(items, worry_fn, (a, b, c))
        test_fn(x) = (x % a == 0 ? b : c) + 1
        new(items, worry_fn, a, test_fn)
    end
end

function day11_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    [
        Day11_Monkey([54, 61, 97, 63, 74], x -> x * 7, (17, 5, 3))
        Day11_Monkey([61, 70, 97, 64, 99, 83, 52, 87], x -> x + 8, (2, 7, 6))
        Day11_Monkey([60, 67, 80, 65], x -> x * 13, (5, 1, 6))
        Day11_Monkey([61, 70, 76, 69, 82, 56], x -> x + 7, (3, 5, 2))
        Day11_Monkey([79, 98], x -> x + 2, (7, 0, 3))
        Day11_Monkey([72, 79, 55], x -> x + 1, (13, 2, 1))
        Day11_Monkey([63], x -> x + 4, (19, 7, 4))
        Day11_Monkey([72, 51, 93, 63, 80, 86, 81], x -> x * x, (11, 0, 4))
    ]
end

monkey_business(x) = partialsort!(x, 1:2, rev=true) |> prod

function simulate!(monkeys, num_rounds, worry_mgmt)
    num_monkeys = length(monkeys)
    counters = zeros(Int, num_monkeys)
    for _ = 1:num_rounds
        for (a, monkey_a) in enumerate(monkeys)
            while !isempty(monkey_a.items)
                counters[a] += 1  # inspect item
                worry_level = popfirst!(monkey_a.items)
                worry_level = monkey_a.worry_fn(worry_level)
                worry_level = worry_mgmt(worry_level)
                b = monkey_a.test_fn(worry_level)
                push!(monkeys[b].items, worry_level)
            end
        end
    end
    monkey_business(counters)
end

function day11_part1(monkeys, num_rounds=20)
    simulate!(monkeys, num_rounds, x -> floor(x / 3))
end

function day11_part2(monkeys, num_rounds=10000)
    M = prod(monkey.modulo for monkey in monkeys)
    simulate!(monkeys, num_rounds, x -> x % M)
end

@testset "day11" begin
    monkeys = day11_parseinput()
    @test day11_part1(deepcopy(monkeys)) == 50172
    @test day11_part2(deepcopy(monkeys)) == 11614682178
end

export day11_parseinput, day11_part1, day11_part2
