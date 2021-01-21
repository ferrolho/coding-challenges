function day17()
    input = joinpath(@__DIR__, "input.txt")
    passcode = readline(input)

    function explore(passcode)
        function bfs(node₀, target)
            char2step = let
                ks = collect("UDLR")
                vs = CartesianIndex.([(0, -1), (0, 1), (-1, 0), (1, 0)])
                Dict(ks .=> vs)
            end

            isopen(door::Char) = 'b' <= door <= 'f'

            paths = Set{String}()

            Node = Tuple{CartesianIndex,String}
            queue = Node[node₀]  # Nodes to be explored.

            while !isempty(queue)
                pos, path = popfirst!(queue)
                if pos == target
                    push!(paths, replace(path, passcode => ""))
                else
                    hash = bytes2hex(md5(path))
                    for (door, c) = zip(first(hash, 4), "UDLR")
                        pos⁺ = pos + char2step[c]
                        if isopen(door) && all(x -> 1 <= x <= 4, pos⁺.I)
                            push!(queue, (pos⁺, path * c))
                        end
                    end
                end
            end

            paths
        end

        node₀ = (CartesianIndex(1, 1), passcode)
        bfs(node₀, CartesianIndex(4, 4))
    end

    paths = explore(passcode)
    minl, maxl = extrema(length, paths)
    result₁ = filter(x -> length(x) == minl, paths) |> first
    result₂ = maxl

    # @assert result₁ == "DDRRULRDRD"
    # @assert result₂ == 536

    result₁, result₂
end

export day17
