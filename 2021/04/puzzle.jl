function day4_parseinput()
    input = read(joinpath(@__DIR__, "input.txt"), String)

    raw_numbers, raw_boards... = split(input, "\n\n")

    numbers = split(raw_numbers, ',') .|> x -> parse(Int, x)

    boards = map(raw_boards) do raw_board
        parse.(Int, split(raw_board)) |>
        x -> reshape(x, (5, 5)) |>
        permutedims
    end

    numbers, boards
end

function day4_boardiswinner(drawn, board)
    for i = 1:5  # 5x5 grid
        @views colᵢ = board[:,i]
        @views rowᵢ = board[i,:]
        if all(∈(drawn), colᵢ) ||
           all(∈(drawn), rowᵢ)
            return true
        end
    end
    return false
end

day4_finalscore(drawn, board) = sum(filter(∉(drawn), board)) * last(drawn)

function day4_part1(numbers, boards)
    for n = 1:length(numbers)
        @views drawn = numbers[1:n]
        for board in boards
            if day4_boardiswinner(drawn, board)
                return day4_finalscore(drawn, board)
            end
        end
    end
end

function day4_part2(numbers, boards)
    winners = zeros(Bool, length(boards))
    for n = 1:length(numbers)
        @views drawn = numbers[1:n]
        for (i, board) in enumerate(boards)
            winners[i] && continue
            if day4_boardiswinner(drawn, board)
                winners[i] = true
                if all(winners)
                    return day4_finalscore(drawn, board)
                end
            end
        end
    end
end

@testset "day04" begin
    numbers, boards = day4_parseinput()
    @test day4_part1(numbers, boards) == 2496
    @test day4_part2(numbers, boards) == 25925
end

export day4_parseinput, day4_part1, day4_part2
