mutable struct Day12_Body
    pos::Array{Int}
    vel::Array{Int}
    Day12_Body(pos::Array{Int}) = new(pos, zeros(3))
end

Base.show(io::IO, b::Day12_Body) = print("pos = $(b.pos), vel = $(b.vel)")
update_position(b::Day12_Body) = b.pos += b.vel
total_energy(b::Day12_Body) = sum(abs.(b.pos)) * sum(abs.(b.vel))
state(b::Day12_Body, k::Int) = [b.pos[k], b.vel[k]]

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

    result₁ = 0
    result₂ = 0
    ssx = Set(Array{Int}[])
    ssy = Set(Array{Int}[])
    ssz = Set(Array{Int}[])

    # Simulate
    for i = 1:500_000
        # Update system
        update_velocity(moons)
        update_position.(moons)

        # Store result of part 1
        if i == 1000; result₁ = sum(total_energy.(moons)) end

        # Print status
        if print_iters
            # (i % 100 == 0) && println(i)
            println("After $(i) steps:")
            foreach(println, moons)
            println()
        end

        # State of each dimension
        ss = [vcat(state.(moons, k)...) for k = 1:3]
        # Check if periods of all moons are already known
        if ss[1] in ssx && ss[2] in ssy && ss[3] in ssz
            # @show i length(ssx) length(ssy) length(ssz)
            result₂ = lcm(length.([ssx, ssy, ssz]))
            break
        end
        # Save the state of each dimension
        for (k, s) in enumerate([ssx, ssy, ssz]) push!(s, ss[k]) end
    end

    result₁, result₂
end

export day12
