#=================================
Methods using Interval Arithmetic
=================================#
using IntervalArithmetic

"""
    enclose_IntervalArithmetic(f::Function, dom::Interval_or_IntervalBox)

Compute a range enclosure using interval arithmetic substitution.

### Input

- `f`   -- function
- `dom` -- hyperrectangular domain, either a unidimensional  `Interval` or
           a multidimensional `IntervalBox`

### Output

An interval representing the range enclosure (minimum and maximum) of `f` over
its domain `dom`.

### Algorithm

The result is obtained by substitution of `dom` on the function `f` and
application of the rules of interval arithmetic.

We refer to the documentation and source code of `IntervalArithmetic` for details.
"""
function enclose_IntervalArithmetic(f::Function, dom::Interval_or_IntervalBox)
    return f(dom...)
end

#===================================
Methods using Interval Optimisation
===================================#
using IntervalOptimisation

"""
    range_and_optimisers(f::Function, dom::Interval_or_IntervalBox;
                         structure=HeapedVector, tol=1e-3)

Return an interval that contains the global minimum (resp. an interval that
contains the global maximum) of a univariate or multivariate function `f`,
as well as a list of boxes containing the minimisers (resp. minimisers).

### Input

- `f`         -- function
- `dom`       -- hyperrectangular domain, either a unidimensional  `Interval` or
                 a multidimensional `IntervalBox`
- `structure` -- (optional, default: `HeapedVector`) the way in which vector elements
                 are kept arranged; possible options are `HeapedVector` and `SortedVector`
- `tol`       -- tolerance to which the optima are computed

### Output

The 4-tuple `(global_min, minimisers, global_max, maximisers)`, where:

- `global_min`: interval that is guaranteed to contain the global minimum of `f`
                over `dom`
- `minimisers`: list of boxes containing the minimisers of `f` over `dom`
- `global_max`: interval that is guaranteed to contain the global maximum of `f`
                over `dom`
- `maximisers`: list of boxes containing the maximisers of `f` over `dom`

### Algorithm

The solver finds the global minimum of the function `f` over the `Interval` or
`IntervalBox` `dom` using the Moore-Skelboe algorithm.

We refer to the documentation and source code of `IntervalOptimisation` for details.
"""
function range_and_optimisers(f::Function, dom::Interval_or_IntervalBox;
                              structure=HeapedVector, tol=1e-3)
    _f = wrap_f(f, dom)
    return _range_and_optimisers(_f, dom, structure, tol)
end

@inline wrap_f(f::Function, dom::Interval) = f

# for multidimensional domains, it is required that f has a single argument
@inline wrap_f(f::Function, dom::IntervalBox) = X -> f(X...)

function _range_and_optimisers(f, dom::Interval_or_IntervalBox, structure, tol)
    global_min, minimisers = minimise(f, dom, structure=structure, tol=tol)
    global_max, maximisers = maximise(f, dom, structure=structure, tol=tol)
    return global_min, minimisers, global_max, maximisers
end

"""
    enclose_IntervalOptimisation(f::Function, dom::Interval_or_IntervalBox;
                                 structure=HeapedVector, tol=1e-3)

Compute a range enclosure using interval optimisation.

### Input

- `f`         -- function
- `dom`       -- hyperrectangular domain, either a unidimensional  `Interval` or
                 a multidimensional `IntervalBox`
- `structure` -- (optional, default: `HeapedVector`) the way in which vector elements
                 are kept arranged; possible options are `HeapedVector` and `SortedVector`
- `tol`       -- tolerance to which the optima are computed

### Output

An interval representing the range enclosure (minimum and maximum) of `f` over
its domain `dom`.

### Algorithm

The solver finds the global minimum of the function `f` over the `Interval` or
`IntervalBox` `dom` using the Moore-Skelboe algorithm. The method actually returns
an *interval* containing the global minimum (resp. an *interval* containing the
global maximum), as well as a list of boxes containing the minimisers
(resp. maximisers); they can be obtained calling [`range_and_optimisers`](@ref).

This function conservatively chooses the infimum (resp. supremum) over each interval.

We refer to the documentation and source code of `IntervalOptimisation` for details
on the implemented methods.
"""
function enclose_IntervalOptimisation(f::Function, dom::Interval_or_IntervalBox;
                                      structure=HeapedVector, tol=1e-3)

    global_min, _, global_max, _ = range_and_optimisers(f, dom,
                                                        structure=structure, tol=tol)

    return Interval(inf(global_min), sup(global_max))
end
