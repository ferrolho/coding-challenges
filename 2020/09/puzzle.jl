function day9()
    input = joinpath(@__DIR__, "input.txt")
    data = parse.(Int, readlines(input))

    validsum(number, valid) = any((number - term) ∈ valid for term ∈ valid)

    function part1(data; preamble=25)
        for i = preamble + 1:length(data)
            number = data[i]
            valid = @view data[i - preamble:i - 1]

            !validsum(number, valid) && return number
        end
    end

    function part2(data, target; preamble=25)
        for i = 1:length(data) - 1  # idx of contiguous set *start*
            for j = i + 1:length(data)  # idx of contiguous set *end*
                window = @view data[i:j]
                total = sum(window)
                if total == target
                    return sum(extrema(window))
                elseif total > target
                    break
                end
            end
        end
    end

    result₁ = part1(data)
    result₂ = part2(data, result₁)

    # @btime $part1($data)
    # @btime $part2($data, $result₁)

    result₁, result₂
end

export day9
