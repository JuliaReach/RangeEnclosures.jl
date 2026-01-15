using RangeEnclosures, Test
import Aqua, ExplicitImports

@testset "ExplicitImports tests" begin
    ignores = (:Aff,)
    @test isnothing(ExplicitImports.check_all_explicit_imports_are_public(RangeEnclosures;
                                                                          ignore=ignores))
    @test isnothing(ExplicitImports.check_all_explicit_imports_via_owners(RangeEnclosures))
    ignores = (:Fix1, :derivative, :gradient, :where_bisect)
    @test isnothing(ExplicitImports.check_all_qualified_accesses_are_public(RangeEnclosures;
                                                                            ignore=ignores))
    @test isnothing(ExplicitImports.check_all_qualified_accesses_via_owners(RangeEnclosures))
    @test isnothing(ExplicitImports.check_no_implicit_imports(RangeEnclosures))
    @test isnothing(ExplicitImports.check_no_self_qualified_accesses(RangeEnclosures))
    ignores = (:SemialgebraicSets,)  # false positive due to external macro
    @test isnothing(ExplicitImports.check_no_stale_explicit_imports(RangeEnclosures;
                                                                    ignore=ignores))
end

@testset "Aqua tests" begin
    Aqua.test_all(RangeEnclosures)
end
