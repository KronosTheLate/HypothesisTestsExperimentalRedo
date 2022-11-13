"""
    ZTest(OneSample(false))
    ZTest(OneSample(true))
    ZTest(TwoSample(false))
    ZTest(TwoSample(true))

A struct used to specify that a Z-test should be performed.
There are 2 types of Z-test:
OneSample - for testing a hypothesis regarding the mean of a single dataset
TwoSample - for testing a hypothesis regarding the mean difference of two datasets

For a OneSample test, the boolean argument specifies if the test is paired.
For a TwoSample test, the boolean argument specifies if equal variance should be assumed.
"""
mutable struct ZTest{T} <: TestType #! Add type constraint on T?
    testtype::T
end
ZTest(testvariant::Union{OneSample, TwoSample}) = ZTest{typeof(testvariant)}(testvariant)
parameter_of_interest(x::ZTest) = "Mean"

checktest(ht::HypothesisTest{ZTest{OneSample}}) = length(ht.data) == 1  ? ht : error("Tried to construct a OneSample Z-test, which requires 1 dataset. $(length(ht.data)) dataset(s) were given")
checktest(ht::HypothesisTest{ZTest{TwoSample}}) = length(ht.data) == 2  ? ht : error("Tried to construct a TwoSample Z-test, which requires 2 datasets. $(length(ht.data)) dataset(s) were given")

testname(test::ZTest{OneSample}) = test.testtype.paired ? "Paired Z-test" : "One-sample Z-test"
#TODO Does the following line make sense?
testname(test::ZTest{TwoSample}) = test.testtype.equalvariance ? "Two sample Z-test assuming equal variance" : "Two sample Z-test not assuming equal variance"

point_est(::TTest{OneSample}, data::Vector{SummaryStats}) = data[1].mean
point_est(::TTest{TwoSample}, data::Vector{SummaryStats}) = data[1].mean - data[2].mean

test_statistic(ht::HypothesisTest{<:ZTest}) = (point_est(ht)-ht.H0.value)/stderror(only(ht.data))

stderror(ht::HypothesisTest{ZTest{OneSample}}) = stderror(only(ht.data))
stderror(ht::HypothesisTest{ZTest{TwoSample}}) = hypot(stderror(ht.data[1]), stderror(ht.data[2]))

#* ToDo - add "Assumptions or notes" column from wikipedia

function dist_under_H0(H0::NullHypothesis, ::ZTest{OneSample}, data::Vector{SummaryStats})
    ss = data|>only
    dist_normalized = Normal()
    return dist_normalized * stderror(ss) + H0.value
end

#TODO T -> Z completed up until here. The following is invalid for ZTest, but taken from TTest and used as a template.

function dist_under_H0(H0::NullHypothesis, testtype::TTest{TwoSample}, data::Vector{SummaryStats})
    ss1, ss2 = data
    if testtype.equalvariance
        sₚ = sqrt(/(dof(ss1)*ss1.std^2 + dof(ss2)*ss2.std^2, dof(data)))
        scale_factor = sₚ * sqrt(1 / ss1.n + 1 / ss2.n)
        dist_normalized = TDist(dof(data))
    else
        scale_factor = sqrt(ss1.std^2 / ss1.n + ss2.std^2 / ss2.n)
        dist_normalized = TDist((ss1.std^2/ss1.n + ss2.std^2/ss2.n)^2 / ((ss1.std^2/ss1.n)^2 / dof(ss1) + (ss2.std^2/ss2.n)^2 / dof(ss2)))
    end
    return dist_normalized * scale_factor +  H0.value
end

dist_apparent(ht::HypothesisTest{<:TTest}) = dist_under_H0(ht) - ht.H0.value + point_est(ht)



#! Add convenience constructors meant for the public here
"""
    ttest(obs::Vector{<:Real}, μ₀=0; kwargs...)
    ttest(obs::Vector{<:Real}, op, μ₀=0; kwargs...)

Test the null-hypothesis that the mean of the observations 
is equal to μ₀, against the alternative hypothesis that it is not.

To perform a one-sided test, set `op` to one of (`>`, `≥`, `≤` or `<`).

A paired one-sample t-test is equivalent to a normal one-sample t-test 
of the elementwise difference between the datasets (dataset1 .- dataset2).
To perform such a test, give dataset1 .- dataset2 as the observations, and 
set the keyword argument `paired` to true to reflect this in the printing.
"""
function ttest(obs::Vector{<:Real}, op::Function, H0_value::Real = 0; paired=false, level=0.95)
    H0 = NullHypothesis(:μ₀, op, H0_value)
    ttype = TTest(OneSample(paired))
    ss = SummaryStats(obs)
    return HypothesisTest(H0, ttype, ss)
end
ttest(obs::Vector{<:Real}, H0_value::Real = 0; paired=false, level=0.95) = ttest(obs, ==, H0_value; paired, level)
export ttest
# The reason not to define ttest(obs1::Vector{<:Real}, obs2::Vector{<:Real}, paired=true) is because then you need arguments for paired and equalvariance, which is a mess.

"""
    ttest(obs1::Vector{<:Real}, obs2::Vector{<:Real}, Δμ₀=0; kwargs...)

Test the null-hypothesis that the difference between the observation means
(mean(obs1)-mean(obs2)) is equal to Δμ₀, against the alternative hypothesis 
that it is not.

To perform a one-sided test, set `op` to one of (`>`, `≥`, `≤` or `<`).

The keyword argument `equalvariance::Bool` determines if equal variance 
between the underlying distributions should be assumed.
"""
function ttest(obs1::Vector{<:Real}, obs2::Vector{<:Real}, op::Function, H0_value::Real = 0; equalvariance::Bool, level=0.95)
    H0 = NullHypothesis(:μ₀, op, H0_value)
    ttype = ismissing(var) ? TTest(OneSample(false)) : TTest(OneSample(false))
    return HypothesisTest(H0, ttype, ss)
end
ttest(obs1::Vector{<:Real}, obs2::Vector{<:Real}, H0_value::Real = 0; equalvariance::Bool, level=0.95) = ttest(obs1, obs2, ==, H0_value; equalvariance, level)
