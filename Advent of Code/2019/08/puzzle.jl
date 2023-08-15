function day8()
    # Read and store input as ::Array{Char}
    data = collect(first(readdlm("./08/input.txt", String)))

    width, height = 25, 6
    num_layers = length(data) ÷ (width * height)

    image = parse.(Int, reshape(data, (width,height,num_layers)))
    image = permutedims(image, [2,1,3])  # Transpose each layer; Julia is column-major

    layerₖ = argmin(count.(iszero, eachslice(image, dims=3)))
    n₁ = count(x -> x == 1, image[:,:,layerₖ])
    n₂ = count(x -> x == 2, image[:,:,layerₖ])
    result₁ = n₁ * n₂

    # Helper function
    rendering_complete(img) = count(x -> x == 2, img) == 0

    render = fill(2, (height,width))
    for layer in eachslice(image, dims=3)
        # Overwrite transparent pixels
        indices = findall(x -> x == 2, render)
        render[indices] = layer[indices]
        # _If_ render has completed _then_ break the loop
        rendering_complete(render) && break
    end
    result₂ = plot(Gray.(render), aspect_ratio=1, axis=nothing, bg=:black)

    result₁, result₂
end

export day8
