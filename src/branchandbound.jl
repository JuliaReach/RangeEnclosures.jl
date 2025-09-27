# univariate case
@inline function enclose(f::Function, dom::Interval, bab::BranchAndBoundEnclosure;
                         df=Base.Fix1(ForwardDiff.derivative, f))
    return _branch_bound(bab, f, dom, df)
end

# multivariate case
@inline function enclose(f::Function, dom::AbstractVector{<:Interval}, bab::BranchAndBoundEnclosure;
                         df=t -> ForwardDiff.gradient(f, t))
    return _branch_bound(bab, f, dom, df)
end

@inline function enclose(f::Function, dom::IntervalBox, bab::BranchAndBoundEnclosure;
                         df=t -> ForwardDiff.gradient(f, t.v))
    return _branch_bound(bab, f, dom, df)
end

function _branch_bound(bab::BranchAndBoundEnclosure, f::Function,
                       dom::Interval_or_IntervalVector_or_IntervalBox, df;
                       initial=emptyinterval(first(dom)),
                       cnt=1)
    dfD = df(dom)
    range_extrema, flag = _monotonicity_check(f, dom, dfD)
    flag && return hull(range_extrema, initial)

    fX = f(dom)  # TODO: allow user to choose how to evaluate this (mean value, natural enclosure)
    # if tolerance or maximum number of iteration is met, return current enclosure
    if diam(fX) <= bab.tol || cnt == bab.maxdepth
        return hull(fX, initial)
    end

    X1, X2 = _bisect(dom)
    y1 = _branch_bound(bab, f, X1, df; initial=initial, cnt=cnt + 1)
    return _branch_bound(bab, f, X2, df; initial=y1, cnt=cnt + 1)
end

function _bisect(dom)
    return bisect(dom)
end

function _bisect(dom::AbstractVector{<:Interval})
    i = argmax(diam.(dom))  # find longest side
    α = IntervalBoxes.where_bisect  # heuristic from IntervalBoxes
    return bisect(dom, i, α)
end

function _monotonicity_check(f::Function, dom::Interval, dfD::Interval)
    if inf(dfD) >= 0 || sup(dfD) <= 0  # monotone function, evaluate at extrema
        lo = interval(inf(dom))
        hi = interval(sup(dom))
        return hull(f(lo), f(hi)), true
    end

    return zero(eltype(dfD)), false
end

function _monotonicity_check(f::Function, dom::AbstractVector{ET},
                             ∇fD::AbstractVector) where {ET<:Interval}
    return _monotonicity_check(f, dom, ∇fD, ET, length(dom))
end

function _monotonicity_check(f::Function, dom::IntervalBox{N}, ∇fD::AbstractVector) where {N}
    return _monotonicity_check(f, dom, ∇fD, eltype(dom), N)
end

function _monotonicity_check(f::Function, dom::IntervalVector_or_IntervalBox, ∇fD::AbstractVector,
                             ET, N)
    low = zeros(ET, N)
    high = zeros(ET, N)

    @inbounds for (i, di) in enumerate(∇fD)
        if inf(di) >= 0  #  increasing
            high[i] = interval(sup(dom[i]))
            low[i] = interval(inf(dom[i]))
        elseif sup(di) <= 0  # decreasing
            high[i] = interval(inf(dom[i]))
            low[i] = interval(sup(dom[i]))
        else
            return di, false
        end
    end

    return hull(f(low), f(high)), true
end
