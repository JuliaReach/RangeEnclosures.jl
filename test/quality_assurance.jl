using RangeEnclosures, Test
import Aqua, ExplicitImports

@testset "ExplicitImports tests" begin
    ignores_all_explicit_imports_are_public = (:AbstractEnclosureAlgorithm, :Aff,
                                               :Interval_or_IntervalVector,
                                               :Interval_or_IntervalVector_or_IntervalBox,
                                               :IntervalVector_or_IntervalBox)
    ignores_all_qualified_accesses_are_public = (:Fix1, :derivative, :gradient, :where_bisect,
                                                 :_default_vector_MSE)
    ignores_no_stale_explicit_imports = (:SemialgebraicSets,)  # false positive due to external macro
    ExplicitImports.test_explicit_imports(RangeEnclosures;
                                          all_explicit_imports_are_public=(ignore=ignores_all_explicit_imports_are_public,),
                                          all_qualified_accesses_are_public=(ignore=ignores_all_qualified_accesses_are_public,),
                                          no_stale_explicit_imports=(ignore=ignores_no_stale_explicit_imports,))
end

@testset "Aqua tests" begin
    Aqua.test_all(RangeEnclosures)
end
