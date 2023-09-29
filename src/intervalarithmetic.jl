# =================================
# Methods using interval arithmetic
# =================================

function enclose(f::Function, dom::Interval_or_IntervalBox, ::NaturalEnclosure; kwargs...)
    return f(dom)
end

function enclose(f::Function, dom::Interval, ::MeanValueEnclosure;
                 df=Base.Fix1(ForwardDiff.derivative, f))
    return f(mid(dom)) + df(dom) * (dom - mid(dom))
end

function enclose(f::Function, dom::IntervalBox, ::MeanValueEnclosure;
                  df=t -> ForwardDiff.gradient(f, t.v))
    return f(mid.(dom)) + dot(df(dom), dom - mid.(dom))
end
