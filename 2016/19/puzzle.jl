"""
Singly-Linked Circular List (SLCL)
"""
mutable struct SLCL
    curr::Int
    list::Array
    num_items::Int

    function SLCL(list)
        slcl = similar(list)
        foreach(enumerate(list)) do (pos, x)
            # Indexing an element gives the element that comes after it
            slcl[x] = list[mod1(pos + 1, length(list))]
        end
        new(1, slcl, length(slcl))
    end
end

function iterate!(slcl::SLCL)
    slcl.curr = slcl.list[slcl.curr]
end

function length(slcl::SLCL)
    slcl.num_items
end

function removenext!(slcl::SLCL)
    # "Stitch" gap from the removal
    slcl.list[slcl.curr] = slcl.list[slcl.list[slcl.curr]]
    slcl.num_items -= 1
    slcl
end

function day19()
    function part₁(elves)
        slcl = SLCL(elves)
        while length(slcl) > 1
            removenext!(slcl)
            iterate!(slcl)
        end
        slcl.curr
    end

    function part₂(elves)
        slcl = SLCL(elves)
        # Move the pointer across the circle
        for _ = 2:length(slcl) ÷ 2
            iterate!(slcl)
        end
        while length(slcl) > 1
            removenext!(slcl)
            iseven(length(slcl)) && iterate!(slcl)
        end
        slcl.curr
    end

    input = joinpath(@__DIR__, "input.txt")
    num_elves = parse(Int, readline(input))
    elves = 1:num_elves

    result₁ = part₁(elves)
    result₂ = part₂(elves)

    # @assert result₁ == 1815603
    # @assert result₂ == 1410630

    result₁, result₂
end

export day19
