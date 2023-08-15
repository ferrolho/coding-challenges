function day19()
    input = joinpath(@__DIR__, "input.txt")
    rules_str, messages_str = split(read(input, String), "\n\n") .|>
                              x -> split(x, '\n', keepempty=false)

    rules = Dict{Int,Union{Char,Array{Array{Int,1},1}}}()

    for str ∈ rules_str
        k, v = split(str, ": ")
        k = parse(Int, k)

        if v == "\"a\""
            rules[k] = 'a'
        elseif v == "\"b\""
            rules[k] = 'b'
        else
            options = split.(split(v, "|")) .|>
                      x -> parse.(Int, x)
            rules[k] = options
        end
    end

    function aux(rules, k, part₂=false)
        if typeof(rules[k]) == Char
            rules[k]
        else
            "(" * join(map(rules[k]) do rule
                "(" * join(map(rule) do x
                    if part₂ && x == 8
                        p42 = aux(rules, 42)
                        "$p42+"
                    elseif part₂ && x == 11
                        p42 = aux(rules, 42)
                        p31 = aux(rules, 31)
                        "(?<x>$p42\\g<x>?$p31)"
                    else
                        aux(rules, x)
                    end
                end) * ")"
            end, "|") * ")"
        end
    end

    rx = Regex(string("\\b", aux(rules, 0), "\\b"))
    result₁ = count(x -> occursin(rx, x), messages_str)

    rx = Regex(string("\\b", aux(rules, 0, true), "\\b"))
    result₂ = count(x -> occursin(rx, x), messages_str)

    # @assert result₁ == 162
    # @assert result₂ == 267

    result₁, result₂
end

export day19
