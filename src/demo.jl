################?   DEMO, copy this into a mock-about script   ########################?
using HypothesisTestsExperimentalRedo
obs = rand(100) .+ 1

ttest(obs)
ttest(obs, 1.57)
ttest(obs, 1.57)
ttest(obs, <, 1.57)



confint(ttest(obs))
point_est(ttest(obs))
pval(ttest(obs))

using GLMakie; Makie.inline!(true)
let ht = hypottest
    acceptance_region_limits = confint(ht.H0, dist_under_H0(ht), level=ht.level)

    fig = Figure()
    ax = Axis(fig[1, 1], xlabel="Value", ylabel="Probability density", title="""Visualized $(testname(ht))\nOutcome: $(reject_H0(ht) ? "Reject H₀" : "Do not reject H₀" )""")
    colors = Makie.current_default_theme().palette.color.val
    lines!(ax, dist_under_H0(ht), label="Dist under H₀")
    lines!(ax, dist_apparent(ht), label="Dist apparent")
    vlines!(ax, [ht.H0.value], color=Cycled(1), linestyle=:dash, label="Value of $(ht.H0.POI) under H₀")
    vlines!(ax, [point_est(ht)], color=Cycled(2), linestyle=:dash, label="Point estimate")

    autolimits!(ax)  # needed to set the plot limits by content
    actial_xaxis_limit = (ax.finallimits.val.origin[1], ax.finallimits.val.origin[1]+ax.finallimits.val.widths[1])
    
    function adjust_inf_limits(input_xlims::Tuple{Float64, Float64})
        output_xlim_lower = input_xlims[1]<actial_xaxis_limit[1] ? actial_xaxis_limit[1] : input_xlims[1]
        output_xlim_upper = input_xlims[2]>actial_xaxis_limit[2] ? actial_xaxis_limit[2] : input_xlims[2]
        return (output_xlim_lower, output_xlim_upper)
    end
    vspan!(ax, adjust_inf_limits(acceptance_region_limits)..., color=(colors[1], 0.15), label="$(ht.level*100)% acceptance region")
    vspan!(ax, adjust_inf_limits(confint(ht))..., color=(colors[2], 0.15), label="$(ht.level*100)% conf int")
    Legend(fig[1, 2], ax)
    current_figure()|>display
end