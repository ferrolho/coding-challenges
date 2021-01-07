module AdventOfCode2015

using BenchmarkTools
using JSON
using LinearAlgebra
using MD5

greet() = println("Hello, Advent of Code 2015!")

include("../01/puzzle.jl")
include("../02/puzzle.jl")
include("../03/puzzle.jl")
include("../04/puzzle.jl")
include("../05/puzzle.jl")
include("../06/puzzle.jl")
include("../07/puzzle.jl")
include("../08/puzzle.jl")
include("../10/puzzle.jl")
include("../11/puzzle.jl")
include("../12/puzzle.jl")

end # module
