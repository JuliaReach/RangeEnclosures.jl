using IntervalOptimisation, TaylorModels, Test, RangeEnclosures, SumOfSquares, SDPA, AffineArithmetic

using DynamicPolynomials: @polyvar

available_solvers = (NaturalEnclosure(), TaylorModelsEnclosure(), AffineArithmeticEnclosure(),
                     BranchAndBoundEnclosure(), MooreSkelboeEnclosure())

include("univariate.jl")
include("multivariate.jl")

using Documenter
include("../docs/init.jl")
@time @testset "doctests" begin doctest(RangeEnclosures) end
