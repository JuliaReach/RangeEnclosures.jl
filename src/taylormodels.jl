# ===========================
# Methods using Taylor models
# ===========================

function enclose(f::Function, dom::Interval_or_IntervalVector_or_IntervalBox,
                 tm::TaylorModelsEnclosure; kwargs...)
    require(@__MODULE__, :TaylorModels; fun_name="enclose")

    if tm.normalize
        R = _enclose_TaylorModels_norm(f, dom, tm.order)
    else
        R = _enclose_TaylorModels(f, dom, tm.order)
    end
    return R
end

function load_taylormodels()
    return quote
        using .TaylorModels: TaylorModel1, TaylorModelN, normalize_taylor, set_variables, evaluate

        @inline zeroBox(N) = fill(interval(0, 0), N)
        @inline symBox(N) = fill(interval(-1, 1), N)

        # univariate
        function _enclose_TaylorModels(f::Function, dom::Interval, order::Int)
            x0 = interval(mid(dom))
            x = TaylorModel1(order, x0, dom)
            return evaluate(f(x - x0), dom)
        end

        # normalized univariate
        function _enclose_TaylorModels_norm(f::Function, dom::Interval, order::Int)
            x0 = interval(mid(dom))
            x = TaylorModel1(order, x0, dom)
            xnorm = normalize_taylor(x.pol, dom - x0, true)
            xnormTM = TaylorModel1(xnorm, interval(0, 0), interval(0, 0), interval(-1, 1))
            return evaluate(f(xnormTM), interval(-1, 1))
        end

        # multivariate
        function _enclose_TaylorModels(f::Function, dom::AbstractVector{<:Interval}, order::Int)
            N = length(dom)
            x0 = [interval(mid(di)) for di in dom]
            set_variables(Float64, "x"; order=2order, numvars=N)
            x = [TaylorModelN(i, order, x0, dom) for i in 1:N]
            return evaluate(f(x), dom - x0)
        end

        function _enclose_TaylorModels(f::Function, dom::IntervalBox, order::Int)
            return _enclose_TaylorModels(f, Vector(dom.v), order)
        end

        # normalized multivariate
        function _enclose_TaylorModels_norm(f::Function, dom::AbstractVector{<:Interval}, order::Int)
            N = length(dom)
            x0 = [interval(mid(di)) for di in dom]
            set_variables(Float64, "x"; order=2order, numvars=N)

            zBoxN = zeroBox(N)
            sBoxN = symBox(N)
            x = [TaylorModelN(i, order, x0, dom) for i in 1:N]
            xnorm = [normalize_taylor(xi.pol, dom - x0, true) for xi in x]
            xnormTM = [TaylorModelN(xi_norm, interval(0, 0), zBoxN, sBoxN) for xi_norm in xnorm]
            return evaluate(f(xnormTM), sBoxN)
        end

        function _enclose_TaylorModels_norm(f::Function, dom::IntervalBox{N}, order::Int) where {N}
            return _enclose_TaylorModels_norm(f, Vector(dom.v), order)
        end
    end  # quote
end  # load_taylormodels()
