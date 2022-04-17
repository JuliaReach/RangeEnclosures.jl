# univariate

@inline function enclose(f::Function, X::Interval, ba::BranchAndBoundEnclosure;
                         df=t->ForwardDiff.derivative(f, t))
    return _branch_bound(ba, f, X, df)
end

@inline function enclose(f::Function, X::IntervalBox, ba::BranchAndBoundEnclosure)
    return _branch_bound(ba, f, X)
end

function _branch_bound(ba::BranchAndBoundEnclosure, f::Function, X::Interval{T}, df;
                       initial=emptyinterval(T),
                       cnt=1) where {T<:AbstractFloat}

    dfX = df(X)
    if inf(dfX) >= 0 || sup(dfX) <= 0  # monotone function, evaluate at extrema
        lo = Interval(X.lo)
        hi = Interval(X.hi)
        return hull(f(lo), f(hi), initial)
    end

    fX = f(X)  # TODO: allow user to choose how to evaluate this (mean value, natural enclosure)
    # if tolerance or maximum number of iteration is met, return current enclosure
    if diam(fX) <= ba.tol || cnt == ba.maxdepth
        return hull(fX, initial)
    end

    X1, X2 = bisect(X)
    y1 = _branch_bound(ba, f, X1, df; initial=initial, cnt=cnt+1)
    return _branch_bound(ba, f, X2, df; initial=y1, cnt=cnt+1)
end

# TODO: similar check for gradient
function _branch_bound(ba::BranchAndBoundEnclosure, f::Function, X::IntervalBox{N, T};
                       initial=emptyinterval(T),
                       cnt=1) where {N, T<:AbstractFloat}

    fX = f(X...)  # TODO: allow user to choose how to evaluate this (mean value, natural enclosure)
    # if tolerance or maximum number of iteration is met, return current enclosure
    if diam(fX) <= ba.tol || cnt == ba.maxdepth
        return hull(fX, initial)
    end

    X1, X2 = bisect(X)
    y1 = _branch_bound(ba, f, X1; initial=initial, cnt=cnt+1)
    return _branch_bound(ba, f, X2; initial=y1, cnt=cnt+1)
end
