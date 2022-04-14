using IntervalOptimisation, Test, RangeEnclosures
using RangeEnclosures: relative_precision

using DynamicPolynomials: @polyvar

available_solvers = (NaturalEnclosure(), TaylorModelsEnclosure(), :BranchandBound, MooreSkelboeEnclosure())

include("univariate.jl")
include("multivariate.jl")
