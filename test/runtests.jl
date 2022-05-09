using IntervalOptimisation, TaylorModels, Test, RangeEnclosures, SumOfSquares, SDPA

using DynamicPolynomials: @polyvar

available_solvers = (NaturalEnclosure(), TaylorModelsEnclosure(),
                     BranchAndBoundEnclosure(), MooreSkelboeEnclosure())

include("univariate.jl")
include("multivariate.jl")
