abstract type AbstractEnclosureAlgorithm end

"""
   NaturalEnclosure <: AbstractEnclosureAlgorithm

Data type to compute the range of `f` over `X` using natural enclosure, that is simply
evaluates `f(X)` using interval arithmetic.
"""
struct NaturalEnclosure <: AbstractEnclosureAlgorithm end

"""
    MooreSkelboeEnclosure{T} <: AbstractEnclosureAlgorithm

Data type to compute the range of `f` over `X` using the Moore-Skelboe algorithm, which
computes rigorously the global minimum and maximum of the function.
See [`IntervalOptimisation.jl`](https://github.com/JuliaIntervals/IntervalOptimisation.jl) for more details.

### Fields

- `structure` -- (default: `HeapedVector`) the way in which vector elements
                 are kept arranged; possible options are `HeapedVector` and `SortedVector`
- `tol`       -- (default `1e-3`) tolerance to which the optima are computed

### Notes

To use this algorithm, you need to import `IntervalOptimisation.jl`
"""
Base.@kwdef struct MooreSkelboeEnclosure{T} <: AbstractEnclosureAlgorithm
    structure::T = HeapedVector
    tol::Float64 = 1e-3
end

"""
    TaylorModelsEnclosure <: AbstractEnclosureAlgorithm

Data type to compute the range of `f` over `X` using Taylor models.
See [`TaylorModels.jl`](https://github.com/JuliaIntervals/TaylorModels.jl) for more details.

### Fields

- `order`     -- (default: `10`) order of the Taylor model used to compute
                 an enclosure of `f` over `dom`
- `normalize` -- (default: `true`) if `true`, normalize the Taylor model
                 on the unit symmetric box around the origin

"""
Base.@kwdef struct TaylorModelsEnclosure <: AbstractEnclosureAlgorithm
    order::Int = 10
    normalize::Bool = true
end


"""
    SumOfSquaresEnclosure{T} <: AbstractEnclosureAlgorithm

Data type to compute the range of `f` over `X` using sum-of-squares optimization.
See [`SumOfSquares.jl`](https://github.com/jump-dev/SumOfSquares.jl) for more details

### Fields
- `backend` -- backend used to solve the optimization problem; a list of available backends
             can be found [here](https://jump.dev/JuMP.jl/stable/installation/#Supported-solvers)
- `order` -- (default `5`), maximum degree of the SDP relaxation

### Notes

To use this solver you need to import `SumOfSquares.jl` and a backend.
Since the optimization problem is solved numerically and not with interval arithmetic, the
result of this algorithm is not rigorous.
"""
Base.@kwdef struct SumOfSquaresEnclosure{T} <: AbstractEnclosureAlgorithm
    backend::T
    order::Int = 5
end
