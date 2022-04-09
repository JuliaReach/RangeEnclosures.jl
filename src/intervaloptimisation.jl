#===================================
Methods using Interval Optimisation
===================================#
using .IntervalOptimisation

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

    global_min, _ = minimise(X->f(X...), dom, structure=structure, tol=tol)
    global_max, _ = maximise(X->f(X...), dom, structure=structure, tol=tol)

    return Interval(inf(global_min), sup(global_max))
end
