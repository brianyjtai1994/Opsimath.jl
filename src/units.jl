#=- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Unit Conversion
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=#

export @unit_convert!

macro unit_convert!(src, from_unit::Symbol, to_unit::Symbol)
    return Expr(:call, Symbol(from_unit, "2", to_unit, "!"), esc(src))
end

#=- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Converters
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=#

thz2nj!(f::Real) = 6.626070150e-13 * f
nj2thz!(e::Real) = e / 6.626070150e-13

thz2meV!(f::Real) = 4.135667696 * f
meV2thz!(e::Real) = e / 4.135667696

nm2nj!(λ::Real) = 1.98644586e-7 / λ
nj2nm!(e::Real) = 1.98644586e-7 / e

nm2eV!(λ::Real) = 1239.84198 / λ
eV2nm!(e::Real) = 1239.84198 / e

cm⁻¹2nm!(λ::Real) = 1e7 / λ
nm2cm⁻¹!(λ::Real) = 1e7 / λ

ps2μm!(t::Real) = round(149.896225 * t)
μm2ps!(d::Real) = d / 149.896225

#=- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Vectorization
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=#

for fname! in (
        :thz2nj!, :nj2thz!, :thz2meV!, :meV2thz!,
        :nm2nj!, :nj2nm!, :nm2eV!, :eV2nm!,
        :cm⁻¹2nm!, :nm2cm⁻¹!, :ps2μm!, :μm2ps!
    )
    @eval begin
        function $(fname!)(x::AbstractArray{T}) where T<:Real
            @inbounds @simd for i in eachindex(x)
                x[i] = $(fname!)(x[i])
            end
        end
    end
end
