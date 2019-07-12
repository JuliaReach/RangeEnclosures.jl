@testset "Univariate functions" begin
    # bspline0 from Daisy benchmarks
    f = x -> (1 - x)^3 / 6.0
    dom = Interval(-4.5, -0.3)
    xref = Interval(0.36616666666666675, 27.729166666666668)

    for solver in available_solvers
        x = enclose(f, dom, solver)
        r = relative_precision(x, xref)
        if solver == :TaylorModels
            # for this example, TaylorModels cannot tightly approximate the lhs
            @test inf(r) ≤ 30 && sup(r) ≤ 1e-10
        elseif solver == :SumOfSquares
            # solver returns negative -1.06259e-06
            @test abs(inf(r)) ≤ 1e-5 && sup(r) ≤ 1e-5
#=        elseif solver == :BranchandBound
            #
            @test abs(inf(r)) ≤ 1e-5 && sup(r) ≤ 1e-5 =#
        else
            @test inf(r) ≤ 1e-5 && sup(r) ≤ 1e-5
        end
    end
end
