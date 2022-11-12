
"""
NullHypothesis(POI, operator, value)
NullHypothesis(operator, value)

A struct to hold a null hypothesis. 
`POI` can be a string or a symbol, and represents the P̲arameter O̲f I̲nterest.
It defaults to "POI", but should be set to something to convey information 
about what the parameter of interest represents, e.g. "μ₀" when the sample 
mean is being tested.

Fieldnames:
* POI: Only important for pretty printing.
* operator: Determines if the test is one or two sided, and to which side.
* value: The value that is compared with the parameter of interest.

# Examples
```jldoctest
julia> NullHypothesis(≤, 50)
POI ≤ 50

julia> NullHypothesis(>=, 50)
POI ≥ 50

julia> NullHypothesis("μ₀", >, 50)
μ₀ > 50

julia> NullHypothesis(:μ₀, ==, 50)
μ₀ = 50
```
"""
mutable struct NullHypothesis
POI::String
operator::Function
value::Real
function NullHypothesis(POI, operator, value)  # Constructor with some type check for helpful errors
    operator isa Function || TypeError(:NullHypothesis, "in the second argument `operator`", Function, operator)|>throw
    operator isa Union{typeof.((>, ≥, ==, ≤, <))...} || TypeError(:NullHypothesis, "in the second argument `operator`", Union{typeof.((>, ≥, ==, ≤, <))...}, operator)|>throw
    new(POI, operator, value)
end
end

# NullHypothesis(POI::Union{Symbol, String}, operator::Union{typeof(>), typeof(≥), typeof(==), typeof(<), typeof(≤)}, value::Real) = NullHypothesis(POI, operator, value)
NullHypothesis(value::Real) = NullHypothesis("POI", ==, value)
NullHypothesis(operator::Function, value::Real) = NullHypothesis("POI", operator, value)
NullHypothesis(POI::Symbol, operator::Function, value::Real) = NullHypothesis(String(POI), operator, value)

show(io::IO, H0::NullHypothesis) = print(io, string(H0.POI, " ", replace(string(H0.operator), "<="=>"≤", ">="=>"≥", "=="=>"="), " ", H0.value))