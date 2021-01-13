module AdventOfCode2016

using BenchmarkTools
using Combinatorics
using LinearAlgebra
using MD5

greet() = println("Hello, Advent of Code 2016!")

include("../04/puzzle.jl")
include("../05/puzzle.jl")
include("../06/puzzle.jl")
include("../07/puzzle.jl")
include("../08/puzzle.jl")

end # module
