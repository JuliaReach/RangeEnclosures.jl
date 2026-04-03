module SumOfSquaresExt

import RangeEnclosures
using RangeEnclosures: Interval_or_IntervalVector_or_IntervalBox, SumOfSquaresEnclosure

using IntervalArithmetic: inf, interval, sup

import MultivariatePolynomials
using MultivariatePolynomials: AbstractPolynomialLike, variables

import SumOfSquares
using SumOfSquares: SOSModel, @set, @variable, @constraint, @objective, optimize!, objective_value
import SumOfSquares: SemialgebraicSets  # `@set` assumes that `SemialgebraicSets` is defined

function RangeEnclosures.enclose(p::AbstractPolynomialLike,
                                 dom::Interval_or_IntervalVector_or_IntervalBox,
                                 sose::SumOfSquaresEnclosure; kwargs...)
    x = variables(p)

    B = reduce(intersect, @set inf(domi) <= xi && xi <= sup(domi) for (xi, domi) in zip(x, dom))

    # ============
    # Upper bound
    # ============
    model = SOSModel(sose.backend, kwargs...)
    @variable(model, γ) # JuMP decision variable
    @constraint(model, p <= γ, domain = B, maxdegree = sose.order)
    @objective(model, Min, γ)
    optimize!(model)
    upper_bound = objective_value(model)

    # ============
    # Lower bound
    # ============
    model = SOSModel(sose.backend, kwargs...)
    @variable(model, γ) # JuMP decision variable
    @constraint(model, p >= γ, domain = B, maxdegree = sose.order)
    @objective(model, Max, γ)
    optimize!(model)
    lower_bound = objective_value(model)

    return interval(lower_bound, upper_bound)
end

end  # module
