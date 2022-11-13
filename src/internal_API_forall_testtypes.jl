# The functions in this file are those that must 
# be implemented for new test types

# In general, these functions will only require some 
# fields of an instance of HypothesisTest, and 
# that "unpacking" is generically defined here.
# Therefore, each test should only define the version 
# that takes exacly what it needs, and the generic "unpacking" 
# should call that specific version in all cases.

"""
    dist_under_H0(H0::NullHypothesis, testtype::TestType, data::Vector{SummaryStats})
    dist_under_H0(ht::HypothesisTest)

For any test, compute the distribution under the null-hypothesis. 
Used to compared to the point-estimate to get p-values.
This package deals only with the actual distributions, and does at no point use normalized ditributions.
"""
dist_under_H0(H0::NullHypothesis, testtype::TestType, data::Vector{SummaryStats}) = "Function `dist_under_H0` not implemented for test-type $(typeof(ht.testtype))"  # Generic fallback. dist_under_H0 is to be implemented by each test type
dist_under_H0(ht::HypothesisTest) = dist_under_H0(ht.H0, ht.testtype, ht.data)
export dist_under_H0

"""
    dist_apparent(H0::NullHypothesis, testtype::TestType, data::Vector{SummaryStats})
    dist_apparent(ht::HypothesisTest)

For any test, compute the distribution indicated by the data samples.

If the test-type is e.g. a t-test, then the apparent distribution 
will the the scaled and shifted TDist that best corresponds to the data.
"""
dist_apparent(H0::NullHypothesis, testtype::TestType, data::Vector{SummaryStats}) = "Function `dist_apparent` not implemented for test-type $(typeof(ht.testtype))"  # Generic fallback. dist_under_H0 is to be implemented by each test type
dist_apparent(ht::HypothesisTest) = dist_apparent(ht.H0, ht.testtype, ht.data)
export dist_apparent

"""
    checktest(ht::HypothesisTest)

A function that takes a HypothesisTest and returns it if all tests are passed.
Test are defined for each testtype. This function should be used for the convenience-constructurs, 
for the public API
"""
checktest(ht::HypothesisTest) = ht  # Not all test types require checks, which is why the fallback is premissive.

"""
    parameter_of_interest(x)

Return the parameter of interest (as an english word, e.g. mean).
Used internally for printing test results.
"""
parameter_of_interest(ht::HypothesisTest) = "Function `parameter_of_interest` not implemented for test-type $(typeof(ht.testtype))"  # generic fallback

"""
    testname(ht::HypothesisTest) = testname(ht.testtype)

Return the name for a test. Used internally for printing test results.
"""
testname(testtype) = "Function `testname` not implemented for test-type $(typeof(ht.testtype))"  # generic fallback
testname(ht::HypothesisTest) = testname(ht.testtype)

"""
    test_statistic(ht::HypothesisTest)

Return the test statistic of a given hypothesis test `ht`.
"""
test_statistic(ht::HypothesisTest) = "Function `test_statistic` not implemented for test-type $(typeof(ht.testtype))"  # generic fallback
export test_statistic

testname(ht::HypothesisTest) = "Function `testname` not implemented for test-type $(typeof(ht.testtype))"  # generic fallback


"""
    point_est(testtype::TestType, data::Vector{SummaryStats})
    point_est(ht::HypothesisTest)

Return the point estimate of a given test.
"""
point_est(testtype::TestType, data::Vector{SummaryStats}) = "Function `point_est` not implemented for test-type $(typeof(ht.testtype))"  # generic fallback
point_est(ht::HypothesisTest) = point_est(ht.testtype, ht.data)
export point_est

# stderror will be extended by test types
import StatsAPI: stderror