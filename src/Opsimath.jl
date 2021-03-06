module Opsimath # module

using Printf

abstract type AbstractOpsimath{T} end

include("./units.jl")
include("./pyplot.jl")
include("./materials/materials.jl")
include("./spectra/spectra.jl")

end # module
