# Tutorial

This tutorial will teach you how to use RangeEnclosures. First, we will give a basic overview of the package and its functionalities. Next, we will discuss in more detail how to use the package in different scenarios (1D, higher dimension, using algorithms from external libraries, etc.).

## Setup

Assuming you have [installed Julia](https://julialang.org/downloads/), you can install the package from the Julia REPL with the following lines.

```julia
using Pkg
Pkg.add("RangeEnclosures")
```

Then you can load the package in the standard way.

```@example tutorial
using RangeEnclosures
```

## Overview

RangeEnclosures is used to bound the range of a given function `f`. The main function provided by this package is [`enclose`](@ref), and its basic usage is the following.

```julia
enclose(f, X, algorithm; kwargs...)
```

where

- `f` is the function whose range we want to bound,
- `X` is the domain over which we want to compute the range,
- `algorithm` is the algorithm used to compute the range (which is optional; if not specified, the package will default to using interval arithmetic), and
- `kwargs...` are possible keyword arguments used by the algorithm.

The algorithms can be divided into two families: *direct methods*, which compute the range enclosure over the whole domain, and *iterative methods*, which recursively split the domain into smaller subdomains to get a more accurate estimate. A detailed list of available algorithms can be found [here](lib/types.md).

## Usage Examples

### A one-dimensional example

Suppose we want to compute the range of the function

```math
f(x) = -\sum_{k=1}^5kx\sin\left(\frac{k(x-3)}{3}\right)
```

over the domain ``X = [-10, 10]``.

If we call `enclose` without specifying the algorithm, it will evaluate ``f(X)`` using plain interval arithmetic (this is called *natural enclosure*), as the following example shows.

```@example tutorial
f(x) = -sum(k*x*sin(k*(x-3)/3) for k in 1:5)
X = -10..10
Y = enclose(f, X)
```

Generally, using natural enclosures leads to unpleasantly large overestimates, which is due to the [dependency problem](https://en.wikipedia.org/wiki/Interval_arithmetic#Dependency_problem). To overcome this, you may want to use some other methods in your application. The next example bounds the range using the [`BranchAndBoundEnclosure`](@ref) algorithm.

```@example tutorial
Ybb = enclose(f, X, BranchAndBoundEnclosure())
```

As you can see, the result is much tighter now, while still being rigorous! The results can be visualized using `Plots.jl`.

```@example tutorial
using Plots
plot(IntervalBox(X, Y), label="natural enclosure")
plot!(IntervalBox(X, Ybb), label="branch and bound")
plot!(f, -10, 10, lw=2, c=:black, label="f")
savefig("ex1.png") # hide
```

![](ex1.png)

### Tuning parameters

Some algorithms have parameters that can be tuned. For example, looking at the [`BranchAndBoundEnclosure`](@ref) documentation, we can see that it has two parameters, `tol` and `maxdepth`.
If you want to use different values from the default ones, you can pass the parameters as keyword arguments to the algorithm constructor. For example, you can limit the depth of the search tree to `6` the following way:

```@example tutorial
enclose(f, X, BranchAndBoundEnclosure(; maxdepth=6))
```

Generally, tuning parameters can be a good idea to achieve the desired accuracy-tradeoff in your application.

### Combining different methods

Sometimes there is no strictly "best" algorithm, as one algorithm might give a tighter estimate of the range upper bound and another algorithm might give a tighter estimate on the lower bound. In this case, the results can
be combined by taking the intersection. For example, let us consider the function ``g(x) = x^2 - 2x + 1``, which we want to evaluate over the domain ``X_g = [0, 4]``. Let us first try using plain interval arithmetic

```@example tutorial
g(x) = x^2 - 2*x + 1
Xg = 0..4
enclose(g, Xg, NaturalEnclosure()) # this is equivalent to enclose(g, Xg)
```

Now let us bound the range using [`MeanValueEnclosure`](@ref), which uses the mean-value form of the function.

```@example tutorial
enclose(g, Xg, MeanValueEnclosure())
```

As you can see, there is no clear winner and a better enclosure could be obtained by taking the intersection of the two results. This can be easily done in one command by passing a vector of methods to `enclose`:

```@example tutorial
enclose(g, Xg, [NaturalEnclosure(), MeanValueEnclosure()])
```

### Using algorithms from external libraries

Some of the available algorithms are implemented in external libraries. To keep the start-up time of RangeEnclosures.jl reasonable, routines from external packages
are not imported by default. If you want to use those, you need to also import the required package. For example, suppose you want to bound the previous function using the Moore-Skelboe algorithm. Trying the following will fail:

```julia
enclose(f, X, MooreSkelboeEnclosure())
```

```
ERROR: AssertionError: package 'IntervalOptimisation' not loaded (it is required for executing `enclose`)
...
```

This is because the algorithm is implemented in [`IntervalOptimisation.jl`](https://github.com/juliaintervals/intervaloptimisation.jl) and to use it you need to load it first (note that you need to have it installed before loading it). Let us fix our example.

```@example tutorial
using IntervalOptimisation
enclose(f, X, MooreSkelboeEnclosure())
```

### Bounding multivariate functions

While our previous examples were in one dimension, the techniques generalize to multivariate functions ``\mathbb{R}^n\rightarrow\mathbb{R}``, the only difference is that the domain, instead of being an interval, should be an `IntervalBox`. For example, if we want to bound the function

```math
h(x_1, x_2) = \sin(x_1) - \cos(x_2) - \sin(x_1)\cos(x_1)
```

over the domain ``X_h = [-5, 5] \times [-5, 5]``. This can be done as follows.

```@example tutorial
h(x) = sin(x[1]) - cos(x[2]) - sin(x[1]) * cos(x[1])
Xh = IntervalBox(-5..5, 2)  # this represents the box [-5, 5] × [-5, 5]
Yh = enclose(h, Xh, BranchAndBoundEnclosure())
```

We can visualize the result with the following script.

```@example tutorial
x = y = -5:0.1:5
f(x, y) = h([x, y])
surface(x, y, [sup(Yh) for _ in x, _ in y], α=0.4, legend=:none, size=(500, 500))
surface!(x, y, [inf(Yh) for _ in x, _ in y], α=0.4)
surface!(x, y, f.(x', y), zlims=(-4, 4))
savefig("ex2.png") # hide
```

![](ex2.png)