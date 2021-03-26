#=- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Some Functions for Plotting via Matplotlib
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=#

export set_rcParams!, set_ticklabels!, save_pdf, save_png

# set_rcParams!(rc, PyPlot.PyDict(matplotlib."rcParams"), fontsize=14)
function set_rcParams!(rc::Function, rcParams::AbstractDict; fontsize::Int=14)
    pgfpreamble = string(
        "\\usepackage{siunitx}",
        "\\usepackage{mhchem}",
        "\\usepackage{unicode-math}",
        "\\setmainfont{XITS}",
        "\\setmathfont{XITS Math}"
    )

    rc("text", usetex=true)
    rc("font", size=fontsize)
    rc("font", family="serif")

    rc("legend", framealpha=0.)
    rc("pgf", rcfonts=false)
    rc("pgf", preamble=pgfpreamble)

    rcParams["text.latex.preamble"] = "\\usepackage{siunitx}\\usepackage{mhchem}"

    return nothing
end

set_ticklabels!(ax, ticks::AbstractRange{R}, dir::Symbol, mp) where R<:Real = set_ticklabels!(ax, ticks, ticks, dir, mp)
set_ticklabels!(ax, ticks::NTuple{N,R}, dir::Symbol, mp) where {N, R<:Real} = set_ticklabels!(ax, ticks, ticks, dir, mp)

function set_ticklabels!(ax, ticks::AbstractRange{T}, locs::AbstractRange{R}, dir::Symbol, mp) where {R<:Real, T<:Real}
    label = tick2label(ticks)

    if dir == :x
        ax.xaxis.set_major_locator(mp.ticker.MaxNLocator(length(ticks)))
        ax.xaxis.set_major_locator(mp.ticker.FixedLocator(locs))
        ax.set_xticklabels(label)
    elseif dir == :y
        ax.yaxis.set_major_locator(mp.ticker.MaxNLocator(length(ticks)))
        ax.yaxis.set_major_locator(mp.ticker.FixedLocator(locs))
        ax.set_yticklabels(label)
    elseif dir == :z
        ax.zaxis.set_major_locator(mp.ticker.MaxNLocator(length(ticks)))
        ax.zaxis.set_major_locator(mp.ticker.FixedLocator(locs))
        ax.set_zticklabels(label)
    else
        error("Invalid direction!")
    end

    return nothing
end

function set_ticklabels!(ax, ticks::NTuple{N,T}, locs::NTuple{N,R}, dir::Symbol, mp) where {N, R<:Real, T<:Real}
    label = tick2label(ticks)

    if dir == :x
        ax.xaxis.set_major_locator(mp.ticker.MaxNLocator(N))
        ax.xaxis.set_major_locator(mp.ticker.FixedLocator(locs))
        ax.set_xticklabels(label)
    elseif dir == :y
        ax.yaxis.set_major_locator(mp.ticker.MaxNLocator(N))
        ax.yaxis.set_major_locator(mp.ticker.FixedLocator(locs))
        ax.set_yticklabels(label)
    elseif dir == :z
        ax.zaxis.set_major_locator(mp.ticker.MaxNLocator(N))
        ax.zaxis.set_major_locator(mp.ticker.FixedLocator(locs))
        ax.set_zticklabels(label)
    else
        error("Invalid direction!")
    end

    return nothing
end

function tick2label(ticks::AbstractRange{Int})
    label = Vector{String}(undef, length(ticks))

    @inbounds @simd for i in eachindex(ticks)
        label[i] = string(ticks[i])
    end

    return label
end

function tick2label(ticks::AbstractRange{T}) where T<:Real
    label = Vector{String}(undef, length(ticks))

    @inbounds @simd for i in eachindex(ticks)
        label[i] = @sprintf("%.1f", ticks[i])
    end

    return label
end

function tick2label(ticks::NTuple{N,Int}) where N
    if @generated
        e = Expr(:vect); a = Vector{Any}(undef, N)

        @inbounds for i in eachindex(a)
            a[i] = :(string(ticks[$i]))
        end

        e.args = a

        return quote
            $(Expr(:meta, :inline))
            @inbounds return $e
        end
    else
        label = Vector{String}(undef, N)

        @inbounds @simd for i in eachindex(ticks)
            label[i] = string(ticks[i])
        end

        return label
    end
end

function tick2label(ticks::NTuple{N,T}) where {N, T<:Real}
    if @generated
        e = Expr(:vect); a = Vector{Any}(undef, N)

        @inbounds for i in eachindex(a)
            a[i] = :(@sprintf("%.1f", ticks[$i]))
        end

        e.args = a

        return quote
            $(Expr(:meta, :inline))
            @inbounds return $e
        end
    else
        label = Vector{String}(undef, N)

        @inbounds @simd for i in eachindex(ticks)
            label[i] = @sprintf("%.1f", ticks[i])
        end

        return label
    end
end

save_pdf(f::String, fig) = fig.savefig(f, format="pdf", dpi=600, backend="pgf")
save_png(f::String, fig) = fig.savefig(f, format="png", dpi=600, backend="pgf")
