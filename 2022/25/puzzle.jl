function day25_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    readlines(filename)
end

function day25_to_snafu(decimal::Int)
    decimal == 0 && return ""
    a, b = fldmod(decimal, 5)
    b == 0 && return day25_to_snafu(a) * '0'
    b == 1 && return day25_to_snafu(a) * '1'
    b == 2 && return day25_to_snafu(a) * '2'
    b == 3 && return day25_to_snafu(a + 1) * '='
    b == 4 && return day25_to_snafu(a + 1) * '-'
end

function day25_to_decimal(snafu::String)
    function snafu_digit_to_decimal(snafu_digit::Char)
        snafu_digit == '-' && return -1
        snafu_digit == '=' && return -2
        snafu_digit == '0' && return 0
        snafu_digit == '1' && return 1
        snafu_digit == '2' && return 2
    end

    sum(snafu_digit_to_decimal(snafu_digit) * 5^i
        for (snafu_digit, i) in zip(snafu, length(snafu)-1:-1:0))
end

day25(input) = day25_to_decimal.(input) |> sum |> day25_to_snafu

@testset "day25" begin
    input = day25_parseinput()
    @test day25(input) == "2=0--0---11--01=-100"
end

export day25_parseinput, day25
