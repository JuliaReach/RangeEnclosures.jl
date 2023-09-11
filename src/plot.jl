# adapted from
# https://github.com/JuliaIntervals/IntervalArithmetic.jl/blob/v0.20.9/src/plot_recipes/plot_recipes.jl

using RecipesBase

@recipe function f(xx::AbstractVector{<:Interval})
    @assert length(xx) == 2 "can only plot 2-dimensional interval boxes"

    (x, y) = xx

    seriesalpha --> 0.5
    seriestype := :shape

    x = [x.lo, x.hi, x.hi, x.lo]
    y = [y.lo, y.lo, y.hi, y.hi]

    x, y
end

@recipe function f(v::AbstractVector{<:AbstractVector{<:Interval}})

    seriestype := :shape

    xs = Float64[]
    ys = Float64[]

    for xx in v
        @assert length(xx) == 2 "can only plot 2-dimensional interval boxes"
        (x, y) = xx

        # use NaNs to separate
        append!(xs, [x.lo, x.hi, x.hi, x.lo, NaN])
        append!(ys, [y.lo, y.lo, y.hi, y.hi, NaN])

    end

    seriesalpha --> 0.5

    xs, ys
end
