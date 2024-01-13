using .MultivariatePolynomials: AbstractPolynomialLike, variables

function enclose(p::AbstractPolynomialLike, dom::Interval_or_IntervalBox,
                 solver::AbstractEnclosureAlgorithm=NaturalEnclosure(); kwargs...)
    f(x) = p(x...)
    return enclose(f, dom, solver; kwargs...)
end

# ======================================
# Methods using semidefinite programming
# ======================================

function enclose(p::AbstractPolynomialLike, dom::Interval_or_IntervalBox,
                 sose::SumOfSquaresEnclosure; kwargs...)
    require(@__MODULE__, :SumOfSquares; fun_name="enclose")

    return _enclose_sos(sose, p, dom; kwargs...)
end
