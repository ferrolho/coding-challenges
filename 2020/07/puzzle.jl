function day7()
    input = joinpath(@__DIR__, "input.txt")

    rules = Dict{String,Union{Nothing,Dict}}()

    for line in eachline(input)
        bag, content = split(line, "bags contain") .|> strip

        if occursin("no other bags", content)
            rules[bag] = nothing
        else
            content = replace(content, r"(\bbags?\b)|(\.)" => "")
            content = split(content, ",") .|> strip .|> x -> split(x, limit=2)
            keys, values = last.(content), parse.(Int, first.(content))
            rules[bag] = Dict{String,Int}(keys .=> values)
        end
    end

    function containsbag(haystack::AbstractString, needle)
        if isnothing(rules[haystack])
            false
        elseif needle ∈ keys(rules[haystack])
            true
        else
            any(containsbag.(keys(rules[haystack]), needle))
        end
    end

    cache = Dict{String,Int}()

    function totalbags(bag)
        haskey(cache, bag) && return cache[bag]

        if isnothing(rules[bag])
            cache[bag] = 0
        else
            cache[bag] = sum(rules[bag]) do (k, v)
                v + v * totalbags(k)
            end
        end

        cache[bag]
    end

    result₁ = count(keys(rules)) do bag
        containsbag(bag, "shiny gold")
    end

    result₂ = totalbags("shiny gold")

    result₁, result₂
end

export day7
