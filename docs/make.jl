using Documenter, RangeEnclosures

DocMeta.setdocmeta!(RangeEnclosures, :DocTestSetup, :(using RangeEnclosures); recursive=true)

makedocs(
    sitename = "RangeEnclosures.jl",
    modules = [RangeEnclosures],
    format = Documenter.HTML(prettyurls=haskey(ENV, "GITHUB_ACTIONS")),
    doctest = false,
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
