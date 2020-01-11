# RangeEnclosures.jl

A [Julia](http://julialang.org) package to compute range enclosures of
real-valued functions.

## Features

- Computation of lower and upper bounds of real-valued functions, either
  univariate or multivariate, over hyperrectangular (i.e. box shaped) domains.
- The following solvers are available:
  - `IntervalArithmetic` from [IntervalArithmetic.jl](https://github.com/JuliaIntervals/IntervalArithmetic.jl/)
  - `IntervalOptimisation` from [IntervalOptimisation.jl](https://github.com/JuliaIntervals/IntervalOptimisation.jl)
  - `TaylorModels` from [TaylorModels.jl/](https://github.com/JuliaIntervals/TaylorModels.jl/)
  - `SumOfSquares` from [SumOfSquares.jl](https://github.com/JuliaOpt/SumOfSquares.jl)
- The following optional solvers are available:
  - `AffineArithmetic` from [AffineArithmetic.jl](https://github.com/JuliaIntervals/AffineArithmetic.jl)

## Quickstart

The package exports one single function, `enclose`, which receives a Julia function,
a domain, and (optionally) a solver and additional options passed to the solver.
See the [README.md](https://github.com/JuliaReach/RangeEnclosures.jl/blob/master/README.md#quickstart)
file for the basic usage, or consult the source code docstrings, either in the REPL or in the
[github repository source code](https://github.com/JuliaReach/RangeEnclosures.jl/tree/master/src)

## Library Outline

```@contents
Pages = [
    "lib/types.md",
    "lib/methods.md"
]
Depth = 2
```
