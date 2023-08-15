function day20()
    input = joinpath(@__DIR__, "input.txt")
    blockedIPs = map(eachline(input)) do line
        a, b = parse.(Int, split(line, '-'))
        a:b
    end

    simplified = false
    while !simplified
        activity = false
        for i₁ = 1:length(blockedIPs) - 1
            for i₂ = i₁ + 1:length(blockedIPs)
                r₁ = blockedIPs[i₁]
                r₂ = blockedIPs[i₂]

                r₁_min, r₁_max = extrema(r₁)
                r₂_min, r₂_max = extrema(r₂)

                # If there is an overlap, merge the ranges.
                if any(x -> r₁_min - 1 <= x <= r₁_max + 1, (r₂_min, r₂_max)) ||
                   any(x -> r₂_min - 1 <= x <= r₂_max + 1, (r₁_min, r₁_max))
                    blockedIPs[i₁] = min(r₁_min, r₂_min):max(r₁_max, r₂_max)
                    deleteat!(blockedIPs, i₂)
                    activity = true
                    break
                end
            end
            activity && break
        end
        !activity && (simplified = true)
    end

    isblocked(IP, blockedIPs) = any(x -> IP ∈ x, blockedIPs)

    IPs = 0:typemax(UInt32)
    result₁ = IPs[findfirst(x -> !isblocked(x, blockedIPs), IPs)]
    result₂ = length(IPs) - sum(length, blockedIPs)

    # @assert result₁ == 22887907
    # @assert result₂ == 109

    result₁, result₂
end

export day20
