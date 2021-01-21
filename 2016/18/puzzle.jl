function day18()
    input = joinpath(@__DIR__, "input.txt")
    row₁ = readline(input)

    function isatrap(left, center, right)
        s₁ = left == center == '^' && (isnothing(right) || right == '.')
        s₂ = center == right == '^' && (isnothing(left) || left == '.')
        s₃ = left == '^' && center == '.' && (isnothing(right) || right == '.')
        s₄ = right == '^' && center == '.' && (isnothing(left) || left == '.')
        s₁ | s₂ | s₃ | s₄
    end

    function nextrow(tiles)
        map(1:length(tiles)) do i
            center = tiles[i]
            left = i > 1 ? tiles[i - 1] : nothing
            right = i < length(tiles) ? tiles[i + 1] : nothing
            isatrap(left, center, right) ? '^' : '.'
        end
    end

    function calculaterows(row₁, n)
        rows = [collect(row₁)]
        for i = 2:n
            push!(rows, nextrow(rows[end]))
        end
        reduce(hcat, rows)
    end

    rows = calculaterows(row₁, 40)
    result₁ = count(==('.'), rows)

    rows = calculaterows(row₁, 400000)
    result₂ = count(==('.'), rows)

    # @assert result₁ == 1939
    # @assert result₂ == 19999535

    result₁, result₂
end

export day18
