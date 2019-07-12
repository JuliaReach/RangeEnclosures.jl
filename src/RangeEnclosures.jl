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
                           :SumOfSquares]

const optional_solvers = [:AffineArithmetic]

include("intervals.jl")
include("taylormodels.jl")
include("sdp.jl")
include("branchandbound.jl")

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
