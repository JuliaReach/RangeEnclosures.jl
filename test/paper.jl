# tests from the JuliaCon 2022 tool paper

struct MyEnclosure end

@testset "The enclose API" begin
    import RangeEnclosures: enclose
    function enclose(f::Function,
                     dom::Union{Interval,IntervalBox},
                     solver::MyEnclosure; kwargs...)
        return 1 .. 2
    end

    f(x) = x
    @test enclose(f, 0 .. 1, MyEnclosure()) == 1 .. 2
end

@testset "How to use the package" begin
    f(x) = -sum(k * x * sin(k * (x - 3) / 3) for k in 1:5)
    D = -10 .. 10
    @test enclose(f, D, NaturalEnclosure()) == interval(-150, 150)
    res = enclose(f, D, BranchAndBoundEnclosure())
    @test res isa Interval && inf(res) ≈ -56.42311 && sup(res) ≈ 34.99878
end

@testset "Combining different solvers" begin
    g(x) = x^2 - 2 * x + 1
    Dg = 0 .. 4
    @test enclose(g, Dg, NaturalEnclosure()) == interval(-7, 17)
    @test enclose(g, Dg, MeanValueEnclosure()) == interval(-11, 13)

    @test enclose(g, Dg, [NaturalEnclosure(), MeanValueEnclosure()]) == interval(-7, 13)
end

@testset "Using solvers based on external libraries" begin
    g(x) = x^2 - 2 * x + 1
    Dg = 0 .. 4
    res = enclose(g, Dg, MooreSkelboeEnclosure())
    @test res isa Interval && inf(res) ≈ -0.0019195181 && sup(res) ≈ 9.0010805
end

@testset "Multivariate functions" begin
    h(x) = sin(x[1]) - cos(x[2]) - sin(x[1]) * cos(x[1])
    Dh = IntervalBox(-5 .. 5, -5 .. 5)
    res = enclose(h, Dh, BranchAndBoundEnclosure())
    @test res isa Interval && inf(res) ≈ -2.71067455 && sup(res) ≈ 2.7131246
end
