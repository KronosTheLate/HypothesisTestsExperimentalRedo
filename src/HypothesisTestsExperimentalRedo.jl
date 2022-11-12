module HypothesisTestsExperimentalRedo

# using Revise
using Distributions
# using StatsAPI
import Base: show
include("NullHypothesis.jl")
include("SummaryStats.jl")

abstract type TestType end  # Supertype for all test types, e.g. TTest, ZTest etc

include("HypothesisTest.jl")
include("internal_API_forall_testtypes.jl")

begin # OneSample, TwoSample
    #? I do not know if other tests use OneSample, or other test-variants.
    #? It might make sense to define TestVariant as a supertype for OneSample and TwoSample
    """
        OneSample(paired::Bool)

    A test variant that indicates that a single dataset is to be tested.

    An instance of `OneSample` is passed to the relevant test (e.g. TTest).
    The relevant test is then passed to a `HypothesisTest`.

    The aargument `paired` determines if the test is interpreted as paired.
    """
    struct OneSample
        paired::Bool
    end

    """
        TwoSample(equalvariance::Bool)

    A test variant that indicates that the difference between two datasets is to be tested.

    An instance of `OneSample` is passed to the relevant test (e.g. TTest).
    The relevant test is then passed to a `HypothesisTest`.

    The argument `equalvariance` determines if equal variance should be assumed.
    """
    mutable struct TwoSample
        equalvariance::Bool
    end
end

begin # confint, pval
    import StatsBase: confint

    """
        confint(H0::NullHypothesis, dist::Distribution; level::Real)
        confint(ht::HypothesisTest)
    """
    function confint(H0::NullHypothesis, dist::Distribution; level::Real)
        if H0.operator == (==)
            quantile_ = (1-level)/2
            return quantile(dist, quantile_), quantile(dist, 1-quantile_)
        elseif H0.operator ∈ (>, ≥, >=)
            return quantile(dist, 1-level), Inf
        elseif H0.operator ∈ (<, ≤, <=)
            return -Inf, quantile(dist, level)
        else
            error("The operator of the NullHypothesis `H0` is $(H0.operator), expected one of >, ≥, >=, ==, <=, ≤, <")
        end
    end
    confint(ht::HypothesisTest) = confint(ht.H0, dist_apparent(ht); level=ht.level)
    export confint

    """
        pval(H0::NullHypothesis, dist::Distribution, pointestimate::Real)
        pval(ht::HypothesisTest)
    """
    function pval(H0::NullHypothesis, dist::Distribution, pointestimate::Real) 
        if H0.operator == (==)
            2*min(cdf(dist, pointestimate), 1-cdf(dist, pointestimate)) # From wikipedia
        elseif H0.operator ∈ (>, ≥, >=)
            return cdf(dist, pointestimate)
        elseif H0.operator ∈ (<, ≤, <=)
            return 1 - cdf(dist, pointestimate)
        else
            error("The operator of the `NullHypothesis` is $(H0.operator).\nExpected one of >, ≥, >=, ==, <=, ≤, <")
        end
    end
    pval(ht::HypothesisTest) = pval(ht.H0, dist_under_H0(ht), point_est(ht))
    export pval
end

## Files that implement a specific test:
include("TTest.jl")

end
