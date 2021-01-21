function day14()
    function gethash(hashes, salt, i, stretch=false)
        if haskey(hashes, i)
            hashes[i]
        else
            hash = bytes2hex(md5(salt * string(i)))
            if stretch
                for _ = 1:2016
                    hash = bytes2hex(md5(hash))
                end
            end
            hashes[i] = hash
        end
    end

    function isvalid(hashes, salt, i, stretch=false)
        hash = gethash(hashes, salt, i, stretch)
        ms = eachmatch(r"(.)\1{2,}", hash)
        if !isempty(ms)
            c = only(first(ms).captures)
            for id = range(i + 1, length=1000)
                hash = gethash(hashes, salt, id, stretch)
                m = eachmatch(Regex("$(c){5,}"), hash)
                !isempty(m) && return true
            end
        end
        return false
    end

    function solve(salt; stretch=false)
        new_keys = Set{Int}()
        hashes = Dict{Int,String}()
        for i = Iterators.countfrom(0)
            isvalid(hashes, salt, i, stretch) && push!(new_keys, i)
            length(new_keys) == 64 && break
        end
        maximum(new_keys)
    end

    input = joinpath(@__DIR__, "input.txt")
    salt = readline(input)

    result₁ = solve(salt, stretch=false)
    result₂ = solve(salt, stretch=true)

    # @assert result₁ == 15035
    # @assert result₂ == 19968

    result₁, result₂
end

export day14
