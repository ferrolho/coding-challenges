using DelimitedFiles

function day1()
    numbers = readdlm("./01/input.txt", Int)
    map!(x -> floor(x / 3) - 2, numbers, numbers)
    sum(numbers)
end

export day1
