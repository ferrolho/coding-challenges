function day11()
    input = joinpath(@__DIR__, "input.txt")
    pw₀ = readline(input)

    char_min, char_max = Int.(('a', 'z'))

    pw2num(pw::String) = pw |> collect .|> Int
    num2pw(num::Array{Int,1}) = num .|> Char |> join

    function inc!(num::Array{Int,1})
        for i = length(num):-1:1
            num[i] += 1
            if num[i] > char_max
                num[i] = char_min
            else
                break
            end
        end
        num
    end

    function hasincreasingstraight(num::Array{Int,1})
        for i = 1:length(num) - 2
            all(isone, diff(num[i:i + 2])) && return true
        end
        return false
    end

    function hasconfusingletters(num::Array{Int,1})
        any(Int.(('i', 'o', 'l')) .∈  Ref(num))
    end

    function hasatleasttwodifferentpairs(num::Array{Int,1})
        pairs = Set([])
        for i = 1:length(num) - 1
            if num[i] == num[i + 1]
                push!(pairs, num[i])
            end
        end
        length(pairs) >= 2
    end

    function isvalid(num::Array{Int,1})
        cond₁ = hasincreasingstraight(num)
        cond₂ = !hasconfusingletters(num)
        cond₃ = hasatleasttwodifferentpairs(num)
        cond₁ & cond₂ & cond₃
    end

    function findnextpassword(pw::String)
        num = pw2num(pw)
        found = false
        while !found
            inc!(num)
            isvalid(num) && (found = true)
        end
        num2pw(num)
    end

    result₁ = findnextpassword(pw₀)
    result₂ = findnextpassword(result₁)

    # @assert result₁ == "cqjxxyzz"
    # @assert result₂ == "cqkaabcc"

    result₁, result₂
end

export day11
