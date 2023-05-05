# ===========================
# Methods using Taylor models
# ===========================

function _enclose(tme::TaylorModelsEnclosure, f::Function, dom::Interval_or_IntervalBox;
                  kwargs...)
    require(@__MODULE__, :TaylorModels; fun_name="enclose")

    if tme.normalize
        R = _enclose_TaylorModels_norm(f, dom, tme.order)
    else
        R = _enclose_TaylorModels(f, dom, tme.order)
    end
    return R
end

function load_taylormodels()
    return quote
        using .TaylorModels

        @inline zeroBox(N) = IntervalBox(0 .. 0, N)
        @inline symBox(N) = IntervalBox(-1 .. 1, N)

        # univariate
        function _enclose_TaylorModels(f::Function, dom::Interval, order::Int)
            x0 = Interval(mid(dom))
            x = TaylorModel1(order, x0, dom)
            return evaluate(f(x - x0), dom)
        end

        # normalized univariate
        function _enclose_TaylorModels_norm(f::Function, dom::Interval, order::Int)
            x0 = Interval(mid(dom))
            x = TaylorModel1(order, x0, dom)
            xnorm = normalize_taylor(x.pol, dom - x0, true)
            xnormTM = TaylorModel1(xnorm, 0 .. 0, 0 .. 0, -1 .. 1)
            return evaluate(f(xnormTM), -1 .. 1)
        end

        # multivariate
        function _enclose_TaylorModels(f::Function, dom::IntervalBox{N}, order::Int) where {N}
            x0 = mid(dom)
            set_variables(Float64, "x"; order=2order, numvars=N)
            x = [TaylorModelN(i, order, IntervalBox(x0), dom) for i in 1:N]
            return evaluate(f(x), dom - x0)
        end

        # normalized multivariate
        function _enclose_TaylorModels_norm(f::Function, dom::IntervalBox{N}, order::Int) where {N}
            x0 = mid(dom)
            set_variables(Float64, "x"; order=2order, numvars=N)

            zBoxN = zeroBox(N)
            sBoxN = symBox(N)
            x = [TaylorModelN(i, order, IntervalBox(x0), dom) for i in 1:N]
            xnorm = [normalize_taylor(xi.pol, dom - x0, true) for xi in x]
            xnormTM = [TaylorModelN(xi_norm, 0 .. 0, zBoxN, sBoxN) for xi_norm in xnorm]
            return evaluate(f(xnormTM), sBoxN)
        end
    end  # quote
end  # load_taylormodels()
