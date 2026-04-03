module RangeEnclosures

import ForwardDiff
using LinearAlgebra: dot
using IntervalArithmetic: Interval, interval, inf, sup, mid,
                          emptyinterval, hull, diam, bisect, intersect_interval
import IntervalBoxes
using IntervalBoxes: IntervalBox
const Interval_or_IntervalVector = Union{Interval,AbstractVector{<:Interval}}
const Interval_or_IntervalVector_or_IntervalBox = Union{Interval,AbstractVector{<:Interval},
                                                        IntervalBox}
const IntervalVector_or_IntervalBox = Union{AbstractVector{<:Interval},IntervalBox}

include("algorithms.jl")
include("intervalarithmetic.jl")
include("branchandbound.jl")

# ===
# API
# ===

include("enclose.jl")

export enclose,
       relative_precision,
       NaturalEnclosure,
       MeanValueEnclosure,
       AffineArithmeticEnclosure,
       MooreSkelboeEnclosure,
       SumOfSquaresEnclosure,
       TaylorModelsEnclosure,
       BranchAndBoundEnclosure

# standard ways from IntervalArithmetic to create intervals
export interval,
       IntervalBox

end  # module
