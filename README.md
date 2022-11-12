# HypothesisTestsExperimentalRedo

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://KronosTheLate.github.io/HypothesisTestsExperimentalRedo.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://KronosTheLate.github.io/HypothesisTestsExperimentalRedo.jl/dev/)
[![Build Status](https://github.com/KronosTheLate/HypothesisTestsExperimentalRedo.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/KronosTheLate/HypothesisTestsExperimentalRedo.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/KronosTheLate/HypothesisTestsExperimentalRedo.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/KronosTheLate/HypothesisTestsExperimentalRedo.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

# Why does this repository exsist
This is an experimental attempt to redo hypothesis-testing in Julia. The main motivation is to have the null-hypothesis included in the test (as opposed to only having two-sided tests, and having to explicitly call pval and confint with certain argument for onesided or non-95% tests). The way it is implemented in this package, the user never has to think about what "left" and "right" mean for confint and pval, but use inequality operators (<, >, ≥, ≤) directly.

Other features includes easy computation of the distribution under the null hypothesis, the distribution indicated by the data, no internal use of test-statistics, and a very modular internal API that I believe could help reduce internal boilerplate. I am not sure if this is fixing a non-existing problem, but it could be neat in any case.

There is also a plan to make everything plottable, to make the concepts of hypothesis 
testing easier to understand. See the example in "demo.jl" for a first draft of the 
plotting made possible by re-using the flexible internal API.

There is no desire for competing HypothesisTests packages. The hope is that whatever value is in this project could be ported to HypothesisTesting.jl.

Below is the output from running the contents of "src/demo.jl" (expect for the plot)

```
julia> using HypothesisTestsExperimentalRedo

julia> obs = rand(100) .+ 1;

julia> ttest(obs)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.4897
    0.95% confidence interval: μ₀ ∈ (1.433, 1.5464)
           Null hypothesis H₀: μ₀ = 0
                      P-value: 0.0
Outcome with 0.95% confidence: Reject H₀




julia> ttest(obs, 1.57)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.4897
    0.95% confidence interval: μ₀ ∈ (1.433, 1.5464)
           Null hypothesis H₀: μ₀ = 1.57
                      P-value: 0.0059614
Outcome with 0.95% confidence: Reject H₀




julia> ttest(obs, >, 1.57)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.4897
    0.95% confidence interval: μ₀ ∈ (1.4422, Inf)
           Null hypothesis H₀: μ₀ > 1.57
                      P-value: 0.0029807
Outcome with 0.95% confidence: Reject H₀




julia> ht = ttest(obs, <, 1.57)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.4897
    0.95% confidence interval: μ₀ ∈ (-Inf, 1.5371)
           Null hypothesis H₀: μ₀ < 1.57
                      P-value: 0.99702
Outcome with 0.95% confidence: Do not reject H₀




julia> show(ht, verbose=true)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.48967548990093
    0.95% confidence interval: μ₀ ∈ (-Inf, 1.53712856768824)
           Null hypothesis H₀: μ₀ < 1.57
                      P-value: 0.997019289738684
Outcome with 0.95% confidence: Do not reject H₀


Details:
--------
  Number of observations: 100
      Degrees of freedom: 99
          Test statistic: -2.8105680895492147
Empirical standard error: 0.02857945708475962
  

julia> confint(ht)
(-Inf, 1.5371285676882354)

julia> point_est(ht)
1.4896754899009335

julia> pval(ht)
0.9970192897386843
```