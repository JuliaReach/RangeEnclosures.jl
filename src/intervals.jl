#=================================
Methods using Interval Arithmetic
=================================#

function _enclose(::NaturalEnclosure, f::Function, dom::Interval_or_IntervalBox; kwargs...)
    return f(dom...)
end
