#=- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Optical Pump Probe (OPP) Spectroscopy Data Structures
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=#

export TimeDelay, DiffReflect

struct TimeDelay{T} <: AbstractSpectra{T}
    td::Vector{T}

    TimeDelay(td::Vector{T}) where T<:Real = new{T}(td)

    function TimeDelay(pth::String)
        raw = readdlm(pth); nrow, ncol = size(raw); T = eltype(raw)

        if !isone(ncol)
            error("Strange TimeDelay data file of ncol = $ncol")
        end

        td = Vector{T}(undef, nrow)

        @inbounds @simd for i in eachindex(td)
            td[i] = raw[i]
        end

        return TimeDelay(td)
    end
end

struct DiffReflect{N,T,S} <: AbstractSpectra{T}
    ΔR::Matrix{T}; spec::NTuple{N, S}

    DiffReflect(ΔR::Matrix{T}, spec::NTuple{N,S}) where {N,T<:Real,S} = new{N,T,S}(ΔR, spec)

    function DiffReflect(pth::String, spec::NTuple{N,S}; ifnorm::Bool=true) where {N,S}
        ΔR = readdlm(pth)

        if ifnorm
            nrow, ncol = size(ΔR)
            @inbounds begin
                for j in 1:ncol
                    abs_minΔR = abs(minimum(view(ΔR, :, j)))
                    @simd for i in 1:nrow
                        ΔR[i, j] /= abs_minΔR
                    end
                end
            end
        end

        return DiffReflect(ΔR, spec)
    end
end
