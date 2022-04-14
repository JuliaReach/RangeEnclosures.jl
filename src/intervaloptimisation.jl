#===================================
Methods using Interval Optimisation
===================================#
using .IntervalOptimisation

function _enclose(mse::MooreSkelboeEnclosure, f::Function, dom::Interval_or_IntervalBox;
                  kwargs...)

    global_min, _ = minimise(X->f(X...), dom, structure=mse.structure, tol=mse.tol)
    global_max, _ = maximise(X->f(X...), dom, structure=mse.structure, tol=mse.tol)

    return Interval(inf(global_min), sup(global_max))
end
