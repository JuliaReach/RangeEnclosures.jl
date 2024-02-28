using RangeEnclosures, Test
import Aqua

@testset "Aqua tests" begin
    Aqua.test_all(RangeEnclosures; ambiguities=false)

    # do not warn about ambiguities in dependencies
    Aqua.test_ambiguities(RangeEnclosures)
end
