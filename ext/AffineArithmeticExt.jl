module AffineArithmeticExt

import RangeEnclosures
using RangeEnclosures: AffineArithmeticEnclosure, IntervalVector_or_IntervalBox

using IntervalArithmetic: Interval, interval
using IntervalBoxes: IntervalBox

import AffineArithmetic
using AffineArithmetic: Aff  # NOTE: this is an internal function

# univariate
function RangeEnclosures.enclose(f::Function, dom::Interval, ::AffineArithmeticEnclosure)
    x = Aff(dom, 1, 1)
    return interval(f(x))
end

# multivariate
function _enclose(::AffineArithmeticEnclosure, f::Function, dom::IntervalVector_or_IntervalBox, N)
    x = [Aff(dom[i], N, i) for i in 1:N]
    return interval(f(x))
end

function RangeEnclosures.enclose(f::Function, dom::AbstractVector{<:Interval},
                                 aae::AffineArithmeticEnclosure)
    return _enclose(aae, f, dom, length(dom))
end

function RangeEnclosures.enclose(f::Function, dom::IntervalBox{N},
                                 aae::AffineArithmeticEnclosure) where {N}
    return _enclose(aae, f, dom, N)
end

end  # module
