export Material

module Material

abstract type AbstractMaterial{T}                       end
abstract type AbstractElement{T} <: AbstractMaterial{T} end

include("atom.jl")

end

import .Material
