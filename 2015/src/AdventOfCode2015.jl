module AdventOfCode2015

using BenchmarkTools
using LinearAlgebra

greet() = println("Hello, Advent of Code 2015!")

include("../01/puzzle.jl")
include("../02/puzzle.jl")
include("../03/puzzle.jl")

end # module
