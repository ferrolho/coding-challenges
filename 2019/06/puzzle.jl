function day6()
    # Universal Orbit Map (UOM)
    uom_raw = vec(readdlm("./06/input.txt", String))
    uom = map(x -> tuple(split(x, ')')...), uom_raw)
    # display(uom)

    # Set of objects in the Universe
    objects = Set(vec(readdlm("./06/input.txt", ')', String)))
    delete!(objects, "COM")
    # display(objects)

    # Helper functions
    orbits_around(a, b) = (b, a) ∈ uom
    atractor_of(a) = first([x for x ∈ uom if x[2] == a])[1]
    distance_to_com(a) = orbits_around(a, "COM") ? 1 : 1 + distance_to_com(atractor_of(a))
    path_to_com(a) = orbits_around(a, "COM") ? [a, "COM"] : [a ; path_to_com(atractor_of(a))]

    result_1 = sum([distance_to_com(x) for x ∈ objects])

    A = Set(path_to_com(atractor_of("SAN")))
    B = Set(path_to_com(atractor_of("YOU")))
    result_2 = length(setdiff(A, B) ∪ setdiff(B, A))

    result_1, result_2
end

export day6
