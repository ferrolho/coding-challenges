function day16()
    input = joinpath(@__DIR__, "input.txt")
    a = readline(input)

    function ~(s::String)
        join(UInt8[c == '0' for c in s])
    end

    function unfold(a)
        b = ~(reverse(a))
        a * '0' * b
    end

    function checksum(a)
        result = map(Iterators.partition(a, 2)) do p
            p[1] == p[2] ? '1' : '0'
        end |> join
        iseven(length(result)) ? checksum(result) : result
    end

    function filldisk(a, minlength)
        while length(a) < minlength
            a = unfold(a)
        end
        a = first(a, minlength)
        checksum(a)
    end

    result₁ = filldisk(a, 272)
    result₂ = filldisk(a, 35651584)

    # @assert result₁ == "10100101010101101"
    # @assert result₂ == "01100001101101001"

    result₁, result₂
end

export day16
