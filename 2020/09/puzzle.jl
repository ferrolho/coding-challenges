function day9()
    input = joinpath(@__DIR__, "input.txt")
    data = parse.(Int, readlines(input))

    validsum(number, valid) = any((number - term) ∈ valid for term ∈ valid)

    function part1(data; preamble=25)
        for i = preamble + 1:length(data)
            number = data[i]
            valid = data[i - preamble:i - 1]

            !validsum(number, valid) && return number
        end
    end

    function part2(data, target; preamble=25)
        for i = 1:length(data) - 1  # idx of contiguous set *start*
            for j = i + 1:length(data)  # idx of contiguous set *end*
                total = sum(data[i:j])
                if total == target
                    min = minimum(data[i:j])
                    max = maximum(data[i:j])
                    return min + max
                elseif total > target
                    break
                end
            end
        end
    end

    result₁ = part1(data)
    result₂ = part2(data, result₁)

    result₁, result₂
end

export day9
