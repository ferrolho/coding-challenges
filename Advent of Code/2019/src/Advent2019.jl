module Advent2019

using BenchmarkTools
using DataStructures
using DelimitedFiles
using IterTools
using LinearAlgebra: ⋅, norm
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
include("../11/puzzle.jl")
include("../12/puzzle.jl")
include("../13/puzzle.jl")
include("../14/puzzle.jl")
include("../15/puzzle.jl")
include("../16/puzzle.jl")
include("../17/puzzle.jl")
include("../18/puzzle.jl")
include("../19/puzzle.jl")
include("../20/puzzle.jl")
include("../21/puzzle.jl")
include("../22/puzzle.jl")
include("../23/puzzle.jl")
include("../24/puzzle.jl")
include("../25/puzzle.jl")

export greet

end # module
