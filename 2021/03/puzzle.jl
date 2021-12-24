function day3_parseinput()
    input = joinpath(@__DIR__, "input.txt")
    mapreduce(collect, hcat, eachline(input)) |> permutedims
end

function day3_most_common(x)
    num_0s = count(==('0'), x)
    num_1s = count(==('1'), x)
    num_0s > num_1s ? '0' : '1'
end

function day3_least_common(x)
    num_0s = count(==('0'), x)
    num_1s = count(==('1'), x)
    num_0s <= num_1s ? '0' : '1'
end

rate_aux(f, input) = mapreduce(f, string, eachcol(input)) |> binary_string_to_decimal
day3_gamma_rate(input) = rate_aux(day3_most_common, input)
day3_epsilon_rate(input) = rate_aux(day3_least_common, input)

function rating_aux(f, input)
    for j = 1:size(input, 2)
        colⱼ = input[:,j]
        input = input[colⱼ .== f(colⱼ), :]
        size(input, 1) == 1 && break
    end
    string(input...) |> binary_string_to_decimal
end

day3_oxygen_generator_rating(input) = rating_aux(day3_most_common, input)
day3_CO2_scrubber_rating(input) = rating_aux(day3_least_common, input)

function day3_part1(input)
    gamma_rate = day3_gamma_rate(input)
    epsilon_rate = day3_epsilon_rate(input)
    power_consumption = gamma_rate * epsilon_rate
end

function day3_part2(input)
    oxygen_generator_rating = day3_oxygen_generator_rating(input)
    CO2_scrubber_rating = day3_CO2_scrubber_rating(input)
    life_support_rating = oxygen_generator_rating * CO2_scrubber_rating
end

@testset "day03" begin
    input = day3_parseinput()
    @test day3_part1(input) == 4138664
    @test day3_part2(input) == 4273224
end

export day3_parseinput, day3_part1, day3_part2
