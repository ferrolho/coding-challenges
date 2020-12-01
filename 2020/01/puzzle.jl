function day1()
    expenses = vec(readdlm(joinpath(@__DIR__, "input.txt"), Int))

    function part1(expenses)
        for i = 1:length(expenses) - 1
            for j = i + 1:length(expenses)
                if expenses[i] + expenses[j] == 2020
                    return expenses[i] * expenses[j]
                end
            end
        end
    end

    function part2(expenses)
        for i = 1:length(expenses) - 2
            for j = i + 1:length(expenses) - 1
                for k = i + j + 1:length(expenses)
                    if expenses[i] + expenses[j] + expenses[k] == 2020
                        return expenses[i] * expenses[j] * expenses[k]
                    end
                end
            end
        end
    end

    result₁ = @btime $part1($expenses)
    result₂ = @btime $part2($expenses)

    result₁, result₂
end

export day1
