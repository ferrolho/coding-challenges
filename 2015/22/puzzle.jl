mutable struct Day22_Entity
    name; hp; mana; mana_spent; damage; armor
end

struct Day22_Spell
    name; cost; queue
end

function day22()
    function solve(; hard=false)
        input = joinpath(@__DIR__, "input.txt")
        boss_hp, boss_damage = readlines(input) .|> x -> parse(Int, split(x)[end])

        # Initialise boss and player
        boss = Day22_Entity("boss", boss_hp, 0, 0, boss_damage, 0)
        player = Day22_Entity("player", 50, 500, 0, 0, 0)

        spells = [Day22_Spell("Magic Missile",  53, [(0, 0, 4, 0)])
                  Day22_Spell("Drain",          73, [(2, 0, 2, 0)])
                  Day22_Spell("Shield",        113, [(0, 0, 0, 0); fill((0,   0, 0, 7), 6)])
                  Day22_Spell("Poison",        173, [(0, 0, 0, 0); fill((0,   0, 3, 0), 6)])
                  Day22_Spell("Recharge",      229, [(0, 0, 0, 0); fill((0, 101, 0, 0), 5)])]

        best = nothing

        function fight(player, boss, effects=Dict(), round=1)
            if boss.hp <= 0
                # Player won the fight
                if isnothing(best) || player.mana_spent < best
                    best = player.mana_spent
                end
            elseif player.hp <= 0
                # Player lost the fight
            elseif !isnothing(best) && player.mana_spent > best
                # Not worth developing this fight any longer
            else
                # Accumulate effects of all active spells
                result = (0, 0, 0, 0)
                for (k, v) ∈ effects
                    result = result .+ popfirst!(v)
                end

                # Apply effects of active spells
                hp, mana, damage, armor = result
                player.hp += hp
                player.mana += mana
                boss.hp -= damage
                player.armor = armor

                # Remove spell if its effect has ended
                filter!(p -> !isempty(p.second), effects)

                if mod1(round, 2) == 1  # Player's turn
                    (hard == true) && (player.hp -= 1)
                    if player.hp > 0
                        if all(x -> x.cost > player.mana, spells)
                            # Player lost due to lack of mana to buy a spell
                        else
                            for spell ∈ spells
                                spell.name ∈ keys(effects) && continue
                                spell.cost > player.mana && continue

                                # Copy stuff for forks of the fight
                                _player = deepcopy(player)
                                _boss = deepcopy(boss)
                                _effects = deepcopy(effects)

                                _player.mana -= spell.cost
                                _player.mana_spent += spell.cost

                                first, rest = Iterators.peel(spell.queue)

                                # Apply spell immediately
                                hp, mana, damage, armor = first
                                _player.hp += hp
                                _player.mana += mana
                                _boss.hp -= damage
                                _player.armor = armor

                                if !isempty(rest)
                                    _effects[spell.name] = collect(rest)
                                end

                                fight(_player, _boss, _effects, round + 1)
                            end
                        end
                    end
                else  # Boss's turn
                    player.hp -= max(1, boss.damage - player.armor)
                    fight(player, boss, effects, round + 1)
                end
            end
        end

        fight(player, boss)

        best
    end

    result₁ = solve(hard=false)
    result₂ = solve(hard=true)

    # @assert result₁ == 953
    # @assert result₂ == 1289

    result₁, result₂
end

export day22
