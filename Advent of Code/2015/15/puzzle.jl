function day15()
    input = joinpath(@__DIR__, "input.txt")

    ingredients = map(eachline(input)) do line
        rx = r"(\w+): capacity (-*\d+), durability (-*\d+), flavor (-*\d+), texture (-*\d+), calories (-*\d+)"
        name, capacity, durability, flavor, texture, calories = only(eachmatch(rx, line)).captures
        name => parse.(Int, (capacity, durability, flavor, texture, calories))
    end |> Dict

    function calculate(ingredients, recipe)
        properties = mapreduce(hcat, recipe) do (name, tsps)
            [tsps * p for p in ingredients[name]]
        end
        scores = sum(properties[1:4,:], dims=2)
        total_score = any(<(0), scores) ? 0 : prod(scores)
        calories = sum(properties[5,:])
        total_score, calories
    end

    function find_best_cookie(ingredients; calories=nothing)
        best_score = nothing
        best_recipe = nothing

        candidates = fill(0:100, length(ingredients)) |>
                     x -> Iterators.product(x...) |> collect |>
                     rs -> filter(x -> sum(x) == 100, rs) .|>
                     r -> Dict(keys(ingredients) .=> r)

        for recipe = candidates
            score, cals = calculate(ingredients, recipe)
            !isnothing(calories) && cals != calories && continue
            if isnothing(best_score) || score > best_score
                best_score = score
                best_recipe = recipe
            end
        end

        best_score, best_recipe
    end

    result₁ = find_best_cookie(ingredients)[1]
    result₂ = find_best_cookie(ingredients, calories=500)[1]

    # @assert result₁ == 222870
    # @assert result₂ == 117936

    result₁, result₂
end

export day15
