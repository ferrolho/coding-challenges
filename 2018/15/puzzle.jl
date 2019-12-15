abstract type Day15_Unit end

mutable struct Elf <: Day15_Unit
    attack_power::Float64
    position::CartesianIndex
    hitpoints::Float64
    Elf(position::CartesianIndex) = new(3, position, 200)
end

mutable struct Goblin <: Day15_Unit
    attack_power::Float64
    position::CartesianIndex
    hitpoints::Float64
    Goblin(position::CartesianIndex) = new(3, position, 200)
end

elves(units::Array{Day15_Unit}) = filter(x->isa(x, Elf), units)
goblins(units::Array{Day15_Unit}) = filter(x->isa(x, Goblin), units)

position(unit::Day15_Unit) = unit.position
hitpoints(unit::Day15_Unit) = unit.hitpoints

isalive(unit::Day15_Unit) = unit.hitpoints > 0
isdead(unit::Day15_Unit) = !isalive(unit)

attacks(u::Day15_Unit, t::Day15_Unit) = t.hitpoints -= u.attack_power

combat_is_over(units::Array{Day15_Unit}) = all(isdead, elves(units)) ||
                                           all(isdead, goblins(units))

find_targets(unit::Day15_Unit, units::Array{Day15_Unit}) =
    filter(x->!isa(x, typeof(unit)), units) |> x->filter(isalive, x)

function occupancy(dungeon::Array{Char}, units::Array{Day15_Unit})
    dungeon_copy = copy(dungeon)
    foreach(e->dungeon_copy[e.position] = 'E', elves(units))
    foreach(g->dungeon_copy[g.position] = 'G', goblins(units))
    map(≠('.'), dungeon_copy)
end

function find_inrange(positions::Array{CartesianIndex{2}}, dungeon::Array{Char})
    inrange = CartesianIndex[]
    for p ∈ positions
        push!(inrange, p + CartesianIndex( 0,  1))
        push!(inrange, p + CartesianIndex( 1,  0))
        push!(inrange, p + CartesianIndex( 0, -1))
        push!(inrange, p + CartesianIndex(-1,  0))
    end
    filter!(x->dungeon[x] ≠ '#', inrange) |> unique
end

function find_reachable(source::CartesianIndex,
                        inrange::Array{CartesianIndex},
                        occupied::Array{Bool})
    visited = zeros(Bool, size(occupied))
    queue_to_be_explored = [(source, 0)]
    reachable = []

    # Helper function
    function add_to_queue(x::CartesianIndex, distance::Int)
        if !visited[x] && !occupied[x]
            push!(queue_to_be_explored, (x, distance))
            visited[x] = true
        end
    end

    # Compute reachable indices from `source`
    while !isempty(queue_to_be_explored)
        pos, dist = popfirst!(queue_to_be_explored)
        push!(reachable, (pos, dist))

        add_to_queue(pos + CartesianIndex( 0,  1), dist + 1)
        add_to_queue(pos + CartesianIndex( 1,  0), dist + 1)
        add_to_queue(pos + CartesianIndex( 0, -1), dist + 1)
        add_to_queue(pos + CartesianIndex(-1,  0), dist + 1)
        # @show reachable
    end

    # Reachable cells are given by the intersection
    filter(x->x[1] ∈ inrange, reachable)
end

function show_dungeon(dungeon::Array{Char}, units::Array{Day15_Unit})
    dungeon_copy = copy(dungeon)
    replace!(dungeon_copy, '.' => ' ')
    foreach(e->dungeon_copy[e.position] = 'E', elves(units))
    foreach(g->dungeon_copy[g.position] = 'G', goblins(units))
    for r ∈ eachcol(dungeon_copy)
        foreach(x->print("$(x) "), r)
        println()
    end
end

function day15()
    input_raw = readdlm("./15/input.txt", String)
    input = hcat(collect.(input_raw)...)

    # Spawn units
    units = (findall(==('E'), input) .|> Elf) ∪
            (findall(==('G'), input) .|> Goblin)

    # Store dungeon map
    dungeon = input |> x->replace(x, 'E' => '.', 'G' => '.')

    round = 0
    while !combat_is_over(units)
        turns = sort(units, by = u->u.position)

        # --- Uncomment to see combat unfold in your terminal
        sleep(0.05)
        run(`clear`)
        println("After $(round) rounds:")
        show_dungeon(dungeon, filter(isalive, units))
        # foreach(u->println(u.hitpoints), turns)
        println()

        for unit in turns
            isdead(unit) && continue

            targets = find_targets(unit, units)
            unit_range = find_inrange([unit.position], dungeon)
            occupied = occupancy(dungeon, filter(x->isalive(x) && x ≠ unit, units))

            # If unit is in range of any target, attack
            if any(t->t.position ∈ unit_range, targets)
                candidates = filter(t->t.position ∈ unit_range, targets)
                candidates = filter(t->t.hitpoints == minimum(hitpoints.(candidates)), candidates)
                target_selected = sort(candidates, by = u->u.position) |> first
                attacks(unit, target_selected)
            elseif !isempty(targets)
                inrange = find_inrange(position.(targets), dungeon)
                reachable = find_reachable(unit.position, inrange, occupied)
                if !isempty(reachable)
                    chosen = minimum(x->(x[2], x[1]), sort(reachable))[2]
                    # Calculate next step of this unit
                    reachable = find_reachable(chosen, unit_range, occupied)
                    chosen = minimum(x->(x[2], x[1]), sort(reachable))[2]
                    unit.position = chosen

                    # If unit is in range of any target, attack
                    unit_range = find_inrange([unit.position], dungeon)
                    if any(t->t.position ∈ unit_range, targets)
                        candidates = filter(t->t.position ∈ unit_range, targets)
                        candidates = filter(t->t.hitpoints == minimum(hitpoints.(candidates)), candidates)
                        target_selected = sort(candidates, by = u->u.position) |> first
                        attacks(unit, target_selected)
                    end
                end
            end
        end

        round += 1
    end

    total_rounds = round - 1
    remaining_hp = filter(isalive, units) .|> hitpoints
    result₁ = total_rounds * sum(remaining_hp) |> Int
    # @show total_rounds remaining_hp result₁
    # @show length(remaining_hp)
end

export day15
