module Opsimath # module

using Printf

abstract type AbstractOpsimath{T} end

include("./units.jl")
include("./pyplot.jl")

end # module
