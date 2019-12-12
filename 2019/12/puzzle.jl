mutable struct Day12_Body
    pos::Array{Int}
    vel::Array{Int}
    Day12_Body(pos::Array{Int}) = new(pos, zeros(3))
end

Base.show(io::IO, b::Day12_Body) = print("pos = $(b.pos), vel = $(b.vel)")
update_position(b::Day12_Body) = b.pos += b.vel
total_energy(b::Day12_Body) = sum(abs.(b.pos)) * sum(abs.(b.vel))

function update_velocity(bs::Array{Day12_Body})
    for (b₁, b₂) ∈ subsets(bs, 2), k = 1:3
        if b₁.pos[k] < b₂.pos[k]
            b₁.vel[k] += 1
            b₂.vel[k] -= 1
        elseif b₁.pos[k] > b₂.pos[k]
            b₁.vel[k] -= 1
            b₂.vel[k] += 1
        end
    end
end

function day12(print_iters::Bool = false)
    # Parse input data
    input = split.(readlines("./12/input.txt"), r"<|>|, ", keepempty = false)
    # Spawn moons
    moons = [Day12_Body(map(x->parse(Int, x[3:end]), m)) for m in input]
    # Simulate
    for i = 1:1000
        # Update velocity with gravity
        update_velocity(moons)
        # Update position with velocity
        foreach(m->update_position(m), moons)
        # Print status
        if print_iters
            # (i % 100 == 0) && println(i)
            println("After $(i) steps:")
            foreach(println, moons)
            println()
        end
    end
    sum(total_energy.(moons))
end

export day12
