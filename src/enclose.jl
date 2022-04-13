"""
    enclose(f, dom[, solver=NaturalEnclosure()]; kwargs...)

Return a range enclosure of a univariate or multivariate function on the given
domain.

### Input

- `f`      -- function or `AbstractPolynomialLike` object
- `dom`    -- hyperrectangular domain, either a unidimensional  `Interval` or
              a multidimensional `IntervalBox`
- `solver` -- (optional, default: `NaturalEnclosure()`) choose one among the
              available solvers; you can get a list of available solvers with
              `subtypes(AbstractEnclosureAlgorithm)`
- `kwargs` -- optional keyword arguments passed to the solver; for available
              options see the documentation of each solver

### Output

An interval enclosure of the range of `f` over `dom`.

### Examples

```jldoctest enclose_examples
julia> enclose(x -> 1 - x^4 + x^5, 0..1) # use default solver
[0, 2]

julia> enclose(x -> 1 - x^4 + x^5, 0..1, TaylorModelsEnclosure())
[0.8125, 1.09375]
```

A vector of solvers can be passed in the `solver` options. Then, the result is
obtained by intersecting the range enclosure of each solver.

```jldoctest enclose_examples
julia> enclose(x -> 1 - x^4 + x^5, 0..1, [TaylorModelsEnclosure(), NaturalEnclosure()])
[0.8125, 1.09375]

```
"""
function enclose(f::Function, dom::Interval_or_IntervalBox,
                 solver::AbstractEnclosureAlgorithm=NaturalEnclosure(); kwargs...)
    return _enclose(solver, f, dom; kwargs...)
end

function enclose(f::Function, dom::Interval_or_IntervalBox, solver::Symbol; kwargs...)

    𝑂 = Dict(kwargs)

    if solver == :BranchandBound
        tol =  :tol ∈ keys(𝑂) ? 𝑂[:tol] : 0.6
        order = :order ∈ keys(𝑂) ? 𝑂[:order] : 10
        #solver
        R = enclose_BranchandBound(f, dom, order=order, tol=tol)
    else
        error("algorithm $algorithm unknown")
    end

    return R
end

function enclose(p::AbstractPolynomialLike, dom::Interval_or_IntervalBox,
                 solver::AbstractEnclosureAlgorithm=NaturalEnclosure(); kwargs...)
    f(x...) = p(variables(p) => x)
    return _enclose(solver, f, dom; kwargs...)
end

function enclose(f::Function, dom::Interval_or_IntervalBox,
                 method::Vector; kwargs...)
   return mapreduce(ξ -> _enclose(ξ, f, dom; kwargs...), ∩, method)
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
