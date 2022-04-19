module RangeEnclosures

using DynamicPolynomials, Requires, Reexport
@reexport using ForwardDiff
@reexport using IntervalArithmetic
const Interval_or_IntervalBox = Union{Interval, IntervalBox}


include("algorithms.jl")
include("intervals.jl")
include("branchandbound.jl")

#================
Optional methods
=================#
function __init__()
    @require SumOfSquares = "4b9e565b-77fc-50a5-a571-1244f986bda1" include("sdp.jl")
    @require TaylorModels = "314ce334-5f6e-57ae-acf6-00b6e903104a" include("taylormodels.jl")
    @require IntervalOptimisation = "c7c68f13-a4a2-5b9a-b424-07d005f8d9d2" include("intervaloptimisation.jl")
end

#================
API
=================#
include("enclose.jl")

export enclose, relative_precision,
  NaturalEnclosure, MooreSkelboeEnclosure, SumOfSquaresEnclosure,
  TaylorModelsEnclosure, BranchAndBoundEnclosure,
  AbstractEnclosureAlgorithm

end # module
