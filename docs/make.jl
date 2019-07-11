using Documenter, RangeEnclosures

makedocs(
    modules = [RangeEnclosures],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    assets = ["assets/juliareach.css"],
    sitename = "RangeEnclosures.jl",
    pages = [
        "Home" => "index.md",
        "Library" => Any[
        "Types" => "lib/types.md",
        "Methods" => "lib/methods.md"],
        "About" => "about.md"
    ],
    strict = true
)

deploydocs(
    repo = "github.com/JuliaReach/RangeEnclosures.jl.git",
)
