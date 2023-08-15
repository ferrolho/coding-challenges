function day2()
    entries = readlines(joinpath(@__DIR__, "input.txt"))
    entries = [(parse(Int, l), parse(Int, u), first(c), pw)
               for (l, u, c, pw) in split.(entries, r"[- :]", keepempty=false)]

    function part1(entries)
        count(entries) do (l, u, c, pw)
            l ≤ count(==(c), pw) ≤ u
        end
    end

    function part2(entries)
        count(entries) do (l, u, c, pw)
            (pw[l] == c) ⊻ (pw[u] == c)
        end
    end

    result₁ = @btime $part1($entries)
    result₂ = @btime $part2($entries)

    result₁, result₂
end

export day2
