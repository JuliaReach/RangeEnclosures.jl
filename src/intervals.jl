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
function _enclose(::NaturalEnclosure, f::Function, dom::Interval_or_IntervalBox; kwargs...)
    return f(dom...)
end
