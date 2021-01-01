function day2()
    input = joinpath(@__DIR__, "input.txt")

    presents = split.(readlines(input), "x") .|>
               x -> parse.(Int, x)

    surfacearea(l, w, h) = 2(l * w) + 2(w * h) + 2(h * l)
    smallestsidearea(l, w, h) = min(l * w, w * h, h * l)
    smallestperimeter(l, w, h) = min(2l + 2w, 2w + 2h, 2h + 2l)
    volume(l, w, h) = l * w * h

    result₁ = sum(presents) do p
        surfacearea(p...) + smallestsidearea(p...)
    end

    result₂ = sum(presents) do p
        smallestperimeter(p...) + volume(p...)
    end

    # @assert result₁ == 1606483
    # @assert result₂ == 3842356

    result₁, result₂
end

export day2
