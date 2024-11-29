# tests from the JuliaCon 2022 tool paper

struct MyEnclosure end

@testset "The enclose API" begin
    function RangeEnclosures.enclose(f::Function,
                                     dom::Union{Interval,IntervalBox},
                                     solver::MyEnclosure; kwargs...)
        return 1 .. 2
    end

    f(x) = x
    @test isequal_interval(enclose(f, 0 .. 1, MyEnclosure()), 1 .. 2)
end

@testset "How to use the package" begin
    f(x) = -sum(k * x * sin(k * (x - 3) / 3) for k in 1:5)
    D = -10 .. 10
    @test isequal_interval(enclose(f, D, NaturalEnclosure()), interval(-150, 150))
    res = enclose(f, D, BranchAndBoundEnclosure())
    @test res isa Interval
    if oldIA
        @test inf(res) ≈ -56.42311 && sup(res) ≈ 34.99878
    else
        @test inf(res) ≈ -56.42400 && sup(res) ≈ 34.988386
    end
end

@testset "Combining different solvers" begin
    g(x) = x^2 - 2 * x + 1
    Dg = 0 .. 4
    @test isequal_interval(enclose(g, Dg, NaturalEnclosure()), interval(-7, 17))
    @test isequal_interval(enclose(g, Dg, MeanValueEnclosure()), interval(-11, 13))

    # TODO combining solvers is currently not supported for IntervalArithmetic v0.22
    @ts @test isequal_interval(enclose(g, Dg, [NaturalEnclosure(), MeanValueEnclosure()]), interval(-7, 13))
end

@ts @testset "Using solvers based on external libraries" begin
    g(x) = x^2 - 2 * x + 1
    Dg = 0 .. 4
    res = enclose(g, Dg, MooreSkelboeEnclosure())
    @test res isa Interval && inf(res) ≈ -0.0019195181 && sup(res) ≈ 9.0010805
end

@ts @testset "Multivariate functions" begin
    h(x) = sin(x[1]) - cos(x[2]) - sin(x[1]) * cos(x[1])
    Dh = IntervalBox(-5 .. 5, -5 .. 5)
    res = enclose(h, Dh, BranchAndBoundEnclosure())
    @test res isa Interval && inf(res) ≈ -2.71067455 && sup(res) ≈ 2.7131246
end
