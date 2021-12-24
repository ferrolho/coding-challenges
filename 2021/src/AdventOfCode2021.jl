module AdventOfCode2021

using DelimitedFiles
using InlineTest
using IterTools
using StaticArrays

greet() = println("Hello, Advent of Code 2021!")

binary_string_to_decimal(x) = parse(Int, x, base=2)

include("../01/puzzle.jl")
include("../02/puzzle.jl")
include("../03/puzzle.jl")
include("../04/puzzle.jl")

end # module
