# =================================
# Methods using interval arithmetic
# =================================

# univariate and multivariate cases
function enclose(f::Function, dom::Interval_or_IntervalVector_or_IntervalBox, ::NaturalEnclosure;
                 kwargs...)
    return _wrap_output(f(dom))
end

# univariate case
function enclose(f::Function, dom::Interval, ::MeanValueEnclosure;
                 df=Base.Fix1(ForwardDiff.derivative, f))
    return f(mid(dom)) + df(dom) * (dom - mid(dom))
end

# multivariate case
function _enclose(::MeanValueEnclosure, f::Function, dom::IntervalVector_or_IntervalBox, df_dom)
    return f(mid.(dom)) + dot(df_dom, dom - mid.(dom))
end

function enclose(f::Function, dom::AbstractVector{<:Interval}, mve::MeanValueEnclosure;
                 df=t -> ForwardDiff.gradient(f, t))
    return _enclose(mve, f, dom, df(dom))
end

function enclose(f::Function, dom::IntervalBox, mve::MeanValueEnclosure;
                 df=t -> ForwardDiff.gradient(f, t.v))
    return _enclose(mve, f, dom, df(dom))
end
