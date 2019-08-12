using Documenter, RangeEnclosures

DocMeta.setdocmeta!(RangeEnclosures, :DocTestSetup, :(using RangeEnclosures); recursive=true)

makedocs(
    sitename = "RangeEnclosures.jl",
    modules = [RangeEnclosures],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
                             assets = ["assets/juliareach.css"]),
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
