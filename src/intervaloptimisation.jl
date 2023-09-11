# ===================================
# Methods using interval optimization
# ===================================

function _enclose(mse::MooreSkelboeEnclosure, f::Function, dom::Interval_or_IntervalVector;
                  kwargs...)
    require(@__MODULE__, :IntervalOptimisation; fun_name="enclose")

    global_min, _ = minimise(f, dom; structure=mse.structure, tol=mse.tol)
    global_max, _ = maximise(f, dom; structure=mse.structure, tol=mse.tol)

    return interval(inf(global_min), sup(global_max))
end

function load_intervaloptimization()
    return quote
        import .IntervalOptimisation: numeric_type, diam
        using .IntervalOptimisation

        _default_vector_MSE = HeapedVector

        numeric_type(X::AbstractVector{Interval{T}}) where {T} = T

        diam(X::AbstractVector{<:Interval}) = maximum(diam.(X))

        function IntervalArithmetic.bisect(X::AbstractVector{<:Interval})
            i = argmax(diam.(X))  # find longest side
            x1, x2 = bisect(X[i])
            X1 = copy(X)
            X1[i] = x1
            X2 = copy(X)
            X2[i] = x2
            return (X1, X2)
        end
    end  # quote
end  # load_intervaloptimization()
