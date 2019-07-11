@testset "Multivariate functions" begin
    # himmilbeau from Daisy benchmarks
    f(x1, x2, x3) = -x1*x2 - 2*x2*x3 - x1 - x3
    dom = Interval(-4.5, -0.3) × Interval(0.4, 0.9) × Interval(3.8, 7.8)
    xref = Interval(-20.786552979420335, -0.540012836551535) # MOSEK deg 6
    for solver in available_solvers
        x = enclose(f, dom, solver)
        r = relative_precision(x, xref)
        @test inf(r) ≤ 5 && sup(r) ≤ 16
    end
end
