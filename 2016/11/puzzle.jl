abstract type Day11_Entity end
struct Generator <: Day11_Entity name end
struct Microchip <: Day11_Entity name end

function day11()
    input = joinpath(@__DIR__, "input.txt")

    function issafe(floor)
        all(x -> x isa Microchip, floor) && return true
        gs_names = Set{String}(x.name for x ∈ floor if x isa Generator)
        all(m -> m.name ∈ gs_names, filter(x -> x isa Microchip, floor))
    end

    function bfs(nodes)
        while !isempty(nodes)
            floors, src, steps = popfirst!(nodes)

            # Found shortest path to goal
            length(floors[4]) == num_objects && return steps

            c₁ = combinations(collect(floors[src]), 1)
            c₂ = combinations(collect(floors[src]), 2)

            for c ∈ c₁ ∪ c₂
                if any(x -> x isa Generator, c) &&
                   any(x -> x isa Microchip, c) &&
                   c[1].name != c[2].name
                    # Can't take this in the elevator
                else
                    for step = (-1, +1)
                        dst = src + step
                        if 1 <= dst <= 4
                            _floors = deepcopy(floors)
                            setdiff!(_floors[src], c)
                            union!(_floors[dst], c)

                            if issafe(_floors[src]) &&
                               issafe(_floors[dst]) &&
                               (_floors, dst) ∉ seen
                                push!(nodes, (_floors, dst, steps + 1))
                                push!(seen, (_floors, dst))
                            end
                        end
                    end
                end
            end
        end
    end

    # -- Parse Input -- #

    State = Dict{Int,Set{Day11_Entity}}

    floors = State(i => Set{Day11_Entity}() for i = 1:4)
    for (i, line) in enumerate(eachline(input))
        gs = collect(eachmatch(r"(\w+) generator", line)) .|> x -> only(x.captures)
        ms = collect(eachmatch(r"(\w+)-compatible", line)) .|> x -> only(x.captures)
        union!(floors[i], Generator.(gs))
        union!(floors[i], Microchip.(ms))
    end

    # -- Part One -- # ~35 seconds

    num_objects = sum(length, values(floors))
    seen = Set{Tuple{State,Int}}()
    result₁ = bfs([(floors, 1, 0)])

    # -- Part Two -- # 3 hours, 30 minutes

    push!(floors[1], Generator("elerium"), Generator("dilithium"))
    push!(floors[1], Microchip("elerium"), Microchip("dilithium"))

    num_objects = sum(length, values(floors))
    seen = Set{Tuple{State,Int}}()
    result₂ = bfs([(floors, 1, 0)])

    # @assert result₁ == 37
    # @assert result₂ == 61

    result₁, result₂
end

export day11
