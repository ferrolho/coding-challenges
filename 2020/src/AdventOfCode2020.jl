module AdventOfCode2020

using BenchmarkTools
using DelimitedFiles
using LinearAlgebra

greet() = println("Hello, Advent of Code 2020!")

include("../01/puzzle.jl")
include("../02/puzzle.jl")
include("../03/puzzle.jl")

end # module
