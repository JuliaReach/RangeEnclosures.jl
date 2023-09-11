using .MultivariatePolynomials

function enclose(p::AbstractPolynomialLike, dom::Interval_or_IntervalVector,
                 solver::AbstractEnclosureAlgorithm=NaturalEnclosure(); kwargs...)
    f(x) = p(x...)
    return _enclose(solver, f, dom; kwargs...)
end

function enclose(p::AbstractPolynomialLike, dom::Interval_or_IntervalVector,
                 solver::SumOfSquaresEnclosure; kwargs...)
    return _enclose(solver, p, dom; kwargs...)
end
