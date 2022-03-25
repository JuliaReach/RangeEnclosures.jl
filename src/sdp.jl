#======================================
Methods using semidefinite programming
======================================#
using SumOfSquares, DynamicPolynomials, SemialgebraicSets, SDPA

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

    if VERSION < v"1.6"
        if :QUIET ∈ keys(𝑂)
            # for mosek solver
            SOSModel(with_optimizer(backend, QUIET=𝑂[:QUIET]))
        else
            SOSModel(with_optimizer(backend))
        end
    else
        if :QUIET ∈ keys(𝑂)
            # for mosek solver
            SOSModel(backend, QUIET=𝑂[:QUIET])
        else
            SOSModel(backend)
        end
    end
end

"""
    enclose_SumOfSquares(f::Function, dom::Interval_or_IntervalBox,
                         order::Int=5, backend=SDPA.Optimizer; kwargs...)

Compute a range enclosure using sum-of-squares optimization.

### Input

- `f`       -- function
- `dom`     -- hyperrectangular domain, either a unidimensional `Interval` or
               a multidimensional `IntervalBox`
- `order`   -- (optional, default: `5`) maximum degree of the SDP relaxation
- `backend` -- (optional, default: `SDPA.Optimizer`) the optimization backend
               (aka JuMP solver)
- `kwargs`  -- additional keyword arguments

### Output

An interval representing the range enclosure (minimum and maximum) of `f` over
its domain `dom`.

### Algorithm

The range enclosure is computed using polynomial optimization methods.
We refer to the documentation and examples of `SumOfSquares.jl` for details.

### Notes

Use the `backend` keyword argument to pass an SDP solver backend of your choice;
additional arguments to the solver can be passed in `kwargs`.

For instance, to use `SDPA` (default choice), use it as:

```julia
julia> backend = SDPA.Optimizer

julia> enclose_SumOfSquares(f, dom, order, backend=backend)
...
```

To use `MOSEK` in non-verbose mode, let

```julia
julia> using MosekTools

julia> backend = MosekTools.Mosek.Optimizer;

julia> enclose_SumOfSquares(f, dom, order, backend=backend, QUIET=true)
...
```

To get the runtime, use `MOI.get(model, MOI.SolveTime())`.
"""
function enclose_SumOfSquares(f::Function, dom::Interval_or_IntervalBox;
                              order::Int=5, backend=SDPA.Optimizer, kwargs...)
    _enclose_SumOfSquares(f, dom, order, backend; kwargs...)
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
