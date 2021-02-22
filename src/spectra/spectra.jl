export Spectra

module Spectra

using DelimitedFiles

abstract type AbstractSpectra{T} end

include("./opp.jl")

end

import .Spectra
