day10_parseinput() = read(joinpath(@__DIR__, "input.txt"), String) |> split

function day10(navigation_subsystem)
    opening_chars = "([{<"
    closing_chars = ")]}>"

    char_to_match = Dict(
        '(' => ')', '[' => ']', '{' => '}', '<' => '>',
        ')' => '(', ']' => '[', '}' => '{', '>' => '<',
    )

    scores_table_part1 = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    scores_table_part2 = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)

    result₁ = 0
    corrupted_lines = Int[]

    for (i, line) in enumerate(navigation_subsystem)
        expected = Char[]

        for c in line
            if c in opening_chars
                push!(expected, char_to_match[c])
            elseif c in closing_chars
                c_expected = pop!(expected)
                if c != c_expected
                    # @error "Expected $(c_expected), but found $(c) instead."
                    result₁ += scores_table_part1[c]
                    push!(corrupted_lines, i)
                    break
                end
            else
                @error "Unexpected char $(c)."
            end
        end
    end

    incomplete_lines = [line for (i, line) in enumerate(navigation_subsystem) if i ∉ corrupted_lines]

    scores_part2 = Int[]

    for line in incomplete_lines
        expected = Char[]
        foreach(line) do c
            c ∈ opening_chars && push!(expected, char_to_match[c])
            c ∈ closing_chars && pop!(expected)
        end

        completion = expected |> reverse |> join

        this_score = 0
        for c in completion
            this_score = this_score * 5 + scores_table_part2[c]
        end

        push!(scores_part2, this_score)

        # @info "Complete by adding $(completion)."
        # println(this_score)
    end

    result₂ = scores_part2 |> sort! |> median |> Int

    result₁, result₂
end

@testset "day10" begin
    navigation_subsystem = day10_parseinput()
    result₁, result₂ = day10(navigation_subsystem)

    @test result₁ == 392139
    @test result₂ == 4001832844
end

export day10_parseinput, day10
