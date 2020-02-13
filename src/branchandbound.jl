# univariate
function enclose_BranchandBound(f::Function, dom::Interval; order=10, tol=0.6)
    x0 = Interval(mid(dom))
    x = TaylorModel1(order, x0, dom)
    return branchandbound(f(x-x0).pol, dom, tol)
end

# multivariate
function enclose_BranchandBound(f::Function, dom::IntervalBox{D};
                                order=10, tol=0.6) where {D}
    x0 = mid(dom)
    set_variables(Float64, "x", order=2order, numvars=D)
    x = [TaylorModelN(i, order, IntervalBox(x0), dom) for i=1:D]
    return branchandbound(f(x...).pol, dom - x0, tol)
end

@inline _Rnext(R::Vector{<:Interval}) = Interval(minimum(inf.(R)), maximum(sup.(R)))

const Kmax = 1000

function branchandbound(p::Union{Taylor1, TaylorN},
                        dom::Interval_or_IntervalBox,
                        tol::Number)
    K = 1
    Rprev = evaluate(p, dom)
    D = bisect(dom)
    R = [evaluate(p, D[1]), evaluate(p, D[2])]
    Rnext = R[1] ∩ R[2]

    while  (Rprev.hi - Rnext.hi) >= tol * diam(Rnext) &&
           (Rprev.lo - Rnext.lo) >= tol * diam(Rnext)

        Rprev = _Rnext(R)
        R_x = sup.(R)
        R_n = inf.(R)
        max_range = maximum(R_x)
        max_index = findall(x->x == max_range, R_x)[1]
        min_range = minimum(R_n)
        min_index = findall(x->x == min_range, R_n)[1]
        l_D = length(D[1])
        K += 1
        if K == Kmax
            error("convergence not achieved in branch and bound after $Kmax steps")
        end

        D, R = divide_dom!(p, D, R, max_index)
        if max_index < min_index
            min_index += 1
            D, R = divide_dom!(p, D, R, min_index)
        end
        Rnext = _Rnext(R)
    end
    return _Rnext(R)
end

function divide_dom!(p::Union{TaylorN{T}, Taylor1{T}},
                     D::Union{Array{IntervalBox{N, W}, M}, Array{Interval{W}, M}},
                     R::Array{Interval{W}, M}, index::Number) where {N, T, M, W}
    BA = [ ((D[index][i]).hi - (D[index][i]).lo) for i = 1:length(D[1])]
    Beta1 = maximum(BA)
    β = findall(x->x == Beta1, BA)[1]
    D1, D2 = bisect(D[index], β)
    D[index] = D1
    DD = push!(D[1:index], D2)
    D = append!(DD, D[(index + 1):length(D)])
    R[index] = evaluate(p, D[index])
    RR = append!(R[1:index], evaluate(p, D[index + 1]))
    R = append!(RR, R[(index + 1):length(R)])
    return D, R
end

function enclose_binary(f, dom::Interval; kmax=3, tol=1e-3, algorithm=:IntervalArithmetic)
    y = enclose(f, dom, algorithm=algorithm)
    yinf, ysup = inf(y), sup(y)
    kmax == 0 && return Interval(yinf, ysup)
    x = bisect(dom)
    fx1 = enclose(f, x[1], algorithm=algorithm)
    fx2 = enclose(f, x[2], algorithm=algorithm)
    ynew = union(fx1, fx2)
    ynew_inf, ynew_sup = inf(ynew), sup(ynew)
    inf_close = abs(yinf - ynew_inf) <= tol
    sup_close = abs(ysup - ynew_sup) <= tol
    both_close = inf_close && sup_close
    inf_improves = ynew_inf > yinf
    sup_improves = ynew_sup < ysup
    both_improve = inf_improves && sup_improves
    if both_close || !both_improve
        return Interval(yinf, ysup)
    end
    yinf = max(yinf, ynew_inf)
    ysup = min(ysup, ynew_sup)
    if inf_improves
        yinf = ynew_inf
    end
    if sup_improves
        ysup = ynew_sup
    end
    e1 = enclose_binary(f, x[1], kmax=kmax-1, algorithm=algorithm)
    e2 = enclose_binary(f, x[2], kmax=kmax-1, algorithm=algorithm)
    return Interval(hull(e1, e2))
end
