@testset "Univariate functions" begin
    # bspline0 from Daisy benchmarks
    f = x -> (1 - x)^3 / 6.0
    dom = Interval(-4.5, -0.3)
    xref = Interval(0.36616666666666675, 27.729166666666668)

    for solver in available_solvers
        x = enclose(f, dom, solver)
        rleft, rright = relative_precision(x, xref)
        if solver isa TaylorModelsEnclosure
            # for this example, TaylorModels cannot tightly approximate the lhs
            @test rleft ≤ 30 && rright ≤ 1e-10
        elseif solver isa SumOfSquaresEnclosure
            # solver returns negative -1.06259e-06
            @test rleft ≥ -1e-5 && rright ≤ 1e-5
        else
            @test rleft ≤ 1e-5 && rright ≤ 1e-5
        end
    end
end

@testset "Univariate example the Quickstart Guide" begin
    f(x) = -x^3/6 + 5x
    dom = Interval(1, 4)

    x = enclose(f, dom, NaturalEnclosure())
    xref = Interval(-5.66667, 19.8334)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5

    x = enclose(f, dom, TaylorModelsEnclosure(order=4))
    xref = Interval(-4.2783, 12.7084)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5

    x = enclose(f, dom, MooreSkelboeEnclosure())
    xref = Interval(4.83299, 10.5448)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5

    if VERSION < v"1.7"
        using SumOfSquares, SDPA
        x = enclose(f, dom, SumOfSquaresEnclosure(backend=SDPA.Optimizer))
        xref = Interval(4.8333, 10.541)
        rleft, rright = relative_precision(x, xref)
        @test rleft ≤ 1e-5 && rright ≤ 1e-5
    end
end

@testset "Test univariate polynomial input" begin
    @polyvar x
    p = -x^3/6 + 5x
    dom = Interval(1, 4)

    x = enclose(p, dom)
    xref = Interval(-5.66667, 19.8334)
    rleft, rright = relative_precision(x, xref)
    @test rleft ≤ 1e-5 && rright ≤ 1e-5
end
