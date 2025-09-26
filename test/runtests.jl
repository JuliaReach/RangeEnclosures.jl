using Test, RangeEnclosures
using AffineArithmetic, IntervalOptimisation, TaylorModels, SDPA, SumOfSquares
using DynamicPolynomials: @polyvar
using RangeEnclosures: Interval, inf, sup
using TaylorModels.IntervalArithmetic: isequal_interval

available_solvers = (NaturalEnclosure(),
                     MeanValueEnclosure(),
                     AffineArithmeticEnclosure(),
                     MooreSkelboeEnclosure(),
                     TaylorModelsEnclosure(),
                     BranchAndBoundEnclosure())

include("univariate.jl")
include("multivariate.jl")
include("paper.jl")
include("Aqua.jl")
