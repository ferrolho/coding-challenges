function day13()
    input = joinpath(@__DIR__, "input.txt")

    function parseinput(input)
        lines = readlines(input)

        timestamp = parse(Int, lines[1])
        periods = map(id -> parse(Int, id), split(lines[2], (',', 'x'), keepempty=false))

        tokens = tryparse.(Int, split(lines[2], ','))
        offsets = range(0, length=length(tokens)) .=> tokens
        offsets = filter!(x -> !isnothing(x[2]), offsets) .|> first

        timestamp, periods, offsets
    end

    function part₁(t, periods)
        due = periods .* cld.(t, periods)
        wait = minimum(due) - t
        id = periods[argmin(due)]
        return id * wait
    end

    function merge(offsets, periods)
        for t = 0:periods[1]:lcm(periods...)
            ts = t .+ offsets
            if ts[2] .% periods[2] == 0
                return ts[1], lcm(periods...)
            end
        end
    end

    function part₂(offsets, periods)
        bus = (0, 1)  # Start with a bus with T=1

        for i = 1:length(periods)
            new_offsets = (bus[1], offsets[i] + bus[1])
            new_periods = (bus[2], periods[i])
            bus = merge(new_offsets, new_periods)
        end

        bus[1]
    end

    timestamp, periods, offsets = parseinput(input)
    result₁ = part₁(timestamp, periods)
    result₂ = part₂(offsets, periods)

    # @btime $part₁($timestamp, $periods)
    # @btime $part₂($offsets, $periods)

    result₁, result₂
end

export day13
