# ===================================
# Methods using interval optimization
# ===================================

function enclose(f::Function, dom::Interval_or_IntervalBox, mse::MooreSkelboeEnclosure; kwargs...)
    require(@__MODULE__, :IntervalOptimisation; fun_name="enclose")

    global_min, _ = minimise(f, dom; structure=mse.structure, tol=mse.tol)
    global_max, _ = maximise(f, dom; structure=mse.structure, tol=mse.tol)

    return interval(inf(global_min), sup(global_max))
end

function load_intervaloptimization()
    return quote
        using .IntervalOptimisation: HeapedVector, minimise, maximise

        _default_vector_MSE = HeapedVector
    end  # quote
end  # load_intervaloptimization()
