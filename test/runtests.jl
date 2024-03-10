using Test, RangeEnclosures
using AffineArithmetic, IntervalOptimisation, TaylorModels, SDPA, SumOfSquares
using DynamicPolynomials: @polyvar

available_solvers = (NaturalEnclosure(),
                     MeanValueEnclosure(),
                     AffineArithmeticEnclosure(),
                     MooreSkelboeEnclosure(),
                     TaylorModelsEnclosure(),
                     BranchAndBoundEnclosure())

include("univariate.jl")
include("multivariate.jl")
include("paper.jl")

using Documenter
include("../docs/init.jl")
@testset "doctests" begin
    doctest(RangeEnclosures)
end

include("Aqua.jl")
