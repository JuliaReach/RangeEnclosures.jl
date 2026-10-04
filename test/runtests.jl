using Test, RangeEnclosures

@testset "Warning about missing optional dependencies" begin
    if !isdefined(@__MODULE__, :IntervalOptimisation)
        @test_throws ArgumentError RangeEnclosures._default_vector_MSE(0)
    end
end

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

include("quality_assurance.jl")
