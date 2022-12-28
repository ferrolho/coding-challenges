abstract type Day10_Instruction end
mutable struct Noop <: Day10_Instruction
    overhead::Int
end
mutable struct Addx <: Day10_Instruction
    overhead::Int
    V::Int
end

mutable struct Day10_CPU
    x::Int   # the single register
    ip::Int  # instruction pointer
end

function day10_decode_instruction(line, tokens=split(line))
    tokens[1] == "noop" && return Noop(1)
    tokens[1] == "addx" && return Addx(2, parse(Int, tokens[2]))
end

function day10_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    map(day10_decode_instruction, eachline(filename))
end

function day10_execute!(cpu, instruction, action_fn)
    instruction.overhead -= 1
    if instruction.overhead == 0
        action_fn()  # injected action
        cpu.ip += 1
    end
end

function day10_execute!(cpu, instruction::Noop)
    action_fn() = nothing
    day10_execute!(cpu, instruction, action_fn)
end

function day10_execute!(cpu, instruction::Addx)
    action_fn() = cpu.x += instruction.V
    day10_execute!(cpu, instruction, action_fn)
end

function day10_simulate(instructions, query_cycles; dims=(40, 6))
    cpu = Day10_CPU(1, 1)
    crt = fill(' ', dims)

    signals = []

    for cycle = eachindex(crt)
        # part 1
        if cycle ∈ query_cycles
            signal_strength = cycle * cpu.x
            push!(signals, signal_strength)
        end
        # part 2
        if mod1(cycle, dims[1]) ∈ cpu.x:cpu.x+2
            crt[cycle] = '█'
        end
        day10_execute!(cpu, instructions[cpu.ip])
    end

    signals, crt
end

function day10(input; print_crt=true)
    query_cycles = (20, 60, 100, 140, 180, 220)
    signals, crt = day10_simulate(input, query_cycles)

    crt_str = map(join, eachcol(crt))
    print_crt && println.(crt_str)

    sum(signals), crt_str
end

@testset "day10" begin
    input = day10_parseinput()
    part1, part2 = day10(input, print_crt=false)
    @test part1 == 13920
    @test part2 == [  # EGLHBLFJ
        "████  ██  █    █  █ ███  █    ████   ██ "
        "█    █  █ █    █  █ █  █ █    █       █ "
        "███  █    █    ████ ███  █    ███     █ "
        "█    █ ██ █    █  █ █  █ █    █       █ "
        "█    █  █ █    █  █ █  █ █    █    █  █ "
        "████  ███ ████ █  █ ███  ████ █     ██  "
    ]
end

export day10_parseinput, day10
