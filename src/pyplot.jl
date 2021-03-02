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

function set_ticklabels!(ax, ticks::AbstractRange{T}, locs::AbstractRange{R}, dir::Symbol, mp) where {R<:Real, T<:Real}
    label = Vector{String}(undef, length(ticks)); _tick2label!(label, ticks)

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

function _tick2label!(label::Vector{String}, ticks::AR) where AR<:AbstractRange{Int}
    @inbounds @simd for i in eachindex(ticks)
        label[i] = string(ticks[i])
    end
    return nothing
end

function _tick2label!(label::Vector{String}, ticks::AR) where AR<:AbstractRange{Float64}
    @inbounds @simd for i in eachindex(ticks)
        label[i] = @sprintf("%.1f", ticks[i])
    end
    return nothing
end

save_pdf(f::String, fig) = fig.savefig(f, format="pdf", dpi=600, bbox_inches="tight", backend="pgf")
save_png(f::String, fig) = fig.savefig(f, format="png", dpi=600, bbox_inches="tight", backend="pgf")
