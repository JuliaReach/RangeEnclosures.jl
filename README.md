# RangeEnclosures.jl

[![Build Status](https://travis-ci.org/JuliaReach/RangeEnclosures.jl.svg?branch=master)](https://travis-ci.org/JuliaReach/RangeEnclosures.jl)
[![Docs latest](https://img.shields.io/badge/docs-latest-blue.svg)](http://juliareach.github.io/RangeEnclosures.jl/latest/)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/JuliaReach/RangeEnclosures.jl/blob/master/LICENSE.md)
[![Code coverage](http://codecov.io/github/JuliaReach/RangeEnclosures.jl/coverage.svg?branch=master)](https://codecov.io/github/JuliaReach/RangeEnclosures.jl?branch=master)
[![Join the chat at https://gitter.im/JuliaReach/Lobby](https://badges.gitter.im/JuliaReach/Lobby.svg)](https://gitter.im/JuliaReach/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A [Julia](http://julialang.org) package to compute range enclosures of
real-valued functions.

## Resources

- [Manual](http://juliareach.github.io/RangeEnclosures.jl/latest/)
- [Contributing](https://juliareach.github.io/RangeEnclosures.jl/latest/about/#Contributing-1)
- [Release notes of tagged versions](https://github.com/JuliaReach/RangeEnclosures.jl/releases)
- [Release notes of the development version](https://github.com/JuliaReach/RangeEnclosures.jl/wiki/Release-log-tracker)

## Installing

This package requires Julia v1.0 or later.
Refer to the [official documentation](https://julialang.org/downloads) on how to
install and run Julia on your system.

Depending on your needs, choose an appropriate command from the following list
and enter it in Julia's REPL.
To activate the `pkg` mode, type `]` (and to leave it, type `<backspace>`).

#### [Install the latest release version](https://julialang.github.io/Pkg.jl/v1/managing-packages/#Adding-registered-packages-1)

```julia
pkg> add RangeEnclosures
```

#### Install the latest development version

```julia
pkg> add RangeEnclosures#master
```

#### [Clone the package for development](https://julialang.github.io/Pkg.jl/v1/managing-packages/#Developing-packages-1)

```julia
pkg> dev RangeEnclosures
```

## Quickstart

An *enclosure* of the [range](https://en.wikipedia.org/wiki/Range_(mathematics)) of a function `f : dom ⊂ R^n -> R` is an interval
that contains the global minimum and maximum of `f` over its domain `dom`. `RangeEnclosures` can be used to find such bounds
using different methods, as in:

```julia
julia> using RangeEnclosures

julia> enclose(x -> -x^3/6 + 5x, 1 .. 4)  # using the default solver
[-5.66667, 19.8334]
```
It is guaranteed that the global minimum (resp. global maximum) of `f(x) = -x^3/6 + 5x` on the interval `[1, 4]` is bigger or equal to `-5.66667` (resp. smaller or equal to `19.8334`). Although interval arithmetic is very fast, the bounds obtained are not necessarily tight. Hence, it is often desired to employ different numerical approaches, available through different *solvers*.

`RangeEnclosures` exports the function `enclose` accepting a real-valued function `f`, either univariate or multivariate, over a hyperrectangular (i.e. box-shaped) domain. Without extra arguments, `enclose` uses the default solver (`IntervalArithmetic`) as in the above computation, although other solvers are available through extra arguments to `enclose`. The available solvers are: `:IntervalArithmetic`, `:IntervalOptimisation`, `:TaylorModels`, `:AffineArithmetic` (optional) and `:SumOfSquares` (only for polynomials).

This is a "meta" package in the sense it defines a unique `enclose` function that
calls one of the available solvers to do the optimization;
see the [documentation](http://juliareach.github.io/RangeEnclosures.jl/latest/)
or the examples below as an illustration of the available solvers. The inputs to `enclose` are standard Julia functions and the domains are intervals
(resp. products of intervals): these are given as `Interval` (resp. `IntervalBox`)
types, both defined in `IntervalArithmetic`.

With the running example, using Taylor models substitution of order 4 gives:

```julia
julia> f(x) = -x^3/6 + 5x

julia> dom = 1 .. 4
[1, 4]

julia> enclose(f, dom, :TaylorModels, order=4)
[4.27083, 12.7084]
```
We can get tight bounds using interval (global) optimization,

```julia
julia> enclose(f, dom, :IntervalOptimisation)
[4.83299, 10.5448]
```
or polynomial optimization (semidefinite programming), by changing the `solver`:
```julia
julia> enclose(f, dom, :SumOfSquares)
[4.83333, 10.541]
```
In the last calculation, the default semidefinite programming (SDP) solver `SDPA` is used,
but you can pass in any other SDP solver accepted by `JuMP`. For instance, if you
have `MosekTools` (and a Mosek license) installed, and want to use the maximum
degree of the relaxation to be `4`, do:

```julia
julia> using MosekTools

julia> enclose(f, dom, :SumOfSquares, order=4, backend=MosekTools.Mosek.Optimizer, QUIET=true)
[4.83333, 10.541]
```
(the optional `QUIET` argument is used to turn off the verbose mode).

Multivariate functions are handled similarly:

```julia
julia> g(x, y) = (x + 2y - 7)^2 + (2x + y - 5)^2;

julia> dom = IntervalBox(-10..10, 2)
[-10, 10] × [-10, 10]

julia> enclose(g, dom, :IntervalArithmetic)
[0, 2594]

julia> enclose(g, dom, :SumOfSquares, order=5, backend=MosekTools.Mosek.Optimizer, QUIET=true)
[9.30098e-07, 2594]
```
The result returned by interval arithmetic substitution in this second example is actually tight.

## Acknowledgements

If you use `RangeEnclosures.jl`, consider acknowledging or citing the Julia package
that implements the specific solver that you are using.

This package was completed during Aadesh Deshmuhk's [Julia Seasons of Contributions
(JSOC)](https://julialang.org/soc/ideas-page) 2019. 
In addition, we are grateful to the following persons for enlightening discussions
during the preparation of this package:

- [Luis Benet](https://github.com/lbenet)
- [Benoît Legat](https://github.com/blegat/)
- [David P. Sanders](https://github.com/dpsanders/)
