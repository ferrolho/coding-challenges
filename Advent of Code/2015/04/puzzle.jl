function day4()
    input = joinpath(@__DIR__, "input.txt")
    a = readline(input)

    function solve(prefix)
        for b = Iterators.countfrom(1)
            hash = a * string(b) |> md5 |> bytes2hex
            startswith(hash, prefix) && return b
        end
    end

    result₁ = solve("00000")
    result₂ = solve("000000")

    # @assert result₁ == 117946
    # @assert result₂ == 3938038

    result₁, result₂
end

export day4
