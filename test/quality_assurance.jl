using RangeEnclosures, Test
import Aqua, ExplicitImports

@testset "ExplicitImports tests" begin
    ignores_all_explicit_imports_are_public = (:Aff,)
    ignores_all_qualified_accesses_are_public = (:Fix1, :derivative, :gradient, :where_bisect)
    ignores_no_stale_explicit_imports = (:SemialgebraicSets,)  # false positive due to external macro
    ExplicitImports.test_explicit_imports(RangeEnclosures;
                                          all_explicit_imports_are_public=(ignore=ignores_all_explicit_imports_are_public,),
                                          all_qualified_accesses_are_public=(ignore=ignores_all_qualified_accesses_are_public,),
                                          no_stale_explicit_imports=(ignore=ignores_no_stale_explicit_imports,))
end

@testset "Aqua tests" begin
    Aqua.test_all(RangeEnclosures)
end
