#=================================
Methods using Taylor Models
=================================#
using TaylorModels

@inline zeroBox(N) = IntervalBox(0..0, N)
@inline symBox(N) = IntervalBox(-1..1, N)

"""
    enclose_TaylorModels(f::Function, dom::Interval_or_IntervalBox;
                         order::Int=10, normalize::Bool=true)

Compute a range enclosure using Taylor Models substitution.

### Input

- `f`         -- function
- `dom`       -- hyperrectangular domain, either a unidimensional  `Interval` or
                 a multidimensional `IntervalBox`
- `order`     -- (optional, default: `10`) order of the taylor model used to compute
                 an enclosure of `f` over `dom`
- `normalize` -- (optional, default: `true`) if `true`, normalize the taylor model
                 on the unit symmetric box around the origin

### Output

An interval representing the range enclosure (minimum and maximum) of `f` over
its domain `dom`.

### Algorithm

The result is obtained by an evaluation of the function over Taylor model variables
after recentering in the given domain and (optionally) normalizing in the
symmetric ``[-1..1]^n`` domain.

We refer to the documentation and source code of `TaylorModels` for details.
"""
function enclose_TaylorModels(f::Function, dom::Interval_or_IntervalBox;
                              order::Int=10, normalize::Bool=true)
    if normalize
        R = _enclose_TaylorModels_norm(f, dom, order)
    else
        R = _enclose_TaylorModels(f, dom, order)
    end
    return R
end

# univariate
function _enclose_TaylorModels(f::Function, dom::Interval, order::Int)
    x0 = Interval(mid(dom))
    x = TaylorModel1(order, x0, dom)
    return evaluate(f(x), dom - x0)
end

# normalized univariate
function _enclose_TaylorModels_norm(f::Function, dom::Interval, order::Int)
    x0 = Interval(mid(dom))
    x = TaylorModel1(order, x0, dom)
    xnorm = normalize_taylor(x.pol, dom - x0, true)
    xnormTM = TaylorModel1(xnorm, 0..0, 0..0, -1..1)
    return evaluate(f(xnormTM), -1..1)
end

# multivariate
function _enclose_TaylorModels(f::Function, dom::IntervalBox{N}, order::Int) where {N}
    x0 = mid(dom)
    set_variables(Float64, "x", order=2order, numvars=N)
    x = [TaylorModelN(i, order, IntervalBox(x0), dom) for i=1:N]
    return evaluate(f(x...), dom - x0)
end

# normalized multivariate
function _enclose_TaylorModels_norm(f::Function, dom::IntervalBox{N}, order::Int) where {N}
    x0 = mid(dom)
    set_variables(Float64, "x", order=2order, numvars=N)

    zBoxN = zeroBox(N)
    sBoxN = symBox(N)
    x = [TaylorModelN(i, order, IntervalBox(x0), dom) for i=1:N]
    xnorm = [normalize_taylor(xi.pol, dom - x0, true) for xi in x]
    xnormTM = [TaylorModelN(xi_norm, 0..0, zBoxN, sBoxN) for xi_norm in xnorm]
    return evaluate(f(xnormTM...), sBoxN)
end
