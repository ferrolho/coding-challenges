function day1()
    numbers = vec(readdlm("./01/input.txt", Int))

    map!(x -> floor(x / 3) - 2, numbers, numbers)
    result_1 = sum(numbers)

    result_2 = result_1
    while !isempty(numbers)
        map!(x -> floor(x / 3) - 2, numbers, numbers)
        filter!(x -> x ≥ 0, numbers)
        result_2 += sum(numbers)
    end

    result_1, result_2
end

export day1
