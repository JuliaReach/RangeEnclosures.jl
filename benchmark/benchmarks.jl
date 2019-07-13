using BenchmarkTools, RangeEnclosures
using RangeEnclosures: relative_precision

SUITE = BenchmarkGroup()

include("Daisy/daisy.jl")
