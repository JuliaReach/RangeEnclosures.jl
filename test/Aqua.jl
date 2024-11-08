using RangeEnclosures, Test
import Aqua

@testset "Aqua tests" begin
    if VERSION >= v"1.7"
        Aqua.test_all(RangeEnclosures)
    else
        # some tests fail in v1.6 due to problems in SDPA
        Aqua.test_all(RangeEnclosures; stale_deps=false, deps_compat=false)
    end
end
