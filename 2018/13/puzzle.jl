mutable struct Day13_Cart
    position::CartesianIndex
    velocity::CartesianIndex
    decision::Int  # 0: turn left; 1: Go straight; 2: turn right
    alive::Bool
    Day13_Cart(position::CartesianIndex,
               velocity::CartesianIndex) = new(position, velocity, 0, true)
end

position(cart::Day13_Cart) = cart.position
isalive(cart::Day13_Cart) = cart.alive

function day13()
    char_to_velocity(idx) = int_to_velocity(Dict('>' => 0, '^' => 1, '<' => 2, 'v' => 3)[idx])
    int_to_velocity(vᵢ) = [CartesianIndex( 1, 0), CartesianIndex( 0,-1),
                           CartesianIndex(-1, 0), CartesianIndex( 0, 1)][vᵢ + 1]
    velocity_to_int = Dict(CartesianIndex( 1, 0) => 0,
                           CartesianIndex( 0,-1) => 1,
                           CartesianIndex(-1, 0) => 2,
                           CartesianIndex( 0, 1) => 3)

    function do_intersection(cart::Day13_Cart)
        if cart.decision == 0      # Turn left
            vᵢ = velocity_to_int[cart.velocity]
            vᵢ = (vᵢ + 1) % 4
            cart.velocity = int_to_velocity(vᵢ)
        elseif cart.decision == 1  # Go straight (do nothing)
            nothing
        elseif cart.decision == 2  # Turn right
            vᵢ = velocity_to_int[cart.velocity]
            vᵢ = (vᵢ + 3) % 4
            cart.velocity = int_to_velocity(vᵢ)
        end
        # Update state machine
        cart.decision = (cart.decision + 1) % 3
    end

    # Read input
    tracks = hcat(collect.(readlines("./13/input.txt"))...)

    # Spawn carts
    carts = findall(∈(['>','^','<','v']), tracks) .|>
            x->Day13_Cart(x, char_to_velocity(tracks[x]))

    # Clear carts from the tracks representation
    replace!(c->c ∈ ">^<v" ? '-' : c, tracks)

    # Results storage
    result₁, result₂ = nothing, nothing

    done = false
    while !done
        # --- Display system's state
        # run(`clear`)
        # state = copy(tracks)
        # state[position.(filter(isalive, carts))] .= '@'
        # foreach(x->println(string(x...)), state |> eachcol)
        # sleep(0.05)

        for cart ∈ sort!(carts, by = c->c.position)
            !isalive(cart) && continue

            # Cart takes a step
            cart.position += cart.velocity

            # Special treatment for intersections and turns
            if tracks[cart.position] == '+'
                do_intersection(cart)
            elseif tracks[cart.position] ∈ "/\\"
                if tracks[cart.position] == '/'
                    if     velocity_to_int[cart.velocity] == 0; cart.velocity = int_to_velocity(1)
                    elseif velocity_to_int[cart.velocity] == 1; cart.velocity = int_to_velocity(0)
                    elseif velocity_to_int[cart.velocity] == 2; cart.velocity = int_to_velocity(3)
                    elseif velocity_to_int[cart.velocity] == 3; cart.velocity = int_to_velocity(2)
                    end
                else
                    if     velocity_to_int[cart.velocity] == 0; cart.velocity = int_to_velocity(3)
                    elseif velocity_to_int[cart.velocity] == 1; cart.velocity = int_to_velocity(2)
                    elseif velocity_to_int[cart.velocity] == 2; cart.velocity = int_to_velocity(1)
                    elseif velocity_to_int[cart.velocity] == 3; cart.velocity = int_to_velocity(0)
                    end
                end
            end
            
            # Check for crashes
            for (c1, c2) ∈ subsets(filter(isalive, carts), 2)
                if c1.position == c2.position
                    # Answer for Part 1
                    if isnothing(result₁)
                        result₁ = c1.position - CartesianIndex(1, 1)
                    end

                    # Remove carts which have collided
                    c1.alive = false
                    c2.alive = false
                    break
                end
            end
        end

        # Answer for Part 2
        if count(isalive, carts) == 1
            result₂ = filter(isalive, carts)[1].position - CartesianIndex(1, 1)
        end

        done = !any(isnothing, [result₁, result₂])
    end

    result₁, result₂
end

export day13
