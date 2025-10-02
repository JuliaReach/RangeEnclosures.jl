@testset "Univariate functions" begin
    # bspline0 from Daisy benchmarks
    f(x) = (1 - x)^3 / 6.0
    dom = interval(-4.5, -0.3)
    xref = interval(0.36616666666666675, 27.729166666666668)

    # default solver
    x = enclose(f, dom)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5

    for solver in available_solvers
        x = enclose(f, dom, solver)
        rleft, rright = relative_precision(x, xref)
        if solver isa TaylorModelsEnclosure
            # for this example, TaylorModels cannot tightly approximate the lhs
            @test rleft ≤ 30 && rright ≤ 1e-10
        elseif solver isa AffineArithmeticEnclosure
            @test rleft ≤ 22 && rright ≤ 1e-10
        elseif solver isa MeanValueEnclosure
            @test rleft ≤ 94 && rright ≤ 39
        else
            @test rleft ≤ 1e-5 && rright ≤ 1e-5
        end
    end
end

@testset "Univariate example from the Quickstart Guide" begin
    f(x) = -x^3 / 6 + 5x
    dom = interval(1, 4)

    x = enclose(f, dom, NaturalEnclosure())
    xref = interval(-5.66667, 19.8334)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5

    x = enclose(f, dom, TaylorModelsEnclosure(; order=4))
    xref = interval(-4.2783, 12.7084)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5

    x = enclose(f, dom, MooreSkelboeEnclosure())
    xref = interval(4.83299, 10.5448)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5
end

@testset "Univariate input, multivariate output" begin
    f(x) = (-x, 3x)
    dom = interval(-1, 2)
    for solver in available_solvers
        if (solver isa MeanValueEnclosure || solver isa MooreSkelboeEnclosure ||
            solver isa BranchAndBoundEnclosure)
            # solver does not support multivariate outputs
            continue
        end
        x = enclose(f, dom, solver)
        @test x isa Vector{Interval{Float64}}
        @test issubset_interval([interval(-2, 1), interval(-3, 6)], x)
    end
end

@testset "Test univariate polynomial input" begin
    @polyvar x
    p = -x^3 / 6 + 5x
    dom = interval(1, 4)

    x = enclose(p, dom)
    xref = interval(-5.66667, 19.8334)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5

    x = enclose(p, dom, SumOfSquaresEnclosure(; backend=SDPA.Optimizer))
    xref = interval(4.8333, 10.541)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5
end

@testset "Taylor-model solver without normalization" begin
    f(x) = x^2 - 5x
    dom = interval(-1, 1)
    x = enclose(f, dom, TaylorModelsEnclosure(; normalize=false))
    xref = interval(-4, 6)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≈ 10 && rright ≈ 0
end

@testset "Test branch-and-bound solver" begin
    f(x) = (1 / 3)x^3 + (x - 0.5)^2
    dom = interval(-4.0, 4.0)
    xref = interval(-1.0833333333333321, 33.58333333333333)
    x = enclose(f, dom, BranchAndBoundEnclosure())
    rleft, rright = relative_precision(x, xref)
    @test rleft ≈ 0 && 2.04e-14 ≤ rright ≤ 2.05e-14
end
