module Advent2019

using DataStructures
using DelimitedFiles
using LinearAlgebra: norm
using Plots
using SparseArrays

greet() = println("Hello, Advent of Code 2019!")

include("../01/puzzle.jl")
include("../02/puzzle.jl")
include("../03/puzzle.jl")
include("../04/puzzle.jl")
include("../05/puzzle.jl")
include("../06/puzzle.jl")
include("../07/puzzle.jl")
include("../08/puzzle.jl")
include("../09/puzzle.jl")
include("../10/puzzle.jl")

export greet

end # module
