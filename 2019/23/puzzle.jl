mutable struct Day23_Computer
    net_addr::Int
    inputs::Array{Int}
    outputs::Array{Int}
    memory::Array{Int}
    prgrm_cntr::Int
    rel_base::Int
    idle::Bool
    Day23_Computer(addr, mem) = new(addr, [addr], [], mem, 0, 0, false)
end

function day23()
    memory = [vec(readdlm("./23/input.txt", ',', Int)) ; zeros(Int, 1000)]
    new_computer(net_addr::Int) = Day23_Computer(net_addr, memory |> copy)

    function compute(c::Day23_Computer)
        # Julia is 1-indexed
        pos(x) = x + 1
        get(x) = c.memory[pos(x)]
        set!(x, value) = (c.memory[pos(x)] = value)
        get_digit(number, pos) = number ÷ 10^(pos - 1) % 10

        # Execute Intcode program (one step)
        instruction = get(c.prgrm_cntr)
        opcode = get_digit(instruction, 1)
        mode_1 = get_digit(instruction, 3)
        mode_2 = get_digit(instruction, 4)
        mode_3 = get_digit(instruction, 5)

        # @show opcode mode_1 mode_2 mode_3
        # println("$(instruction) → mode=$(mode_3) mode=$(mode_2) mode=$(mode_1) op=$(opcode)")

        if opcode == 1      # Opcode: sum
            val1 = mode_1 == 1 ? get(c.prgrm_cntr + 1) : mode_1 == 0 ? get(get(c.prgrm_cntr + 1)) : get(c.rel_base + get(c.prgrm_cntr + 1))
            val2 = mode_2 == 1 ? get(c.prgrm_cntr + 2) : mode_2 == 0 ? get(get(c.prgrm_cntr + 2)) : get(c.rel_base + get(c.prgrm_cntr + 2))
            dest = mode_3 == 0 ? get(c.prgrm_cntr + 3) : c.rel_base + get(c.prgrm_cntr + 3)
            set!(dest, val1 + val2)

        elseif opcode == 2  # Opcode: product
            val1 = mode_1 == 1 ? get(c.prgrm_cntr + 1) : mode_1 == 0 ? get(get(c.prgrm_cntr + 1)) : get(c.rel_base + get(c.prgrm_cntr + 1))
            val2 = mode_2 == 1 ? get(c.prgrm_cntr + 2) : mode_2 == 0 ? get(get(c.prgrm_cntr + 2)) : get(c.rel_base + get(c.prgrm_cntr + 2))
            dest = mode_3 == 0 ? get(c.prgrm_cntr + 3) : c.rel_base + get(c.prgrm_cntr + 3)
            set!(dest, val1 * val2)

        elseif opcode == 3  # Opcode: input
            dest = mode_1 == 0 ? get(c.prgrm_cntr + 1) : c.rel_base + get(c.prgrm_cntr + 1)
            # print("[INPUT] ")
            val1 = nothing
            if isempty(c.inputs)
                val1 = -1
                c.idle = true
            else
                val1 = popfirst!(c.inputs)
                c.idle = false
            end
            set!(dest, val1)
            # println(val1)

        elseif opcode == 4  # Opcode: output
            val1 = mode_1 == 1 ? get(c.prgrm_cntr + 1) : mode_1 == 0 ? get(get(c.prgrm_cntr + 1)) : get(c.rel_base + get(c.prgrm_cntr + 1))
            # println("[OUTPUT] $(val1)")
            push!(c.outputs, val1)
            if length(c.outputs) >= 3
                # Package ready to be sent out
                dest, X, Y, c.outputs = c.outputs[1:3]..., c.outputs[4:end]
                (isnothing(result₁) && dest == 255) && (result₁ = Y)
                (dest == 255) ? (nat = [X,Y]) : append!(network[dest].inputs, [X,Y])
            end

        elseif opcode == 5  # Opcode: jump-if-true
            val1 = mode_1 == 1 ? get(c.prgrm_cntr + 1) : mode_1 == 0 ? get(get(c.prgrm_cntr + 1)) : get(c.rel_base + get(c.prgrm_cntr + 1))
            val2 = mode_2 == 1 ? get(c.prgrm_cntr + 2) : mode_2 == 0 ? get(get(c.prgrm_cntr + 2)) : get(c.rel_base + get(c.prgrm_cntr + 2))
            (val1 != 0) && (c.prgrm_cntr = val2; return)

        elseif opcode == 6  # Opcode: jump-if-false
            val1 = mode_1 == 1 ? get(c.prgrm_cntr + 1) : mode_1 == 0 ? get(get(c.prgrm_cntr + 1)) : get(c.rel_base + get(c.prgrm_cntr + 1))
            val2 = mode_2 == 1 ? get(c.prgrm_cntr + 2) : mode_2 == 0 ? get(get(c.prgrm_cntr + 2)) : get(c.rel_base + get(c.prgrm_cntr + 2))
            (val1 == 0) && (c.prgrm_cntr = val2; return)

        elseif opcode == 7  # Opcode: less than
            val1 = mode_1 == 1 ? get(c.prgrm_cntr + 1) : mode_1 == 0 ? get(get(c.prgrm_cntr + 1)) : get(c.rel_base + get(c.prgrm_cntr + 1))
            val2 = mode_2 == 1 ? get(c.prgrm_cntr + 2) : mode_2 == 0 ? get(get(c.prgrm_cntr + 2)) : get(c.rel_base + get(c.prgrm_cntr + 2))
            dest = mode_3 == 0 ? get(c.prgrm_cntr + 3) : c.rel_base + get(c.prgrm_cntr + 3)
            set!(dest, Int(val1 < val2))

        elseif opcode == 8  # Opcode: equals
            val1 = mode_1 == 1 ? get(c.prgrm_cntr + 1) : mode_1 == 0 ? get(get(c.prgrm_cntr + 1)) : get(c.rel_base + get(c.prgrm_cntr + 1))
            val2 = mode_2 == 1 ? get(c.prgrm_cntr + 2) : mode_2 == 0 ? get(get(c.prgrm_cntr + 2)) : get(c.rel_base + get(c.prgrm_cntr + 2))
            dest = mode_3 == 0 ? get(c.prgrm_cntr + 3) : c.rel_base + get(c.prgrm_cntr + 3)
            set!(dest, Int(val1 == val2))

        elseif opcode == 9  # Opcode: relative base offset
            val1 = mode_1 == 1 ? get(c.prgrm_cntr + 1) : mode_1 == 0 ? get(get(c.prgrm_cntr + 1)) : get(c.rel_base + get(c.prgrm_cntr + 1))
            c.rel_base += val1
        end

        # @show c.memory

        # Move to next instruction
        if opcode ∈ [1, 2, 7, 8]
            c.prgrm_cntr += 4
        elseif opcode ∈ [3, 4, 9]
            c.prgrm_cntr += 2
        elseif opcode ∈ [5, 6]
            c.prgrm_cntr += 3
        end
    end

    network = Dict(net_addr => new_computer(net_addr) for net_addr = 0:49)
    nat, last_nat_y = nothing, nothing

    result₁, result₂ = nothing, nothing
    while isnothing(result₁) || isnothing(result₂)
        foreach(compute, values(network))
        if all(c->c.idle, values(network)) && !isnothing(nat)
            # println("NAT sending $(nat) to net_addr=0")

            append!(network[0].inputs, nat)
            cur_nat_y = nat[2]
            nat = nothing

            (cur_nat_y == last_nat_y) && (result₂ = last_nat_y)
            last_nat_y = cur_nat_y
        end
    end

    result₁, result₂
end

export day23
