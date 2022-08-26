# ===================================
# Methods using interval optimization
# ===================================

function _enclose(mse::MooreSkelboeEnclosure, f::Function, dom::Interval_or_IntervalBox;
                  kwargs...)
    require(@__MODULE__, :IntervalOptimisation; fun_name="enclose")

    global_min, _ = minimise(f, dom, structure=mse.structure, tol=mse.tol)
    global_max, _ = maximise(f, dom, structure=mse.structure, tol=mse.tol)

    return Interval(inf(global_min), sup(global_max))
end

function load_intervaloptimization()
return quote
using .IntervalOptimisation

_default_vector_MSE = HeapedVector

end  # quote
end  # load_intervaloptimization()
