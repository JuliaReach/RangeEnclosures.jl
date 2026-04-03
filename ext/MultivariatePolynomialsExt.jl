module MultivariatePolynomialsExt

import RangeEnclosures
using RangeEnclosures: AbstractEnclosureAlgorithm, Interval_or_IntervalVector_or_IntervalBox,
                       NaturalEnclosure, enclose

import MultivariatePolynomials
using MultivariatePolynomials: AbstractPolynomialLike

function RangeEnclosures.enclose(p::AbstractPolynomialLike,
                                 dom::Interval_or_IntervalVector_or_IntervalBox,
                                 solver::AbstractEnclosureAlgorithm=NaturalEnclosure(); kwargs...)
    f(x) = p(x...)
    return enclose(f, dom, solver; kwargs...)
end

end  # module
