function day9()
    input = joinpath(@__DIR__, "input.txt")
    s = readline(input)

    function decompress(s; limit=0)
        prev = 1
        counter = 0
        for m = eachmatch(r"(?<!\))(\(\d+x\d+\))", s)
            i = m.offset
            i < prev && continue
            j = i + length(m.match)
            l, n = only(m.captures) |>
                   x -> replace(x, r"[\(\)]" => "") |>
                   x -> split(x, "x") .|>
                   x -> parse(Int, x)
            counter += length(s[prev:i - 1])
            counter += n * (limit == 1 ? l : decompress(s[range(j, length=l)], limit=limit - 1))
            prev = j + l
        end
        counter += length(s[prev:end])
    end

    result₁ = decompress(s, limit=1)
    result₂ = decompress(s)

    # @assert result₁ == 97714
    # @assert result₂ == 10762972461

    result₁, result₂
end

export day9
