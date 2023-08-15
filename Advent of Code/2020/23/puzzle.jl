function day23()
    input = joinpath(@__DIR__, "input.txt")

    function peek(cll, c, n)
        result = similar(cll, n)
        peek!(result, cll, c, n)
    end

    function peek!(result, cll, c, n)
        for i = 1:n
            result[i] = cll[c]
            c = cll[c]
        end
        result
    end

    function play!(cups; moves=10)
        cll = similar(cups)  # Circular Linked-List (CLL)

        # Prepare the circular linked-list
        foreach(enumerate(cups)) do (pos, cup)
            # Indexing a cup gives the cup that comes after it
            cll[cup] = cups[mod1(pos + 1, length(cups))]
        end

        current_cup = cups[1]  # Select current cup
        three_cups = similar(cups, 3)  # Pre-allocation

        for move = 1:moves
            # Pick up three cups next to the current cup
            peek!(three_cups, cll, current_cup, 3)

            # Select destination cup
            destination_cup = mod1(current_cup - 1, max_cup)
            while destination_cup ∈ three_cups
                destination_cup = mod1(destination_cup - 1, max_cup)
            end

            # "Stitch" gap from the removal
            cll[current_cup] = cll[last(three_cups)]

            # Insert three cups next to the destination cup
            cll[last(three_cups)] = cll[destination_cup]
            cll[destination_cup] = first(three_cups)

            # Proceed to the next cup
            current_cup = cll[current_cup]
        end

        cll
    end

    # --- Part One --- #

    cups = parse.(Int32, readline(input) |> collect)
    min_cup, max_cup = extrema(cups)

    cll = play!(cups, moves=100)
    result₁ = peek(cll, 1, length(cll) - 1) |>
              join |> x -> parse(Int32, x)

    @assert result₁ == 98742365

    # --- Part Two --- #

    cups = Int32[cups; max_cup + 1:1_000_000]
    max_cup = 1_000_000

    cll = play!(cups, moves=10_000_000)
    result₂ = peek(cll, 1, 2) |> prod

    @assert result₂ == 294320513093

    result₁, result₂
end

export day23
