# ======================
# Setup
# ======================

# The benchmarks in this file are taken from
# [Project Daisy](https://github.com/malyzajko/daisy/blob/master/testcases/).
SUITE["Daisy"] = BenchmarkGroup()
RESULTS = SUITE["Daisy"]

# The following domains are used throughout the tests in [AlthoffGK18; Tables 3-5](@citet).
a = Interval(-4.5, -0.3)
b = Interval(0.4, 0.9)
c = Interval(3.8, 7.8)
d = Interval(8.0, 10.0)
e = Interval(-10.0, 8.0)
f = Interval(1.0, 2.0)

# Dictionary to hold the vector of relative precision intervals for each benchmark
RELPREC = Dict{String,Any}()

# Dictionaries to store data and reference values
DAISY = Dict{String,Any}()

# load functions
include("univariate.jl")
include("multivariate.jl")

# ===============================
# Run benchmarks
# ===============================
for name in keys(DAISY)
    RESULTS[name] = BenchmarkGroup()
    RELPREC[name] = Dict()
    func = DAISY[name]["f"]
    dom = DAISY[name]["dom"]
    ref = DAISY[name]["ref"]
    for ord in [2, 5, 10]
        RESULTS[name]["order $ord"] = BenchmarkGroup()
        RELPREC[name]["order $ord"] = Dict()

        RESULTS[name]["order $ord"]["Taylor Model subs."] = @benchmarkable enclose($func, $dom,
                                                                                   :TaylorModels,
                                                                                   order=($ord),
                                                                                   normalize=false)
        RELPREC[name]["order $ord"]["Taylor Model subs."] = relative_precision(enclose(func, dom,
                                                                                       :TaylorModels;
                                                                                       order=ord,
                                                                                       normalize=false),
                                                                               ref)

        RESULTS[name]["order $ord"]["Normalized Taylor Model subs."] = @benchmarkable enclose($func,
                                                                                              $dom,
                                                                                              :TaylorModels,
                                                                                              order=($ord),
                                                                                              normalize=true)
        RELPREC[name]["order $ord"]["Normalized Taylor Model subs."] = relative_precision(enclose(func,
                                                                                                  dom,
                                                                                                  :TaylorModels;
                                                                                                  order=ord,
                                                                                                  normalize=true),
                                                                                          ref)

        RESULTS[name]["order $ord"]["Interval Arithmetic subs."] = @benchmarkable enclose($func,
                                                                                          $dom,
                                                                                          :IntervalArithmetic)
        RELPREC[name]["order $ord"]["Interval Arithmetic subs."] = relative_precision(enclose(func,
                                                                                              dom,
                                                                                              :IntervalArithmetic),
                                                                                      ref)
    end
end
