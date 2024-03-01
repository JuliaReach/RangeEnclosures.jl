using Test, RangeEnclosures
using AffineArithmetic, IntervalOptimisation, TaylorModels, SumOfSquares

@static if Sys.iswindows() || VERSION >= v"1.10"
    # SDPA is broken on Windows or v1.10
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

@static if !Sys.iswindows()  # broken due to SDPA
    using Documenter
    include("../docs/init.jl")
    @testset "doctests" begin
        doctest(RangeEnclosures)
    end
end

include("Aqua.jl")
