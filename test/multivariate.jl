@testset "Multivariate functions" begin
    # himmilbeau from Daisy benchmarks
    f(x1, x2, x3) = -x1*x2 - 2*x2*x3 - x1 - x3
    dom = Interval(-4.5, -0.3) × Interval(0.4, 0.9) × Interval(3.8, 7.8)
    xref = Interval(-20.786552979420335, -0.540012836551535) # MOSEK deg 6
    for solver in available_solvers
        x = enclose(f, dom, solver)
        rleft, rright = relative_precision(x, xref)
        @test rleft ≤ 5 && rright ≤ 16
    end
end

@testset "Multivariate example from the Quickstart Guide" begin
    g(x, y) = (x + 2y - 7)^2 + (2x + y - 5)^2
    dom = IntervalBox(-10..10, 2)

    x = enclose(g, dom, NaturalEnclosure())
    xref = Interval(0, 2594)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5
end

@testset "Test multivariate polynomial input" begin
    @polyvar x y
    p = (x + 2y - 7)^2 + (2x + y - 5)^2
    dom = IntervalBox(-10..10, 2)

    x = enclose(p, dom)
    xref = Interval(-1446, 2594)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5
    # Note: DynamicPolynomials automatically expands p, and evaluation using
    # interval arithmetic gives a worse left bound than the factored expression.

    x = enclose(p, dom, SumOfSquaresEnclosure(backend=SDPA.Optimizer))
    @test isapprox(inf(x), 0.0; atol=1e-3)
    @test isapprox(sup(x), 670.612; atol=1e-3)
end
