function day8_parseinput()
    input = read(joinpath(@__DIR__, "input.txt"), String)

    entries = split(input, "\n", keepempty = false) .|>
              x -> split.(split(x, "|"))

    foreach(entries) do (A, B)
        map!(x -> sort!([c for c in x]) |> join, A, A)
        map!(x -> sort!([c for c in x]) |> join, B, B)
    end

    entries
end

function day8_part1(input)
    unique_num_segments = (2, 3, 4, 7)
    sum(input) do entry
        sum(length(x) ∈ unique_num_segments for x in entry[2])
    end
end

function day8_digit_to_num_segments(digit)
    @assert 0 <= digit <= 9
    (6, 2, 5, 5, 4, 5, 6, 3, 7, 6)[digit + 1]
end

# We find new digits based on the intersection of already-known digits.
day8_find6(r, d2p) = only(p for p in r if length(p ∪ d2p[1]) == 7)
day8_find3(r, d2p) = only(p for p in r if length(p ∪ d2p[1]) == 5)
day8_find0(r, d2p) = only(p for p in r if length(p ∪ d2p[3]) == 7)
day8_find2(r, d2p) = only(p for p in r if length(p ∪ d2p[4]) == 7)
day8_find9(r, d2p) = only(p for p in r if length(p ∪ d2p[6]) == 7)

day8_pattern_to_digit(d2p) = Dict(v => string(k) for (k, v) in d2p)

function day8_decode_patterns(patterns)
    # This will give us the signals for digits: [1, 4, 7, 8]
    unique_num_segments = (2, 3, 4, 7)
    digit_to_pattern = Dict(
        digit => only(p for p in patterns if length(p) == day8_digit_to_num_segments(digit))
        for digit = 0:9 if day8_digit_to_num_segments(digit) ∈ unique_num_segments
    )

    remaining = filter(∉(values(digit_to_pattern)), patterns)

    pattern_6 = day8_find6(remaining, digit_to_pattern)
    filter!(!=(pattern_6), remaining)
    digit_to_pattern[6] = pattern_6

    pattern_3 = day8_find3(remaining, digit_to_pattern)
    filter!(!=(pattern_3), remaining)
    digit_to_pattern[3] = pattern_3

    pattern_0 = day8_find0(remaining, digit_to_pattern)
    filter!(!=(pattern_0), remaining)
    digit_to_pattern[0] = pattern_0

    pattern_2 = day8_find2(remaining, digit_to_pattern)
    filter!(!=(pattern_2), remaining)
    digit_to_pattern[2] = pattern_2

    pattern_9 = day8_find9(remaining, digit_to_pattern)
    filter!(!=(pattern_9), remaining)
    digit_to_pattern[9] = pattern_9

    digit_to_pattern[5] = only(remaining)

    digit_to_pattern
end

function day8_part2(input)
    sum(input) do entry
        patterns, output = entry
        digit_to_pattern = day8_decode_patterns(patterns)
        pattern_to_digit = day8_pattern_to_digit(digit_to_pattern)
        mapreduce(x -> pattern_to_digit[x], string, output) |> x -> parse(Int, x)
    end
end

@testset "day08" begin
    input = day8_parseinput()
    @test day8_part1(input) == 381
    @test day8_part2(input) == 1023686
end

export day8_parseinput, day8_part1, day8_part2
