mutable struct Day12_State{T <: Real}
    x::T  # x-coordinate
    y::T  # y-coordinate
    θ::T  # rotation (in degrees)
end

function day12()
    input = joinpath(@__DIR__, "input.txt")

    moves = map(eachline(input)) do s
        a = first(s)
        v = parse(Int, s[2:end])
        (action = a, value = v)
    end

    function update₁!(move, ship)
            if move.action == 'N'  ship.y += move.value
        elseif move.action == 'S'  ship.y -= move.value
        elseif move.action == 'E'  ship.x += move.value
        elseif move.action == 'W'  ship.x -= move.value
        elseif move.action == 'L'  ship.θ += move.value
        elseif move.action == 'R'  ship.θ -= move.value
        elseif move.action == 'F'
            s, c = sincos(deg2rad(ship.θ))
            ship.x += move.value * c
            ship.y += move.value * s
        else
            @error "Unknown move action" move.action
        end
    end

    function update₂!(move, ship, waypoint)
            if move.action == 'N'  waypoint.y += move.value
        elseif move.action == 'S'  waypoint.y -= move.value
        elseif move.action == 'E'  waypoint.x += move.value
        elseif move.action == 'W'  waypoint.x -= move.value
        elseif move.action ∈ ('L', 'R')
            mult = move.action == 'R' ? -1 : 1
            s, c = sincos(mult * deg2rad(move.value))
            x, y = waypoint.x, waypoint.y
            waypoint.x = c * x - s * y
            waypoint.y = s * x + c * y
        elseif move.action == 'F'
            ship.x += move.value * waypoint.x
            ship.y += move.value * waypoint.y
        else
            @error "Unknown move action" move.action
        end
    end

    function part₁(moves)
        ship = Day12_State{Float64}(0, 0, 0)
        foreach(x -> update₁!(x, ship), moves)
        norm((ship.x, ship.y), 1) |> round |> Int
    end

    function part₂(moves)
        ship = Day12_State{Float64}(0, 0, 0)
        waypoint = Day12_State{Float64}(10, 1, 0)
        foreach(x -> update₂!(x, ship, waypoint), moves)
        norm((ship.x, ship.y), 1) |> round |> Int
    end

    result₁ = part₁(moves)
    result₂ = part₂(moves)

    # @btime $part₁($moves)
    # @btime $part₂($moves)

    result₁, result₂
end

export day12
