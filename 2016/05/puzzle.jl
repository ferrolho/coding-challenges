function day5()
    input = joinpath(@__DIR__, "input.txt")
    door_id = readline(input)

    function solve(id; part₂=false, pw=part₂ ? fill(' ', 8) : [])
        for index = Iterators.countfrom(0)
            hash = id * string(index) |> md5 |> bytes2hex
            if startswith(hash, "00000")
                if part₂
                    x = tryparse(Int, string(hash[6]))
                    (isnothing(x) || x > 7) && continue
                    (pw[x + 1] == ' ') && (pw[x + 1] = hash[7])
                    all(!=(' '), pw) && return join(pw)
                else
                    push!(pw, hash[6])
                    length(pw) == 8 && return join(pw)
                end
            end
        end
    end

    result₁ = solve(door_id, part₂=false)
    result₂ = solve(door_id, part₂=true)

    # @assert result₁ == "c6697b55"
    # @assert result₂ == "8c35d1ab"

    result₁, result₂
end

export day5
