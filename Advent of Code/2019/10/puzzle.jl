function day10()
    grid = hcat(collect.(readdlm("./10/input.txt", String))...)
    visible = Dict(x => Set(CartesianIndex[]) for x in findall(==('#'), grid))

    # display(grid)

    # For each asteroid location (...)
    for a1 in keys(visible)
        for a2 in keys(visible)
            # Skip asteroid self-analysis
            a1 == a2 && continue

            scan = a1
            step = (a2 - a1).I .÷ gcd((a2 - a1).I...) |> CartesianIndex

            hit = false
            while !hit
                scan = scan + step
                if grid[scan] == '#'
                    push!(visible[a1], scan)
                    hit = true
                end
            end
        end
    end

    result = maximum((length(v),k) for (k,v) in visible)
    # println("Part 1: Best is $(result[2].I .- 1) with $(result[1]) other asteroids detected.")
    result₁ = result[1]

    # Helper functions
    distance(x, y) = norm(x - y)
    distance(x::CartesianIndex, y::CartesianIndex) = distance([x.I...],[y.I...])
    theta_to(a) = (a-station).I |> x -> mod(atan(x[1],-x[2]), 2π)  # |> rad2deg

    # Part 2
    station = result[2]
    asteroids = filter(x -> x ≠ station, findall(==('#'), grid))
    dd = DefaultDict{Float64,Set{CartesianIndex}}(Set([]))
    for a ∈ asteroids; push!(dd[theta_to(a)], a) end

    vaporized = CartesianIndex[]
    while values(dd) |> !isempty
        for idx ∈ sort(collect(keys(dd)))
            target = minimum((distance(a, station), a) for a in dd[idx])[2]
            # println("Vaporizing $(target)")
            push!(vaporized, target)
            delete!(dd[idx], target)
            isempty(dd[idx]) && delete!(dd, idx)
        end
    end

    # println("The 1st asteroid to be vaporized is at $(vaporized[1].I .- 1).")
    # println("The 2nd asteroid to be vaporized is at $(vaporized[2].I .- 1).")
    # println("The 3rd asteroid to be vaporized is at $(vaporized[3].I .- 1).")
    # println("The 10th asteroid to be vaporized is at $(vaporized[10].I .- 1).")
    # println("The 20th asteroid to be vaporized is at $(vaporized[20].I .- 1).")
    # println("The 50th asteroid to be vaporized is at $(vaporized[50].I .- 1).")
    # println("The 100th asteroid to be vaporized is at $(vaporized[100].I .- 1).")
    # println("The 199th asteroid to be vaporized is at $(vaporized[199].I .- 1).")
    # println("The 200th asteroid to be vaporized is at $(vaporized[200].I .- 1).")
    # println("The 201st asteroid to be vaporized is at $(vaporized[201].I .- 1).")
    # println("The 299th and final asteroid to be vaporized is at $(vaporized[299].I .- 1).")
    # println("The 299th and final asteroid to be vaporized is at $(vaporized[end].I .- 1).")

    v₂₀₀ = vaporized[200].I .- 1
    result₂ = v₂₀₀[1]*100 + v₂₀₀[2]
    # println("Part 2: $(result₂)")

    result₁, result₂
end

export day10
