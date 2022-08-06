module RangeEnclosures

using Requires, Reexport
@reexport using ForwardDiff

@reexport using IntervalArithmetic
const Interval_or_IntervalBox = Union{Interval, IntervalBox}

import ReachabilityBase.Require: require
require(package; fun_name::String="", explanation::String="") =
    require(@__MODULE__, package; fun_name=fun_name, explanation=explanation)

include("algorithms.jl")
include("intervalarithmetic.jl")
include("branchandbound.jl")
include("taylormodels.jl")
include("sdp_header.jl")
include("intervaloptimisation.jl")

# ================
# Optional methods
# ================

function __init__()
    @require AffineArithmetic = "2e89c364-fad6-56cb-99bd-ebadcd2cf8d2" include("affine.jl")
    @require SumOfSquares = "4b9e565b-77fc-50a5-a571-1244f986bda1" include("sdp.jl")
    @require TaylorModels = "314ce334-5f6e-57ae-acf6-00b6e903104a" eval(load_taylormodels())
    @require IntervalOptimisation = "c7c68f13-a4a2-5b9a-b424-07d005f8d9d2" eval(load_intervaloptimization())
    @require MultivariatePolynomials = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3" include("polynomials.jl")
end

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

end  # module
