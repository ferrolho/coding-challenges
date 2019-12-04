using DelimitedFiles
using SparseArrays

function day3()
    grid_size = 100_000
    grid_wire_1 = spzeros(grid_size, grid_size)
    grid_wire_2 = spzeros(grid_size, grid_size)
    grids = [grid_wire_1, grid_wire_2]

    wires_path = readdlm("./03/input.txt", ',')

    for i = 1:2  # Trace each wire
        x = grid_size ÷ 2
        y = grid_size ÷ 2
        step_counter = 0
        grid = grids[i]

        for j = 1:size(wires_path, 2)
            # Skip empty strings
            isempty(wires_path[i, j]) && continue

            # Parse instruction
            direction = wires_path[i, j][1]
            amount = parse(Int, wires_path[i, j][2:end])

            # Not ideal, but keeps track of steps
            for k = 1:amount
                if direction == 'D'
                    x += 1
                elseif direction == 'U'
                    x -= 1
                elseif direction == 'R'
                    y += 1
                elseif direction == 'L'
                    y -= 1
                end

                step_counter += 1
                grid[x, y] = step_counter
            end
        end
    end

    # Find wire intersections:
    # Since grids start full of zeros, the nonzeros of the
    # element-wise product will flag the wire intersections
    intersections = map(x -> collect(x.I), findall(x -> x > 0, grid_wire_1 .* grid_wire_2))

    distances = map(x -> sum(abs.(x - [grid_size ÷ 2, grid_size ÷ 2])), intersections)
    result_1 = minimum(distances)

    combined_steps = map(x -> grid_wire_1[x...] + grid_wire_2[x...], intersections)
    result_2 = minimum(Int, combined_steps)

    result_1, result_2
end

export day3
