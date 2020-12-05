function day5()
    input = joinpath(@__DIR__, "input.txt")
    bps = readlines(input)

    function seatid(bp)
        rows, cols = 0:127, 0:7

        for c in bp
            c == 'F' && (rows = first(rows):floor(Int, median(rows)))
            c == 'B' && (rows = ceil(Int, median(rows)):last(rows))
            c == 'L' && (cols = first(cols):floor(Int, median(cols)))
            c == 'R' && (cols = ceil(Int, median(cols)):last(cols))
        end

        only(rows) * 8 + only(cols)  # Seat ID formula
    end

    seat_ids = seatid.(bps)
    max_id = maximum(seat_ids)
    min_id = minimum(seat_ids)

    result₁ = max_id
    result₂ = setdiff(min_id:max_id, seat_ids) |> only

    result₁, result₂
end

export day5
