using Documenter, RangeEnclosures, DocumenterCitations

include("init.jl")

bib = CitationBibliography(joinpath(@__DIR__, "src", "refs.bib"); style=:alpha)

makedocs(; sitename="RangeEnclosures.jl",
         modules=[RangeEnclosures],
         format=Documenter.HTML(; prettyurls=get(ENV, "CI", nothing) == "true",
                                assets=["assets/aligned.css", "assets/citations.css"]),
         doctest=false,
         plugins=[bib],
         pagesonly=true,
         pages=["Home" => "index.md",
                "Tutorial" => "tutorial.md",
                "Library" => Any["Types" => "lib/types.md",
                                 "Methods" => "lib/methods.md"],
                "Bibliography" => "bibliography.md",
                "About" => "about.md"])

deploydocs(; repo="github.com/JuliaReach/RangeEnclosures.jl.git",
           push_preview=true)
