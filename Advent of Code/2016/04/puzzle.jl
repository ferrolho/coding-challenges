function day4()
    input = joinpath(@__DIR__, "input.txt")
    list = readlines(input) .|>
           x -> eachmatch(r"([\w-]+)-(\d+)\[(\w+)\]", x) |>
           only |> x -> x.captures |>
           x -> (replace(x[1], "-" => ""), parse(Int, x[2]), x[3])

    function name2checksum(name)
        keys = unique(name)
        d = Dict(k => count(==(k), name) for k ∈ keys)
        sd = sort(collect(d), by=x -> (-x[2], x[1]))
        first.(sd[1:5]) |> join
    end

    result₁ = sum(list) do (name, sid, checksum)
        name2checksum(name) == checksum ? sid : 0
    end

    function decrypt(name, sid)
        map(x -> (x - 'a' + sid) % ('z' - 'a' + 1) + 'a', name)
    end

    result₂ = only(sid for (name, sid, checksum) ∈ list
                   if name2checksum(name) == checksum &&
                      contains(decrypt(name, sid), r"north|pole"))

    # @assert result₁ == 361724
    # @assert result₂ == 482

    result₁, result₂
end

export day4
