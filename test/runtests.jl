using Test, RangeEnclosures
using AffineArithmetic, IntervalOptimisation, SCS, SumOfSquares, TaylorModels
using DynamicPolynomials: @polyvar
using RangeEnclosures: Interval, inf, sup
using TaylorModels.IntervalArithmetic: isequal_interval

const _SDP_solver = SumOfSquares.optimizer_with_attributes(SCS.Optimizer, MOI.Silent() => true)

const available_solvers = (NaturalEnclosure(),
                           MeanValueEnclosure(),
                           AffineArithmeticEnclosure(),
                           MooreSkelboeEnclosure(),
                           TaylorModelsEnclosure(),
                           BranchAndBoundEnclosure())

include("univariate.jl")
include("multivariate.jl")
include("paper.jl")

include("quality_assurance.jl")
