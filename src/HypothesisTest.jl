"""
    mutable struct HypothesisTest{T}
        H0::NullHypothesis
        test::T
        data::Vector{SummaryStats}
        level::Real
    end

A struct to hold all information required to perform a hypothesis test.
The results are computed when needed to ensure that the results never 
go out of sync with the test input.
"""
mutable struct HypothesisTest{T<:TestType}
    H0::NullHypothesis
    testtype::T
    data::Vector{SummaryStats}
    level::Real
end
HypothesisTest(H0::NullHypothesis, testtype::TestType, data::Vector{SummaryStats}, level::Real=0.95) = HypothesisTest{typeof(testtype)}(H0, testtype, data, level)
HypothesisTest(H0::NullHypothesis, testtype::TestType, data::SummaryStats, level::Real=0.95) = HypothesisTest(H0, testtype, [data], level)


"""
    reject_H0(ht::HypothesisTest)

Returns `true`` if the p-value is smaller that 1 minus the confidence level, 
and `false` if else.
"""
reject_H0(ht::HypothesisTest) = pval(ht) < 1-ht.level
export reject_H0

function show(io::IO, ht::HypothesisTest; verbose=false)
    sigdigits = verbose ? 15 : 5
    myround(x) = round(x; sigdigits)

    println(io, testname(ht))
    # Print dashes under entire printed line
    println(io, repeat('=', length(testname(ht))))

    println(io, "Results:")
    println(io, repeat('-', length("Restults:")))
    println(io, """
            Parameter of interest: $(parameter_of_interest(ht.testtype)) $(ht.H0.POI)
                   Point estimate: $(ht.H0.POI) = $(point_est(ht)|>myround)
        $(ht.level)% confidence interval: $(ht.H0.POI) ∈ $(confint(ht).|>myround)
               Null hypothesis H₀: $(ht.H0)
                          P-value: $(pval(ht)|>myround)
    Outcome with $(ht.level)% confidence: $(reject_H0(ht) ? "Reject H₀" : "Do not reject H₀")

    """)
    
    if verbose
    println(io, "Details:")
    println(io, repeat('-', length("Details:")))
    println(io, """
    Number of observations: $(sum(getfield.(ht.data, :n)))
        Degrees of freedom: $(sum(getfield.(ht.data, :n) .- 1))
            Test statistic: $(test_statistic(ht))
  Empirical standard error: $(stderror(ht))
    """)
    end
end

# This explicit verbose solution is very bad. I am not sure how best to make it good.
show(ht::HypothesisTest; verbose=true) = show(stdout, ht::HypothesisTest; verbose)

#! Use describe (owned by statsbase) to print verbose information?