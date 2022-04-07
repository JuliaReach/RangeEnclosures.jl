module RangeEnclosures

using DynamicPolynomials, Requires, Reexport
@reexport using IntervalArithmetic
const Interval_or_IntervalBox = Union{Interval, IntervalBox}

#=================
Available methods
==================#
const available_solvers = [:IntervalArithmetic,
                           :TaylorModels,
                           :BranchandBound]

const optional_solvers = [:AffineArithmetic, :IntervalOptimisation, :SumOfSquares]

include("intervals.jl")
include("taylormodels.jl")
include("branchandbound.jl")

#================
Optional methods
=================#
function __init__()
    @require AffineArithmetic = "2e89c364-fad6-56cb-99bd-ebadcd2cf8d2" include("affine.jl")

    @require SumOfSquares = "4b9e565b-77fc-50a5-a571-1244f986bda1" include("sdp.jl")

    @require IntervalOptimisation = "c7c68f13-a4a2-5b9a-b424-07d005f8d9d2" include("intervaloptimisation.jl")
end

#================
API
=================#
include("enclose.jl")

export enclose

end # module
