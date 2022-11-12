
"""
SummaryStats(x::Vector{<:Real})
SummaryStats(n, mean, std)

A struct to hold the summary statistics about a sample 
required to perform statistical hypothesis tests.

Fieldnames:
* n: \tnumber of samples  
* mean: \tthe sample mean  
* std: \tthe sample standard deviation  

# Examples:
```jldoctest
julia> ss = SummaryStats(randn(100))
Summary Statistics for 100 observations: 
------------------------------
Sample mean = -0.01349895434299083
Sample std dev = 1.0247055651499521


julia> ss.n, ss.mean, ss.std
(100, -0.01349895434299083, 1.0247055651499521)

julia> SummaryStats(100, 10, 0.5)
Summary Statistics for 100 observations:
------------------------------
Sample mean = 10
Sample std dev = 0.5
```
"""
mutable struct SummaryStats
n::Int                 # number of observations
mean::Float64          # estimated mean
std::Float64           # estimated standard deviation
end
SummaryStats(x::Vector{<:Real}) = SummaryStats(length(x), mean(x), std(x))

function show(io::IO, ss::SummaryStats)
println(io, """Summary statistics for $(ss.n) observations: 
$("-"^30)
   Sample mean = $(ss.mean)
Sample std dev = $(ss.std)"""
)
end

import StatsAPI: stderror
stderror(ss::SummaryStats) = ss.std/√ss.n

import Statistics: mean, std, var
mean(ss::SummaryStats) = ss.mean
std(ss::SummaryStats) = ss.std
var(ss::SummaryStats) = ss.std^2


import StatsBase: dof
"""
    dof(ss::SummaryStats) = ss.n-1
    dof(data::Vector{SummaryStats}) = sum(dof, data)
"""
dof(ss::SummaryStats) = ss.n-1
dof(data::Vector{SummaryStats}) = sum(dof, data)