# univariate case
@inline function enclose(f::Function, X::Interval, bab::BranchAndBoundEnclosure;
                         df=Base.Fix1(ForwardDiff.derivative, f))
    return _branch_bound(bab, f, X, df)
end

# multivariate case
@inline function enclose(f::Function, X::IntervalBox, bab::BranchAndBoundEnclosure;
                         df=t -> ForwardDiff.gradient(f, t.v))
    return _branch_bound(bab, f, X, df)
end

function _branch_bound(bab::BranchAndBoundEnclosure, f::Function, X::Interval_or_IntervalBox, df;
                       initial=emptyinterval(first(X)),
                       cnt=1)
    dfX = df(X)
    range_extrema, flag = _monotonicity_check(f, X, dfX)
    flag && return hull(range_extrema, initial)

    fX = f(X)  # TODO: allow user to choose how to evaluate this (mean value, natural enclosure)
    # if tolerance or maximum number of iteration is met, return current enclosure
    if diam(fX) <= bab.tol || cnt == bab.maxdepth
        return hull(fX, initial)
    end

    X1, X2 = bisect(X)
    y1 = _branch_bound(bab, f, X1, df; initial=initial, cnt=cnt + 1)
    return _branch_bound(bab, f, X2, df; initial=y1, cnt=cnt + 1)
end

function _monotonicity_check(f::Function, X::Interval, dfX::Interval)
    if inf(dfX) >= 0 || sup(dfX) <= 0  # monotone function, evaluate at extrema
        lo = interval(inf(X))
        hi = interval(sup(X))
        return hull(f(lo), f(hi)), true
    end

    return zero(eltype(dfX)), false
end

function _monotonicity_check(f::Function, X::IntervalBox{N}, ∇fX::AbstractVector) where {N}
    low = zeros(eltype(X), N)
    high = zeros(eltype(X), N)

    @inbounds for (i, di) in enumerate(∇fX)
        if inf(di) >= 0  #  increasing
            high[i] = interval(sup(X[i]))
            low[i] = interval(inf(X[i]))
        elseif sup(di) <= 0  # decreasing
            high[i] = interval(inf(X[i]))
            low[i] = interval(sup(X[i]))
        else
            return di, false
        end
    end

    return hull(f(low), f(high)), true
end
