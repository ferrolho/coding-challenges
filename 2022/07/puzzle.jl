function day7_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    input = readlines(filename)

    pwd = "/"

    folders = Dict{String,Int}(pwd => 0)
    files = Dict{String,Int}()

    for line in input
        tokens = split(line)
        if tokens[1] == "\$"
            if tokens[2] == "cd"
                if tokens[3] == ".."
                    i = findprev(==('/'), pwd, length(pwd) - 1)
                    pwd = pwd[1:i]
                elseif tokens[3] == "/"
                    pwd = "/"
                else
                    pwd = string(pwd, tokens[3], "/")
                    folders[pwd] = 0
                end
            end
        else
            size, name = tryparse(Int, tokens[1]), tokens[2]
            if !isnothing(size)
                files[string(pwd, name)] = size
            end
        end
    end

    # calculate the size of each folder
    for folder in keys(folders)
        folders[folder] = sum(files) do (file, size)
            occursin(folder, file) ? size : 0
        end
    end

    folders
end

function day7_part1(folders)
    sum(v for (k, v) in folders if v ≤ 100000)
end

function day7_part2(folders)
    required = folders["/"] - 40000000
    minimum(v for (k, v) in folders if v ≥ required)
end

@testset "day07" begin
    input = day7_parseinput()
    @test day7_part1(input) == 919137
    @test day7_part2(input) == 2877389
end

export day7_parseinput, day7_part1, day7_part2
