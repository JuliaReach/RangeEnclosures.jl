"""
    enclose(f::Function, dom::Interval_or_IntervalBox,
            solver::Symbol=:IntervalArithmetic; [kwargs]...)

Return a range enclosure of a univariate or multivariate function on the given
domain.

### Input

- `f`      -- function
- `dom`    -- hyperrectangular domain, either a unidimensional  `Interval` or
              a multidimensional `IntervalBox`
- `solver` -- (optional, default: `IntervalArithmetic`) choose one among the
              available solvers; see `RangeEnclosures.available_solvers` for the
              full list
- `kwargs` -- optional keyword arguments passed to the solver; for available
              options see the documentation of each solver

### Output

An interval representing the range enclosure (minimum and maximum) of `f` over
its domain `dom`.

### Examples

```jldoctest enclose_examples
julia> using RangeEnclosures, IntervalOptimisation

julia> enclose(x -> 1 - x^4 + x^5, 0..1) # use default solver
[0, 2]

julia> enclose(x -> 1 - x^4 + x^5, 0..1, :IntervalArithmetic)
[0, 2]

julia> enclose(x -> 1 - x^4 + x^5, 0..1, :TaylorModels, order=4)
[0.78125, 1.125]

julia> enclose(x -> 1 - x^4 + x^5, 0..1, :TaylorModels, order=10)
[0.8125, 1.09375]

julia> enclose(x -> 1 - x^4 + x^5, 0..1, :IntervalOptimisation)
[0.916034, 1.00213]
```
You can also try other solvers such as `SumOfSquares` and `AffineArithmetic`.

A vector of solvers can be passed in the `solver` options. Then, the result is
obtained by intersecting the range enclosure of each solver.
In the previous example,

```jldoctest enclose_examples
julia> using RangeEnclosures

julia> enclose(x -> 1 - x^4 + x^5, 0..1, [:TaylorModels, :IntervalArithmetic])
[0.8125, 1.09375]
```
"""
function enclose(f::Function, dom::Interval_or_IntervalBox,
                 solver::Symbol=:IntervalArithmetic; kwargs...)

    𝑂 = Dict(kwargs)
    numvars = length(dom)

    if solver == :IntervalArithmetic
        # solver
        R = enclose_IntervalArithmetic(f, dom)

    elseif solver == :BranchandBound
        tol =  :tol ∈ keys(𝑂) ? 𝑂[:tol] : 0.6
        order = :order ∈ keys(𝑂) ? 𝑂[:order] : 10
        #solver
        R = enclose_BranchandBound(f, dom, order=order, tol=tol)

    elseif solver == :IntervalOptimisation
        # unpack options or set defaults
        structure =  :structure ∈ keys(𝑂) ? 𝑂[:structure] : HeapedVector
        tol =  :tol ∈ keys(𝑂) ? 𝑂[:tol] : 1e-3

        # solver
        R = enclose_IntervalOptimisation(f, dom, structure=structure, tol=tol)

    elseif solver == :TaylorModels
        # unpack options or set defaults
        normalize =  :normalize ∈ keys(𝑂) ? 𝑂[:normalize] : true
        order = :order ∈ keys(𝑂) ? 𝑂[:order] : 10

        # solver
        R = enclose_TaylorModels(f, dom; order=order, normalize=normalize)

    elseif solver == :SumOfSquares
        # unpack options or set defaults
        if :order ∈ keys(𝑂)
            order = 𝑂[:order]
            pop!(𝑂, :order)
        else
            order = 5
        end

        if :backend ∈ keys(𝑂)
            backend = 𝑂[:backend]
            pop!(𝑂, :backend)
        else
            throw(ArgumentError("No SDP backend provided"))
        end

        R = enclose_SumOfSquares(f, dom, backend; order=order, 𝑂...)

    elseif solver == :AffineArithmetic
        # requires affine arithmetic to be loaded
        @assert isdefined(@__MODULE__, :AffineArithmetic) "package `AffineArithmetic` " *
        "not loaded but it is required for executing `enclose`"

        # solver
        R = enclose_AffineArithmetic(f, dom)

    else
        error("algorithm $algorithm unknown")
    end

    return R
end

function enclose(p::AbstractPolynomialLike, dom::Interval_or_IntervalBox,
                 solver=:IntervalArithmetic; kwargs...)
    f(x...) = p(variables(p) => x)
    return enclose(f, dom, solver; kwargs...)
end

function enclose(f::Function, dom::Interval_or_IntervalBox,
                 method::Vector{Symbol}; kwargs...)
   return mapreduce(ξ -> enclose(f, dom, ξ, kwargs...), ∩, method)
end

"""
    relative_precision(x::Interval{N}, xref::Interval{N}) where {N}

Return the relative precision of an interval representing a range enclosure
given a reference interval.

### Input

- `x`    -- test interval
- `xref` -- reference interval

### Output

An interval containing the left (resp. right) percentages that describe the
relative precision of `x` with respect to the reference interval `xref`.

### Examples

Suppose that the reference interval is ``[-1.2, 4.6]``, and let ``[-1.25, 7.45]``
be the overapproximation of the reference interval obtained with some global
optimisation method that returns a range enclosure.
The relative precision is then:

```jldoctest relative_precision
julia> using RangeEnclosures: relative_precision

julia> xref = Interval(-1.2, 4.6)
[-1.2, 4.6]

julia> x = Interval(-1.25, 7.45)
[-1.25, 7.45001]

julia> relative_precision(x, xref)
[0.862068, 49.138]
```
Notice how the percentage of relative error of the maximum is big, close to
``50%``, while the approximation of the minimum is much smaller, close to ``1%``
of the reference value.

### Algorithm

This function measures the relative precision of the result in a more informative
way than taking the scalar overestimation because it evaluates the precision of
the lower and the upper range bounds separately (cf. Eq. (20) in [1]).

[1] Althoff, Matthias, Dmitry Grebenyuk, and Niklas Kochdumper.
   *Implementation of Taylor models in CORA 2018.*
   Proc. of the 5th International Workshop on Applied Verification for
   Continuous and Hybrid Systems. 2018.

### Notes

It is assumed that the test, or paragon interval, is an overapproximation of the
reference interval; otherwise the left or right percentages will be negative.
"""
function relative_precision(x::Interval{N}, xref::Interval{N}) where {N}
    x⁻, x⁺ = inf(x), sup(x)
    xref⁻, xref⁺ = inf(xref), sup(xref)

    Δref = xref⁺ - xref⁻
    @assert Δref != zero(N) "the width of the reference interval is $Δref, but " *
    "it should have a non-zero width"

    rel⁻ = -(x⁻ - xref⁻) / Δref
    rel⁺ = (x⁺ - xref⁺) / Δref
    return 100 * Interval(rel⁻, rel⁺)
end
