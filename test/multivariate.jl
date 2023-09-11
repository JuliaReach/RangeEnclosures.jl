@testset "Multivariate functions" begin
    # himmilbeau from Daisy benchmarks
    f(x) = -x[1] * x[2] - 2 * x[2] * x[3] - x[1] - x[3]
    dom = [interval(-4.5, -0.3), interval(0.4, 0.9), interval(3.8, 7.8)]
    xref = interval(-20.786552979420335, -0.540012836551535) # MOSEK deg 6
    for solver in available_solvers
        x = enclose(f, dom, solver)
        rleft, rright = relative_precision(x, xref)
        if solver isa MeanValueEnclosure
            @test rleft ≤ 10 && rright ≤ 23.6
        else
            @test rleft ≤ 5 && rright ≤ 16
        end
    end
end

@testset "Multivariate example from the Quickstart Guide" begin
    g(x) = (x[1] + 2x[2] - 7)^2 + (2x[1] + x[2] - 5)^2
    dom = [-10 .. 10, -10 .. 10]

    x = enclose(g, dom, NaturalEnclosure())
    xref = interval(0, 2594)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5
end

@testset "Test multivariate polynomial input" begin
    @polyvar x y
    p = (x + 2y - 7)^2 + (2x + y - 5)^2
    dom = [-10 .. 10, -10 .. 10]

    x = enclose(p, dom)
    xref = interval(-1446, 2594)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5
    # Note: DynamicPolynomials automatically expands p, and evaluation using
    # interval arithmetic gives a worse left bound than the factored expression.

    if Sys.iswindows()
        # SDPA is broken on Windows
        @test_broken begin
            x = enclose(p, dom, SumOfSquaresEnclosure(; backend=SDPA.Optimizer))
            isapprox(inf(x), 0.0; atol=1e-3)
            isapprox(sup(x), 670.612; atol=1e-3)
        end
    else
        x = enclose(p, dom, SumOfSquaresEnclosure(; backend=SDPA.Optimizer))
        @test isapprox(inf(x), 0.0; atol=1e-3)
        @test isapprox(sup(x), 670.612; atol=1e-3)
    end
end

@testset "Taylor-model solver without normalization" begin
    f(x) = x[1]^2 - 5x[1]
    dom = [-1 .. 1, 0 .. 0]
    x = enclose(f, dom, TaylorModelsEnclosure(; normalize=false))
    xref = interval(-4, 6)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≈ 10 && rright ≈ 0
end

@testset "Test branch-and-bound solver" begin
    f(x) = (1 / 3)x[1]^3 + (x[1] - 0.5)^2
    dom = [-4.0 .. 4.0, 0 .. 0]
    xref = interval(-1.0833333333333321, 33.58333333333333)
    x = enclose(f, dom, BranchAndBoundEnclosure())
    rleft, rright = relative_precision(x, xref)
    @test rleft ≈ 0 && 2.04e-14 ≤ rright ≤ 2.05e-14
end
