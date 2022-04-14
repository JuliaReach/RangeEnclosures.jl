using IntervalOptimisation, Test, RangeEnclosures

using DynamicPolynomials: @polyvar

available_solvers = (NaturalEnclosure(), TaylorModelsEnclosure(), :BranchandBound, MooreSkelboeEnclosure())

include("univariate.jl")
include("multivariate.jl")
