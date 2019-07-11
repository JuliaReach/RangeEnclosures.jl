module RangeEnclosures

using Requires, Reexport
@reexport using IntervalArithmetic
const Interval_or_IntervalBox = Union{Interval, IntervalBox}

#=================
Available methods
==================#
const available_solvers = [:IntervalArithmetic,
                           :IntervalOptimisation,
                           :TaylorModels,
                           :SumOfSquares,
                           :AffineArithmetic # optional
                           ]

include("intervals.jl")
include("taylormodels.jl")
include("sdp.jl")

#================
Optional methods
=================#
function __init__()
    @require AffineArithmetic = "2e89c364-fad6-56cb-99bd-ebadcd2cf8d2" include("affine.jl")
end

#================
API
=================#
include("enclose.jl")

export enclose

end # module
