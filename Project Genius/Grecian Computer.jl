function get_layers()
    layer_1 = [
         2  5 10  7 16  8  7  8  8  3  4 12
         3  3 14 14 21 21  9  9  4  4  6  6
         8  9 10 11 12 13 14 15  4  5  6  7
        14 11 14 14 11 14 11 14 11 11 14 11
    ]

    layer_2 = [
         1  0  9  0 12  0  6  0 10  0 10  0
         3 26  6  0  2 13  9  0 17 19  3 12
         9 20 12  3  6  0 14 12  3  8  9  0
         7  0  9  0  7 14 11  0  8  0 16  2
    ]

    layer_3 = [
         0  0  0  0  0  0  0  0  0  0  0  0
         5  0 10  0  8  0 22  0 16  0  9  0
        21  6 15  4  9 18 11 26 14  1 12  0
         9 13  9  7 13 21 17  4  5  0  7  8
    ]

    layer_4 = [
         0  0  0  0  0  0  0  0  0  0  0  0
         0  0  0  0  0  0  0  0  0  0  0  0
         4  0  7 15  0  0 14  0  9  0 12  0
         7  3  0  6  0 11 11  6 11  0  6 17
    ]

    layer_5 = [
         0  0  0  0  0  0  0  0  0  0  0  0
         0  0  0  0  0  0  0  0  0  0  0  0
         0  0  0  0  0  0  0  0  0  0  0  0
         3  0  6  0 10  0  7  0 15  0  8  0
    ]

    layer_1, layer_2, layer_3, layer_4, layer_5
end

function calculate!(state, layers...)
    for layer in layers
        nonzeros = findall(!=(0), layer)
        state[nonzeros] = layer[nonzeros]
    end
    state
end

function solve!(state, layer_1, layer_2, layer_3, layer_4, layer_5)
    for _ in 1:12
        for _ in 1:12
            for _ in 1:12
                for _ in 1:12
                    # calculate state and check if it is the solution
                    calculate!(state, layer_1, layer_2, layer_3, layer_4, layer_5)
                    all(==(42), sum(state, dims=1)) && return

                    layer_5 = circshift(layer_5, (0, 1))
                end
                layer_4 = circshift(layer_4, (0, 1))
            end
            layer_3 = circshift(layer_3, (0, 1))
        end
        layer_2 = circshift(layer_2, (0, 1))
    end
end

function solve()
    layers = get_layers()
    state = zeros(4, 12)
    solve!(state, layers...)
    state |> display
    sum(state, dims=1) |> display
end

solve()
