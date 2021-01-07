function day13()
    input = joinpath(@__DIR__, "input.txt")
    people = readlines(input) .|> (x -> split(x)[1]) |> unique
    scores = Dict(split.(readlines(input), Ref((' ', '.'))) .|> x ->
                  (x[1], x[11]) => (x[3] == "lose" ? -1 : 1) * parse(Int, x[4]))

    function optimize(people, scores)
        max_score = nothing
        opt_table = nothing

        people = copy(people)
        head = pop!(people)

        for x = permutations(people)
            total = 0
            table = [head; x]

            for i = 1:length(table)
                j = mod1(i + 1, length(table))
                total += scores[(table[i], table[j])]
                total += scores[(table[j], table[i])]
            end

            if isnothing(max_score) || total > max_score
                max_score = total
                opt_table = table
            end
        end

        max_score, opt_table
    end

    result₁ = optimize(people, scores)[1]

    for guest ∈ people
        scores[("Myself", guest)] = 0
        scores[(guest, "Myself")] = 0
    end
    push!(people, "Myself")

    result₂ = optimize(people, scores)[1]

    # @assert result₁ == 664
    # @assert result₂ == 640

    result₁, result₂
end

export day13
