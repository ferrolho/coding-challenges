"""
See [Diffie–Hellman key exchange](https://en.wikipedia.org/wiki/Diffie–Hellman_key_exchange).
"""
function day25()
    input = joinpath(@__DIR__, "input.txt")
    pkᶜ, pkᵈ = parse.(Int, readlines(input))

    sn, p = 7, 20201227

    function transform(sn, ls; value=1)
        for _ = 1:ls
            value = value * sn % p
        end
        value
    end

    function findls(sn, pk; value=1)
        ls = 0
        while value != pk
            value = value * sn % p
            ls += 1
        end
        ls
    end

    ekᶜ = transform(pkᵈ, findls(sn, pkᶜ))
    ekᵈ = transform(pkᶜ, findls(sn, pkᵈ))
    @assert ekᶜ == ekᵈ

    ekᶜ
end

export day25
