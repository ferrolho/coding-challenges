module Advent2019

# using Colors
using DelimitedFiles
# using Plots
using SparseArrays

greet() = println("Hello, Advent of Code 2019!")

include("../01/puzzle.jl")
include("../02/puzzle.jl")
include("../03/puzzle.jl")
include("../04/puzzle.jl")
include("../05/puzzle.jl")

export greet

end # module
