mutable struct Day21_Entity
    name; hp; damage; armor
end

struct Day21_Item
    name; cost; damage; armor
end

function day21()
    shop = Dict("weapons" => [Day21_Item("Dagger",      8, 4, 0)
                              Day21_Item("Shortsword", 10, 5, 0)
                              Day21_Item("Warhammer",  25, 6, 0)
                              Day21_Item("Longsword",  40, 7, 0)
                              Day21_Item("Greataxe",   74, 8, 0)],

                "armor" => [Day21_Item("nothing",     0, 0, 0)
                            Day21_Item("Leather",    13, 0, 1)
                            Day21_Item("Chainmail",  31, 0, 2)
                            Day21_Item("Splintmail", 53, 0, 3)
                            Day21_Item("Bandedmail", 75, 0, 4)
                            Day21_Item("Platemail", 102, 0, 5)],

                "rings" => [Day21_Item("nothing₁",    0, 0, 0)
                            Day21_Item("nothing₂",    0, 0, 0)
                            Day21_Item("Damage +1",  25, 1, 0)
                            Day21_Item("Damage +2",  50, 2, 0)
                            Day21_Item("Damage +3", 100, 3, 0)
                            Day21_Item("Defense +1", 20, 0, 1)
                            Day21_Item("Defense +2", 40, 0, 2)
                            Day21_Item("Defense +3", 80, 0, 3)])

    function stats(equipment)
        cost = sum(x -> x.cost, equipment)
        damage = sum(x -> x.damage, equipment)
        armor = sum(x -> x.armor, equipment)
        cost, damage, armor
    end

    function fight(player, boss)
        player = deepcopy(player)
        boss = deepcopy(boss)

        round = 1
        while all(x -> x.hp > 0, (player, boss))
            attacker = (player, boss)[mod1(round, 2)]
            defender = (boss, player)[mod1(round, 2)]
            damage_dealt = max(1, attacker.damage - defender.armor)
            defender.hp -= damage_dealt
            # println("The $(attacker.name) deals $(damage_dealt) damage; the $(defender.name) goes down to $(defender.hp) hit points.")
            round += 1
        end

        player.hp > 0
    end

    input = joinpath(@__DIR__, "input.txt")
    stats_boss = readlines(input) .|> x -> parse(Int, split(x)[end])
    boss = Day21_Entity("boss", stats_boss...)

    win_costs = Set{Int}()
    lose_costs = Set{Int}()

    for w ∈ shop["weapons"]
        for a ∈ shop["armor"]
            for r₁ ∈ shop["rings"]
                for r₂ ∈ shop["rings"]
                    r₂ == r₁ && continue

                    cost, damage, armor = stats((w, a, r₁, r₂))
                    player = Day21_Entity("player", 100, damage, armor)

                    fight(player, boss) ?
                    push!(win_costs, cost) :
                    push!(lose_costs, cost)
                end
            end
        end
    end

    result₁ = minimum(win_costs)
    result₂ = maximum(lose_costs)

    # @assert result₁ == 91
    # @assert result₂ == 158

    result₁, result₂
end

export day21
