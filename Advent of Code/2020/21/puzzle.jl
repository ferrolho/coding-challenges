function day21()
    input = joinpath(@__DIR__, "input.txt")
    food = map(eachline(input)) do line
        a, b = split(line, "(contains ")
        ingredients = split(a) |> Set{String}
        allergens = split(b[1:end - 1], ", ") |> Set{String}
        (ingredients = ingredients, allergens = allergens)
    end

    all_allergens = mapreduce(x -> x.allergens, ∪, food)
    all_ingredients = mapreduce(x -> x.ingredients, ∪, food)

    inert_ingredients = Set{String}([])

    for ingredient ∈ all_ingredients
        # Gather all the allergens that are
        # associated with a given ingredient.
        candidates = reduce(∪, x.allergens for x ∈ food
                               if ingredient ∈ x.ingredients)

        all(map(collect(candidates)) do candidate
            food_with_allergen = filter(x -> candidate ∈ x.allergens, food)
            any(x -> ingredient ∉ x.ingredients, food_with_allergen)
        end) && push!(inert_ingredients, ingredient)
    end

    total = 0
    for ingredient ∈ inert_ingredients, x ∈ food
        total += count(==(ingredient), x.ingredients)
    end
    result₁ = total

    @assert result₁ == 1882

    # Discard inert ingredients
    for x ∈ food, ingredient ∈ inert_ingredients
        filter!(≠(ingredient), x.ingredients)
    end

    setdiff!(all_ingredients, inert_ingredients)

    solution = Dict{String,String}()

    gather_allergens(k) = reduce(∪, x.allergens for x ∈ food if x.ingredients == k)

    while length(food) |> !isone
        unique_food_ingredients = map(x -> x.ingredients, food) |> unique

        # Merge allergen information of food with the same ingredients
        food = [(ingredients = k, allergens = gather_allergens(k))
                for k ∈ unique_food_ingredients]

        filter!(x -> length(x.allergens) < length(all_allergens), food)

        sort!(food, by=x -> length(x[2]))

        dangerous_ingredient = setdiff(all_ingredients, last(food).ingredients) |> only
        respective_allergen = setdiff(all_allergens, last(food).allergens) |> only

        delete!(all_ingredients, dangerous_ingredient)
        delete!(all_allergens, respective_allergen)

        solution[respective_allergen] = dangerous_ingredient

        for x ∈ food
            filter!(≠(dangerous_ingredient), x.ingredients)
            filter!(≠(respective_allergen), x.allergens)
        end
    end

    result₂ = solution |> sort |> values |> x -> join(x, ",")

    @assert result₂ == "xgtj,ztdctgq,bdnrnx,cdvjp,jdggtft,mdbq,rmd,lgllb"

    result₁, result₂
end

export day21
