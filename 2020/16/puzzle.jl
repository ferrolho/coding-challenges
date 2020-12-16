function day16()
    input = joinpath(@__DIR__, "input.txt")
    a, b, c = split(read(input, String), "\n\n")

    label2ranges = Dict{String,Array{UnitRange{Int},1}}()

    for line in split(a, "\n")
        label, ranges_str = split(line, ": ")
        ranges_temp = split.(split(ranges_str, " or "), "-")
        ranges = [parse(Int, a):parse(Int, b) for (a, b) in ranges_temp]
        label2ranges[label] = ranges
    end

    tickets_strs = split(c, "\n", keepempty=false)[2:end]
    tickets = map(x -> parse.(Int, split(x, ",")), tickets_strs)

    my_ticket_str = split(b, "\n")[2]
    my_ticket = parse.(Int, split(my_ticket_str, ","))

    isvalid(ticket, ranges) = all(x -> any(x .∈ ranges), ticket)

    function part₁(label2ranges, tickets)
        all_values = reduce(hcat, tickets)
        all_ranges = reduce(∪, values(label2ranges))
        invalid_values = filter(x -> !any(x .∈ all_ranges), all_values)
        ticket_scanning_error_rate = sum(invalid_values)
    end

    function part₂(label2ranges, tickets, my_ticket)
        all_ranges = reduce(∪, values(label2ranges))
        valid_tickets = reduce(hcat, filter(x -> isvalid(x, all_ranges), tickets))

        options = map(eachrow(valid_tickets)) do row
            filter(k -> all(x -> isvalid(x, label2ranges[k]), row), keys(label2ranges))
        end

        while any(!isone, length.(options))
            settled = reduce(∪, filter(x -> length(x) == 1, options))
            foreach(options) do option
                length(option) > 1 && foreach(x -> delete!(option, x), settled)
            end
        end

        idxs = findall(x -> contains(only(x), "departure"), options)

        prod(my_ticket[idxs])
    end

    result₁ = part₁(label2ranges, tickets)
    result₂ = part₂(label2ranges, tickets, my_ticket)

    result₁, result₂
end

export day16
