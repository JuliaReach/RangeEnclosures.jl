using Test, RangeEnclosures
using SDPA, SumOfSquares
using DynamicPolynomials: @polyvar

global oldIA
if !isdefined(Main, :oldIA)
    @show oldIA = true
end

@static if oldIA
    using AffineArithmetic, IntervalOptimisation, TaylorModels
    available_solvers = (NaturalEnclosure(),
                         MeanValueEnclosure(),
                         AffineArithmeticEnclosure(),
                         MooreSkelboeEnclosure(),
                         TaylorModelsEnclosure(),
                         BranchAndBoundEnclosure())

    # execute the argument code
    macro ts(arg)
        quote
            $(esc(arg))
        end
    end

    isequal_interval = (==)
else
    available_solvers = (NaturalEnclosure(),
                         MeanValueEnclosure(),
                         BranchAndBoundEnclosure())

    # skip the argument code
    macro ts(arg) end

    using RangeEnclosures: Interval  # this is necessary for some reason
    using RangeEnclosures.IntervalArithmetic: isequal_interval, inf, sup
end

include("univariate.jl")
@ts include("multivariate.jl")
include("paper.jl")

include("Aqua.jl")
