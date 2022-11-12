using HypothesisTestsExperimentalRedo
using Documenter

DocMeta.setdocmeta!(HypothesisTestsExperimentalRedo, :DocTestSetup, :(using HypothesisTestsExperimentalRedo); recursive=true)

makedocs(;
    modules=[HypothesisTestsExperimentalRedo],
    authors="KronosTheLate",
    repo="https://github.com/KronosTheLate/HypothesisTestsExperimentalRedo.jl/blob/{commit}{path}#{line}",
    sitename="HypothesisTestsExperimentalRedo.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://KronosTheLate.github.io/HypothesisTestsExperimentalRedo.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/KronosTheLate/HypothesisTestsExperimentalRedo.jl",
    devbranch="main",
)
