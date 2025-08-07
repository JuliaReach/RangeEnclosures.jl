"""
    AbstractEnclosureAlgorithm

Abstract type for range enclosure algorithms.
"""
abstract type AbstractEnclosureAlgorithm end

"""
    AbstractDirectRangeAlgorithm <: AbstractEnclosureAlgorithm

Abstract type for range enclosure algorithms that directly evaluate the functions over a
given domain.
"""
abstract type AbstractDirectRangeAlgorithm <: AbstractEnclosureAlgorithm end

"""
    AbstractIterativeRangeAlgorithm <: AbstractEnclosureAlgorithm

Abstract type for algorithms that iteratively bound the range of a function over a given
domain.
"""
abstract type AbstractIterativeRangeAlgorithm <: AbstractEnclosureAlgorithm end

"""
   NaturalEnclosure <: AbstractDirectRangeAlgorithm

Data type to bound the range of `f` over `X` using natural enclosure, i.e., to
evaluate `f(X)` with interval arithmetic.

### Examples

```jldoctest
julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), NaturalEnclosure())
[0, 2]
```
"""
struct NaturalEnclosure <: AbstractDirectRangeAlgorithm end

"""
    MeanValueEnclosure

Data type to bound the range of `f` over `X` using the mean value form, that is the range
is bounded by the expression ``f(Xc) + f'(X) * (X - Xc)``, where `Xc` is the midpoint of `X`
and `f'` is the derivative of `f` (gradient in the multivariate case).
"""
struct MeanValueEnclosure <: AbstractDirectRangeAlgorithm end

"""
    AffineArithmeticEnclosure <: AbstractDirectRangeAlgorithm

Data type to bound the range of `f` over `X` using affine arithmetic.
See [`AffineArithmetic.jl`](https://github.com/JuliaIntervals/AffineArithmetic.jl) for more details.

### Notes

To use this algorithm, you need to load `AffineArithmetic.jl`. Note also that `AffineArithmetic.jl`
currently supports only arithmetic operations.

### Examples

```jldoctest
julia> using AffineArithmetic

julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), AffineArithmeticEnclosure())
[0.0625, 2]
```
"""
struct AffineArithmeticEnclosure <: AbstractDirectRangeAlgorithm end

_default_vector_MSE = nothing

"""
    MooreSkelboeEnclosure{T} <: AbstractIterativeRangeAlgorithm

Data type to bound the range of `f` over `X` using the Moore-Skelboe algorithm, which
rigorously computes the global minimum and maximum of the function.
See [`IntervalOptimisation.jl`](https://github.com/JuliaIntervals/IntervalOptimisation.jl) for more details.

### Fields

- `structure` -- (default: `HeapedVector`) the way in which vector elements
                 are kept arranged; possible options are `HeapedVector` and `SortedVector`
- `tol`       -- (default `1e-3`) tolerance to which the optima are computed

### Notes

To use this algorithm, you need to load `IntervalOptimisation.jl`.

### Examples

```jldoctest
julia> using IntervalOptimisation

julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), MooreSkelboeEnclosure()) # default parameters
[0.916034, 1.00213]

julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), MooreSkelboeEnclosure(; tol=1e-2))
[0.900812, 1.0326]
```
"""
Base.@kwdef struct MooreSkelboeEnclosure{T} <: AbstractIterativeRangeAlgorithm
    structure::T = _default_vector_MSE
    tol::Float64 = 1e-3
end

"""
    TaylorModelsEnclosure <: AbstractDirectRangeAlgorithm

Data type to bound the range of `f` over `X` using Taylor models.
See [`TaylorModels.jl`](https://github.com/JuliaIntervals/TaylorModels.jl) for more details.

### Fields

- `order`     -- (default: `10`) order of the Taylor model used to compute
                 an enclosure of `f` over `dom`
- `normalize` -- (default: `true`) if `true`, normalize the Taylor model
                 on the unit symmetric box around the origin

### Notes

To use this solver, you need to load `TaylorModels.jl` and a backend.

### Examples

```jldoctest
julia> using TaylorModels

julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), TaylorModelsEnclosure()) # default parameters
[0.8125, 1.09375]

julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), TaylorModelsEnclosure(; order=4))
[0.78125, 1.125]
```
"""
Base.@kwdef struct TaylorModelsEnclosure <: AbstractDirectRangeAlgorithm
    order::Int = 10
    normalize::Bool = true
end

"""
    SumOfSquaresEnclosure{T} <: AbstractIterativeRangeAlgorithm

Data type to bound the range of `f` over `X` using sum-of-squares optimization.
See [`SumOfSquares.jl`](https://github.com/jump-dev/SumOfSquares.jl) for more details

### Fields

- `backend` -- backend used to solve the optimization problem; a list of available backends
             can be found [here](https://jump.dev/JuMP.jl/stable/installation/#Supported-solvers)
- `order` -- (default `5`), maximum degree of the SDP relaxation

### Notes

To use this solver, you need to load `SumOfSquares.jl` and a backend.

Since the optimization problem is solved numerically and not with interval arithmetic, the
result of this algorithm is not rigorous.

### Examples

```jldoctest
julia> using SumOfSquares, SDPA, DynamicPolynomials

julia> backend = SDPA.Optimizer;

julia> @polyvar x;

julia> enclose(-x^3/6 + 5x, interval(1, 4), SumOfSquaresEnclosure(; backend=backend)) # default parameters
[4.83333, 10.541]

julia> enclose(-x^3/6 + 5x, interval(1, 4), SumOfSquaresEnclosure(; backend=backend, order=6))
[4.83333, 10.541]
```
"""
Base.@kwdef struct SumOfSquaresEnclosure{T} <: AbstractIterativeRangeAlgorithm
    backend::T
    order::Int = 5
end

"""
    BranchAndBoundEnclosure <: AbstractIterativeRangeAlgorithm

Data type to bound the range of `f` over `X` using the branch and bound algorithm.

### Fields

- `maxdepth` (default `10`): maximum depth of the search tree
- `tol` (default `1e-3`): tolerance to compute the range of the function

### Algorithm

The algorithm evaluates a function `f` over an interval `X`. If the maximum depth is reached or the
width of `f(X)` is below the tolerance, the algorithm returns the computed range; otherwise it bisects
the interval/interval box.

The algorithm also looks at the sign of the derivative / gradient to see if the range can be
computed directly. By default, the derivative / gradient is computed using `ForwardDiff.jl`,
but a custom value can be passed via the `df` keyword argument to [`enclose`](@ref).
Pass `df = nothing` to avoid computing any derivatives.

### Examples

```jldoctest
julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), BranchAndBoundEnclosure()) # default parameters
[0.913927, 1.00003]

julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), BranchAndBoundEnclosure(tol=1e-2, maxdepth=7); df=(x -> -4x^3 + 5x^4))
[0.881639, 1.00091]
```
"""
Base.@kwdef struct BranchAndBoundEnclosure <: AbstractIterativeRangeAlgorithm
    maxdepth = 10
    tol = 1e-3
end
