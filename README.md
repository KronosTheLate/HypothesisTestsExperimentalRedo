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
ttest(obs, 1.57)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.5449
    0.95% confidence interval: μ₀ ∈ (1.4893, 1.6006)
           Null hypothesis H₀: μ₀ = 0
                      P-value: 0.0
Outcome with 0.95% confidence: Reject H₀




julia> ttest(obs, 1.57)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.5449
    0.95% confidence interval: μ₀ ∈ (1.4893, 1.6006)
           Null hypothesis H₀: μ₀ = 1.57
                      P-value: 0.37396
Outcome with 0.95% confidence: Do not reject H₀




julia> ttest(obs, >, 1.57)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.5449
    0.95% confidence interval: μ₀ ∈ (1.4984, Inf)
           Null hypothesis H₀: μ₀ > 1.57
                      P-value: 0.18698
Outcome with 0.95% confidence: Do not reject H₀




julia> ht = ttest(obs, <, 1.57)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.5449
    0.95% confidence interval: μ₀ ∈ (-Inf, 1.5915)
           Null hypothesis H₀: μ₀ < 1.57
                      P-value: 0.81302
Outcome with 0.95% confidence: Do not reject H₀




julia> show(ht, verbose=true)
One-sample T-test
=================
Results:
---------
        Parameter of interest: Mean μ₀
               Point estimate: μ₀ = 1.54494649549398
    0.95% confidence interval: μ₀ ∈ (-Inf, 1.59152326204613)
           Null hypothesis H₀: μ₀ < 1.57
                      P-value: 0.813020449049503
Outcome with 0.95% confidence: Do not reject H₀


Details:
--------
  Number of observations: 100
      Degrees of freedom: 99
          Test statistic: -0.89311947540293
Empirical standard error: 0.028051683112960996
  

julia> confint(ht)
(-Inf, 1.5915232620461348)

julia> point_est(ht)
1.544946495493983

julia> pval(ht)
0.8130204490495032
```

As for the plotting mentioned, the block below provides a first look at something to the effect I imagine:
```
julia> using GLMakie

julia> let ht = ttest(obs, 1.57)
           acceptance_region_limits = confint(ht.H0, dist_under_H0(ht), level=ht.level)
           global fig = Figure()
           ax = Axis(fig[1, 1], xlabel="Value", ylabel="Probability density", title="""Visualized $(HypothesisTestsExperimentalRedo.testname(ht))\nOutcome: $(reject_H0(ht) ? "Reject H₀" : "Do not reject H₀" )""")
           colors = Makie.current_default_theme().palette.color.val
           lines!(ax, dist_under_H0(ht), label="Dist under H₀")
           lines!(ax, dist_apparent(ht), label="Dist apparent")
           vlines!(ax, [ht.H0.value], color=Cycled(1), linestyle=:dash, label="Value of $(ht.H0.POI) under H₀")
           vlines!(ax, [point_est(ht)], color=Cycled(2), linestyle=:dash, label="Point estimate")
           autolimits!(ax)  # needed to set the plot limits by content
           actual_xaxis_limit = (ax.finallimits.val.origin[1], ax.finallimits.val.origin[1]+ax.finallimits.val.widths[1])
           
           function adjust_inf_limits(input_xlims::Tuple{Float64, Float64})
               output_xlim_lower = input_xlims[1]<actual_xaxis_limit[1] ? actual_xaxis_limit[1] : input_xlims[1]
               output_xlim_upper = input_xlims[2]>actual_xaxis_limit[2] ? actual_xaxis_limit[2] : input_xlims[2]
               return (output_xlim_lower, output_xlim_upper)
           end
           vspan!(ax, adjust_inf_limits(acceptance_region_limits)..., color=(colors[1], 0.15), label="$(ht.level*100)% acceptance region")
           vspan!(ax, adjust_inf_limits(confint(ht))..., color=(colors[2], 0.15), label="$(ht.level*100)% conf int")
           Legend(fig[1, 2], ax)
           current_figure()|>display
       end
```
Which produces the following image:
