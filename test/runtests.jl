using IntervalOptimisation, Test, RangeEnclosures
using RangeEnclosures: relative_precision

using DynamicPolynomials: @polyvar

available_solvers = (:IntervalArithmetic, :TaylorModels, :BranchandBound, :IntervalOptimisation)

include("univariate.jl")
include("multivariate.jl")
