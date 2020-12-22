function day22()
    input = joinpath(@__DIR__, "input.txt")
    p₁, p₂ = split(read(input, String), "\n\n") .|>
             x -> parse.(Int, split(x, '\n', keepempty=false)[2:end])

    function play(p₁, p₂, part₂)
        seen = Set{Tuple{Array,Array}}([])

        while !any(isempty.((p₁, p₂)))
            (p₁, p₂) ∈ seen && return 1, p₁  # infinite-game-prevention rule
            push!(seen, copy.((p₁, p₂)))

            c₁, c₂ = popfirst!.((p₁, p₂))  # both players draw their top card

            if part₂ && all(length.((p₁, p₂)) .>= (c₁, c₂))
                w, _ = play(copy.((p₁[1:c₁], p₂[1:c₂]))..., part₂)
            elseif c₁ > c₂  w = 1
            elseif c₂ > c₁  w = 2
            else @error "Unexpected case: c₁ == c₂" end

            w == 1 && push!(p₁, c₁, c₂)  # player 1 wins
            w == 2 && push!(p₂, c₂, c₁)  # player 2 wins
        end

        !isempty(p₁) ? (1, p₁) : (2, p₂)
    end

    result₁, result₂ = map([false, true]) do part₂
        _, deck = play(copy.((p₁, p₂))..., part₂)
        multipliers = length(deck):-1:1
        sum(deck .* multipliers)
    end

    result₁, result₂
end

export day22
