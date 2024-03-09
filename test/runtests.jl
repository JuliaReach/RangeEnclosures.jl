using Test, RangeEnclosures
using AffineArithmetic, IntervalOptimisation, TaylorModels, SumOfSquares

@static if Sys.iswindows()  # SDPA is broken on Windows
    @test_broken using SDPA
else
    using SDPA
end

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

@static if !Sys.iswindows()  # SDPA is broken on Windows
    using Documenter
    include("../docs/init.jl")
    @testset "doctests" begin
        doctest(RangeEnclosures)
    end
end

include("Aqua.jl")
