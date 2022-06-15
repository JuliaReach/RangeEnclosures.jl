using .MultivariatePolynomials

function enclose(p::AbstractPolynomialLike, dom::Interval_or_IntervalBox,
                 solver::AbstractEnclosureAlgorithm=NaturalEnclosure(); kwargs...)
    f(x...) = p(variables(p) => x)
    return _enclose(solver, f, dom; kwargs...)
end

function enclose(p::AbstractPolynomialLike, dom::Interval_or_IntervalBox,
                 solver::SumOfSquaresEnclosure; kwargs...)
    return _enclose(solver, p, dom; kwargs...)
end
