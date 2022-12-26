Start the Julia REPL from within this folder.

To run all the tests:
```julia
using AdventOfCode2022, ReTest
AdventOfCode2022.runtests()
```

To run a specific day:
```julia
input = day1_parseinput()
day1_part1(input)
```

To benchmark a specific day:
```julia
using BenchmarkTools
@benchmark day1_part1(input) setup=(input = day1_parseinput())
```
