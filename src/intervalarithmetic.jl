# =================================
# Methods using interval arithmetic
# =================================

function _enclose(::NaturalEnclosure, f::Function, dom::Interval_or_IntervalBox; kwargs...)
    return f(dom)
end

function _enclose(::MeanValueEnclosure, f::Function, dom::Interval;
                  df=Base.Fix1(ForwardDiff.derivative, f))
    return f(mid(dom)) + df(dom) * (dom - mid(dom))
end

function _enclose(::MeanValueEnclosure, f::Function, dom::IntervalBox;
                  df=t->ForwardDiff.gradient(f, t.v))
    return f(mid.(dom)) + dot(df(dom), dom - mid.(dom))
end
