# HypothesisTestsExperimentalRedo

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://KronosTheLate.github.io/HypothesisTestsExperimentalRedo.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://KronosTheLate.github.io/HypothesisTestsExperimentalRedo.jl/dev/)
[![Build Status](https://github.com/KronosTheLate/HypothesisTestsExperimentalRedo.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/KronosTheLate/HypothesisTestsExperimentalRedo.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/KronosTheLate/HypothesisTestsExperimentalRedo.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/KronosTheLate/HypothesisTestsExperimentalRedo.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

# HypothesisTestsExperimentalRedo
This is an experimental attempt to redo hypothesis-testing in Julia. The main motivation is to have the null-hypothesis included in the test (as opposed to only having two-sided tests, and having to explicitly call pval and confint with certain argument for onesided or non-95% tests). The way it is implemented in this package, the user never has to think about what "left" and "right" mean for confint and pval, but use inequality operators (<, >, ≥, ≤) directly.

Other features includes easy computation of the distribution under the null hypothesis, the distribution indicated by the data, no internal use of test-statistics, and a very modular internal API that I believe could help reduce internal boilerplate. I am not sure if this is fixing a non-existing problem, but it could be neat in any case.

There is also a plan to make everything plottable, to make the concepts of hypothesis 
testing easier to understand. See the example in "demo.jl" for a first draft of the 
plotting made possible by re-using the flexible internal API.

There is no desire for competing HypothesisTests packages. The hope is that whatever value is in this project could be ported to HypothesisTesting.jl.