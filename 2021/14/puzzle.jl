function day14_parseinput()
    input = read(joinpath(@__DIR__, "input.txt"), String)
    template, raw_rules... = split(input)
    raw_rules = reshape(raw_rules, (3, :))
    rules = Dict(Tuple(x[1]) => only(x[3])
                 for x in eachcol(raw_rules))
    template, rules
end

"""
Grow the `template` polymer, according to the `rules`, for `num_steps`.
"""
function day14_grow(template, rules, num_steps)
    elem_pairs = [Tuple(template[i:i+1])
                  for i = 1:length(template)-1]
    tracker = Dict(x => count(==(x), elem_pairs)
                   for x ∈ unique(elem_pairs))
    for _ = 1:num_steps
        new_tracker = Dict{Tuple{Char,Char},Int}()
        for ((l, r), v) ∈ tracker
            m = rules[(l, r)]
            k1, k2 = (l, m), (m, r)
            new_tracker[k1] = get(new_tracker, k1, 0) + v
            new_tracker[k2] = get(new_tracker, k2, 0) + v
        end
        tracker = new_tracker
    end
    tracker
end

function day14_solve(template, rules, num_steps)
    pairs_tracker = day14_grow(template, rules, num_steps)
    unique_elems = union(keys(pairs_tracker)...)

    e2c = Dict(e => sum(e == k[2] ? v : 0
                        for (k, v) in pairs_tracker)
               for e in unique_elems)

    e2c[argmax(e2c)] - e2c[argmin(e2c)]
end

day14_part1(template, rules) = day14_solve(template, rules, 10)
day14_part2(template, rules) = day14_solve(template, rules, 40)

@testset "day14" begin
    template, rules = day14_parseinput()
    @test day14_part1(template, rules) == 2010
    @test day14_part2(template, rules) == 2437698971143
end

export day14_parseinput, day14_part1, day14_part2
