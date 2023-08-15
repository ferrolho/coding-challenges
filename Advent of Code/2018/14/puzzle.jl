function day14(n)
    score_at(x) = scoreboard[x+1]  # Julia is 1-indexed

    function create_more()
        new_recipe = score_at(elfs[1]) + score_at(elfs[2])
        append!(scoreboard, parse.(Int, new_recipe |> string |> collect))
        map!(x -> (x + score_at(x) + 1) % length(scoreboard), elfs, elfs)
    end

    elfs = [0, 1]
    scoreboard = [3, 7]
    while length(scoreboard) < n+10; create_more() end
    result₁ = string(scoreboard[n+1:n+10]...)

    result₂ = 0
    needle = string(n)

    elfs = [0, 1]
    scoreboard = [3, 7]
    for i = 0:100_000_000
        create_more()
        if length(scoreboard) ≥ length(needle)+1
            haystack = string(scoreboard[end-length(needle):end]...)
            pos = findfirst(needle, haystack)
            if !isnothing(pos)
                result₂ = length(scoreboard) - length(needle) + pos[1] - 2
                break
            end
        end
    end
    result₂

    result₁, result₂
end

export day14
