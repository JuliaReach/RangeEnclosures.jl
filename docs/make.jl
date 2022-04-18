using Documenter, RangeEnclosures, IntervalOptimisation, SumOfSquares, SDPA, TaylorModels

DocMeta.setdocmeta!(RangeEnclosures, :DocTestSetup, :(using RangeEnclosures); recursive=true)

makedocs(
    sitename = "RangeEnclosures.jl",
    modules = [RangeEnclosures],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        assets = ["assets/aligned.css"]),
    doctest = true,
    strict = true,
    pages = [
        "Home" => "index.md",
        "Library" => Any[
            "Types" => "lib/types.md",
            "Methods" => "lib/methods.md"],
        "About" => "about.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaReach/RangeEnclosures.jl.git",
    push_preview=true
)
