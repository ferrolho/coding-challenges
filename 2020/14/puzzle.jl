function day14()
    input = joinpath(@__DIR__, "input.txt")

    function ramen(address, mask_or, mask_Xs)
        address = address | mask_or
        address_b = last(bitstring(address), 36) |> collect

        addresses = [address_b]

        for i ∈ mask_Xs
            new_addresses = []
            for a ∈ addresses
                a[i] = '0'; push!(new_addresses, copy(a))
                a[i] = '1'; push!(new_addresses, copy(a))
            end
            addresses = new_addresses
        end

        parse.(Int, String.(addresses), base=2)
    end

    memory₁ = Dict{Int,Int}()
    memory₂ = Dict{Int,Int}()

    mask_Xs = nothing

    mask_or = 0
    mask_and = 0

    for line ∈ eachline(input)

        if first(line, 3) == "mem"
            address, value = parse.(Int, split(line[5:end], "] = "))

            # Part 1
            memory₁[address] = (value | mask_or) & mask_and

            # Part 2
            addresses = ramen(address, mask_or, mask_Xs)
            foreach(a -> memory₂[a] = value, addresses)

        elseif first(line, 4) == "mask"
            mask_str = line[8:end]

            mask_1s = findall("1", mask_str) .|> only
            mask_0s = findall("0", mask_str) .|> only
            mask_Xs = findall("X", mask_str) .|> only

            mask_or = fill('0', 36)
            mask_and = fill('1', 36)

            mask_or[mask_1s] .= '1'
            mask_and[mask_0s] .= '0'

            mask_or = parse(Int, String(mask_or), base=2)
            mask_and = parse(Int, String(mask_and), base=2)

        else
            @error "Unknown instruction" line

        end
    end

    result₁ = sum(values(memory₁))
    result₂ = sum(values(memory₂))

    # @assert result₁ == 8471403462063
    # @assert result₂ == 2667858637669

    result₁, result₂
end

export day14
