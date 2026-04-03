module IntervalOptimisationExt

import RangeEnclosures
using RangeEnclosures: Interval_or_IntervalVector, MooreSkelboeEnclosure, enclose

using IntervalArithmetic: inf, interval, sup
using IntervalBoxes: IntervalBox

import IntervalOptimisation
using IntervalOptimisation: HeapedVector, minimise, maximise

function RangeEnclosures._default_vector_MSE(::Nothing)
    return HeapedVector
end

function RangeEnclosures.enclose(f::Function, dom::Interval_or_IntervalVector,
                                 mse::MooreSkelboeEnclosure; kwargs...)
    global_min, _ = minimise(f, dom; structure=mse.structure, tol=mse.tol)
    global_max, _ = maximise(f, dom; structure=mse.structure, tol=mse.tol)

    return interval(inf(global_min), sup(global_max))
end

function RangeEnclosures.enclose(f::Function, dom::IntervalBox, mse::MooreSkelboeEnclosure;
                                 kwargs...)
    # this algorithm modifies the domain, so we convert to a Vector
    return enclose(f, Vector(dom.v), mse; kwargs...)
end

end  # module
