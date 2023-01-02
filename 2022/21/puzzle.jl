function day21_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    to_op(x) = Meta.eval(Meta.parse(x))
    input = map(split, readlines(filename))
    dict = Dict{String,Union{Int,Tuple}}()
    for (var, expr...) in input
        if length(expr) == 1
            dict[var[1:end-1]] = parse(Int, only(expr))
        else
            dict[var[1:end-1]] = (string(expr[1]), to_op(expr[2]), string(expr[3]))
        end
    end
    dict
end

function day21_inv_op(op)
    (op == -) && return +
    (op == *) && return /
    (op == /) && return *
    (op == +) && return -
end

day21_eval(_, value::Int) = value
day21_eval(input, key::String) = day21_eval(input, input[key])
day21_eval(input, (a, op, b)) =
    op(
        day21_eval(input, input[a]),
        day21_eval(input, input[b]))

day21_depends_on(input, value::Int, x) = false
day21_depends_on(input, key::String, x) =
    key == x ? true : day21_depends_on(input, input[key], x)
day21_depends_on(input, (a, op, b), x) =
    day21_depends_on(input, a, x) ||
    day21_depends_on(input, b, x)

day21_solve_for(input, key::String, x, result) =
    x == key ? result : day21_solve_for(input, input[key], x, result)
function day21_solve_for(input, (a, op, b), x, result)
    if day21_depends_on(input, a, x)
        result = day21_inv_op(op)(result, day21_eval(input, b))
        day21_solve_for(input, a, x, result)
    else
        result = (op == -) ?
                 op(day21_eval(input, a), result) :
                 day21_inv_op(op)(result, day21_eval(input, a))
        day21_solve_for(input, b, x, result)
    end
end

function day21_solve_for(input, x::String)
    a, _, b = input["root"]
    day21_depends_on(input, a, x) ?
    day21_solve_for(input, a, x, day21_eval(input, b)) :
    day21_solve_for(input, b, x, day21_eval(input, a))
end

day21_part1(input) = day21_eval(input, "root") |> Int
day21_part2(input) = day21_solve_for(input, "humn") |> Int

@testset "day21" begin
    input = day21_parseinput()
    @test day21_part1(input) == 21208142603224
    @test day21_part2(input) == 3882224466191
end

export day21_parseinput, day21_part1, day21_part2
