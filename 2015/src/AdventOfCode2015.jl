module AdventOfCode2015

using BenchmarkTools
using LinearAlgebra
using MD5

greet() = println("Hello, Advent of Code 2015!")

include("../01/puzzle.jl")
include("../02/puzzle.jl")
include("../03/puzzle.jl")
include("../04/puzzle.jl")

end # module
