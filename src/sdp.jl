using .SumOfSquares

function _enclose_sos(sose::SumOfSquaresEnclosure, p::AbstractPolynomialLike,
                      dom::Interval_or_IntervalBox;
                      kwargs...)
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
