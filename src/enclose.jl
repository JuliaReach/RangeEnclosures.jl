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
julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1)) # use default solver
[0.0, 2.0]_com_NG

julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), TaylorModelsEnclosure())
[0.812499, 1.09376]_com_NG
```

A vector of solvers can be passed in the `solver` options. Then, the result is
obtained by intersecting the range enclosure of each solver.

```jldoctest enclose_examples
julia> enclose(x -> 1 - x^4 + x^5, interval(0, 1), [TaylorModelsEnclosure(), NaturalEnclosure()])
[0.812499, 1.09376]_trv_NG

```
"""
function enclose(f::Function, dom::Interval_or_IntervalBox; kwargs...)
    return enclose(f, dom, NaturalEnclosure(); kwargs...)
end

function enclose(f::Function, dom::Interval_or_IntervalBox, solvers::Vector; kwargs...)
    return mapreduce(solver -> enclose(f, dom, solver; kwargs...), intersect_interval, solvers)
end

"""
    relative_precision(x::Interval, xref::Interval)

Return the relative precision of an interval with respect to a reference interval.

### Input

- `x`    -- test interval
- `xref` -- reference interval

### Output

Left and right relative precision (in %) computed as
- `rleft = (inf(xref) - inf(x)) / diam(xref) * 100%`
- `rright = (sup(x) - sup(xright)) / diam(xref) * 100%`

### Examples

```jldoctest relative_precision
julia> xref = interval(-1.2, 4.6)
[-1.20001, 4.60001]_com

julia> x = interval(-1.25, 7.45)
[-1.25001, 7.45001]_com

julia> relative_precision(x, xref)
(0.8620689655172422, 49.13793103448277)
```

### Algorithm

This function measures the relative precision of the result in a more informative
way than taking the scalar overestimation because it evaluates the precision of
the lower and the upper bounds separately (cf. [AlthoffGK18; Eq. (20)](@citet)).
"""
function relative_precision(x::Interval, xref::Interval)
    x⁻, x⁺ = inf(x), sup(x)
    xref⁻, xref⁺ = inf(xref), sup(xref)

    Δref = xref⁺ - xref⁻
    @assert Δref != zero(Δref) "the width of the reference interval is $Δref, but " *
                               "it should have a non-zero width"

    rel⁻ = -(x⁻ - xref⁻) / Δref * 100
    rel⁺ = (x⁺ - xref⁺) / Δref * 100
    return rel⁻, rel⁺
end
