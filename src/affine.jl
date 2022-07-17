#=================================
Methods using Affine Arithmetic
=================================#
using .AffineArithmetic: Aff

# univariate
function _enclose(::AffineArithmeticEnclosure, f::Function, dom::Interval)
    x = Aff(dom, 1, 1)
    return interval(f(x))
end

# multivariate
function _enclose(::AffineArithmeticEnclosure, f::Function, dom::IntervalBox{N}) where {N}
    x = [Aff(dom[i], N, i) for i in 1:N]
    return interval(f(x))
end
