export Atom, vectorize

struct Atom{T} <: AbstractElement{T}
    e::Symbol; x::T; y::T; z::T
    Atom(e::Symbol, p::NTuple{3, T}) where T<:Real = new{T}(e, p[1], p[2], p[3])
end

# @code_warntype ✓
Base.getindex(tup::NTuple{N, Atom}, idx::Int, dir::Symbol) where N = getproperty(tup[idx], dir)
Base.getproperty(a::Atom, s::Symbol) = s ≡ :x ? getfield(a, :x) : s ≡ :y ? getfield(a, :y) : s ≡ :z ? getfield(a, :z) : error("Invalid :$s.")

# @code_warntype
vectorize(a::Atom) = (a.x,), (a.y,), (a.z,)
vectorize(a::Atom{T}, b::Atom{T}) where T<:Real = (a.x, b.x), (a.y, b.y), (a.z, b.z)

function vectorize(tup::NTuple{N, Atom}) where N
    if @generated
        tupX = Expr(:tuple)
        tupY = Expr(:tuple)
        tupZ = Expr(:tuple)
        argX = Vector{Expr}(undef, N)
        argY = Vector{Expr}(undef, N)
        argZ = Vector{Expr}(undef, N)

        @inbounds for i in 1:N
            argX[i] = :(tup[$i, :x])
            argY[i] = :(tup[$i, :y])
            argZ[i] = :(tup[$i, :z])
        end

        tupX.args = argX
        tupY.args = argY
        tupZ.args = argZ

        return quote
            $(Expr(:meta, :inline))
            @inbounds return ($tupX, $tupY, $tupZ)
        end
    else
        tupX = ntuple(i -> tup[i, :x], N)
        tupY = ntuple(j -> tup[j, :y], N)
        tupZ = ntuple(k -> tup[k, :z], N)
        return tupX, tupY, tupZ
    end
end
