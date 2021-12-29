function day12_parseinput()
    input = read(joinpath(@__DIR__, "input.txt"), String)
    split.(split(input), "-") .|> x -> tuple(x...)
end

"""
Return a `Set` of nodes accessible from `node`.
"""
function day12_acessiblefrom(node, connections)
    accessible = Set(String[])
    for (a, b) in connections
        node == a && push!(accessible, b)
        node == b && push!(accessible, a)
    end
    accessible
end

function day12_part1(connections)
    complete_paths = Set(Vector{String}[])
    incomplete_paths = Set([["start"]])

    while incomplete_paths |> !isempty
        path = pop!(incomplete_paths)
        accessible_nodes = day12_acessiblefrom(last(path), connections)
        for node ∈ accessible_nodes
            node == "start" && continue
            islowercase(node[1]) && (node ∈ path) && continue
            new_path = push!(copy(path), node)
            push!(node == "end" ? complete_paths : incomplete_paths, new_path)
        end
    end

    length(complete_paths)
end

function day12_path_already_visits_two_small_caves(path)
    small_caves = filter(x -> islowercase(x[1]), path)
    length(small_caves) - 1 == length(unique(small_caves))
end

function day12_part2(connections)
    complete_paths = Set(Vector{String}[])
    incomplete_paths = Set([(["start"], false)])

    while incomplete_paths |> !isempty
        path, path_already_visits_two_small_caves = pop!(incomplete_paths)
        accessible_nodes = day12_acessiblefrom(last(path), connections)
        for node ∈ accessible_nodes
            node == "start" && continue
            islowercase(node[1]) && (node ∈ path) && path_already_visits_two_small_caves && continue
            new_path = push!(copy(path), node)
            if node == "end"
                push!(complete_paths, new_path)
            else
                push!(incomplete_paths, (new_path, day12_path_already_visits_two_small_caves(new_path)))
            end
        end
    end

    length(complete_paths)
end

@testset "day12" begin
    connections = day12_parseinput()
    @test day12_part1(connections) == 226
    @test day12_part2(connections) == 3509
end

export day12_parseinput, day12_part1, day12_part2
