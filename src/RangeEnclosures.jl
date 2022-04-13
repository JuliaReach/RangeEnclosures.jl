module RangeEnclosures

using DynamicPolynomials, Requires, Reexport
@reexport using IntervalArithmetic
const Interval_or_IntervalBox = Union{Interval, IntervalBox}


include("algorithms.jl")
include("intervals.jl")
include("taylormodels.jl")
include("branchandbound.jl")

#================
Optional methods
=================#
function __init__()
    @require SumOfSquares = "4b9e565b-77fc-50a5-a571-1244f986bda1" include("sdp.jl")

    @require IntervalOptimisation = "c7c68f13-a4a2-5b9a-b424-07d005f8d9d2" include("intervaloptimisation.jl")
end

#================
API
=================#
include("enclose.jl")

export enclose,
  NaturalEnclosure, MooreSkelboeEnclosure, SumOfSquaresEnclosure, TaylorModelsEnclosure

const available_solvers = (NaturalEnclosure, MooreSkelboeEnclosure,
                           SumOfSquaresEnclosure, TaylorModelsEnclosure)
end # module
