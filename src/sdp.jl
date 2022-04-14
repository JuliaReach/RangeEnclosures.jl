#======================================
Methods using semidefinite programming
======================================#
using .SumOfSquares

"""
    new_sos(backend; kwargs...)

Return a new (empty) sum-of-squares optimization problem for the given backend.

### Input

- `backend` -- the backend (also called JuMP `solver`)
- `kwargs`  -- additional keyword arguments

### Output

An instance of `SOSModel` for the given backend and options.
"""
@inline function new_sos(backend, kwargs...)
    𝑂 = Dict(kwargs)

    if :QUIET ∈ keys(𝑂)
        # for mosek solver
        SOSModel(backend, QUIET=𝑂[:QUIET])
    else
        SOSModel(backend)
    end
end


function _enclose(sose::SumOfSquaresEnclosure, f::Function, dom::Interval_or_IntervalBox;
                  kwargs...)

    _enclose_SumOfSquares(f, dom, sose.order, sose.backend; kwargs...)
end

function _enclose_SumOfSquares(f::Function, dom::Interval, order::Int,
                               backend; kwargs...)

    # polynomial variables
    @polyvar x
    p = f(x)

    # box constraints
    B = @set inf(dom) <= x && x <= sup(dom)

    # ============
    # Upper bound
    # ============
    model = new_sos(backend, kwargs...)
    @variable(model, γ) # JuMP decision variable
    @constraint(model, p <= γ, domain=B, maxdegree=order)
    @objective(model, Min, γ)
    optimize!(model)
    upper_bound = objective_value(model)

    # ============
    # Lower bound
    # ============
    model = new_sos(backend, kwargs...)
    @variable(model, γ) # JuMP decision variable
    @constraint(model, p >= γ, domain=B, maxdegree=order)
    @objective(model, Max, γ)
    optimize!(model)
    lower_bound = objective_value(model)

    return Interval(lower_bound, upper_bound)
end

function _enclose_SumOfSquares(f::Function, dom::IntervalBox{N}, order::Int,
                               backend; kwargs...) where {N}

    # polynomial variables
    @polyvar x[1:N]
    p = f(x...)

    # box constraints
    Bi =[@set inf(dom[i]) <= x[i] && x[i] <= sup(dom[i]) for i in 1:N]
    B = reduce(intersect, Bi)

    # ============
    # Upper bound
    # ============
    model = new_sos(backend, kwargs...)
    @variable(model, γ) # JuMP decision variable
    @constraint(model, p <= γ, domain=B, maxdegree=order)
    @objective(model, Min, γ)
    optimize!(model)
    upper_bound = objective_value(model)

    # ============
    # Lower bound
    # ============
    model = new_sos(backend, kwargs...)
    @variable(model, γ) # JuMP decision variable
    @constraint(model, p >= γ, domain=B, maxdegree=order)
    @objective(model, Max, γ)
    optimize!(model)
    lower_bound = objective_value(model)

    return Interval(lower_bound, upper_bound)
end
