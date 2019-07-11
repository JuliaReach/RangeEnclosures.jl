#=================================
Methods using Affine Arithmetic
=================================#
using .AffineArithmetic: AFF

"""
    enclose_AffineArithmetic(f::Function, dom::Interval_or_IntervalBox)

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
function enclose_AffineArithmetic(f::Function, dom::Interval_or_IntervalBox)
    _enclose_AffineArithmetic(f, dom)
end

# univariate
function _enclose_AffineArithmetic(f::Function, dom::Interval)
    x = AFF(dom, 1, 1)
    return interval(f(x))
end

# multivariate
function _enclose_AffineArithmetic(f::Function, dom::IntervalBox{N}) where {N}
    x = [AFF(dom[i], N, i) for i in 1:N]
    return interval(f(x...))
end
