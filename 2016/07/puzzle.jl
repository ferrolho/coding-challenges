function day7()
    input = joinpath(@__DIR__, "input.txt")
    ips = readlines(input)

    function supportsTLS(ip)
        a = eachmatch(r"(\w)(\w)\2\1", ip)
        b = eachmatch(r"(\w)(\w)\2\1\w*\]", ip)
        cond₁ =  any(x -> !=(x.captures...), a)
        cond₂ = !any(x -> !=(x.captures...), b)
        cond₁ & cond₂
    end

    function supportsSSL(ip)
        ip = ip * "["
        aba = eachmatch(r"(\w)(\w)\1\w*\[", ip, overlap=true)
        bab = eachmatch(r"(\w)(\w)\1\w*\]", ip, overlap=true)
        for m₁ ∈ aba
            c₁₁, c₁₂ = m₁.captures
            c₁₁ == c₁₂ && continue
            for m₂ ∈ bab
                c₂₁, c₂₂ = m₂.captures
                c₁₁ == c₂₂ && c₁₂ == c₂₁ && return true
            end
        end
        false
    end

    result₁ = count(supportsTLS, ips)
    result₂ = count(supportsSSL, ips)

    # @assert result₁ == 118
    # @assert result₂ == 260

    result₁, result₂
end

export day7
