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

function enclose_binary(f, dom; kmax=3, tol=1e-3)
    y = f(dom)
    yinf, ysup = inf(y), sup(y)
    x = bisect(dom)
    ynew = union(f(x[1]), f(x[2]))
    ynew_inf, ynew_sup = inf(ynew), sup(ynew)
    no_cambia_inf = abs(yinf - ynew_inf) < tol
    no_cambia_sup = abs(ysup - ynew_sup) < tol
    no_cambia_ninguno = (no_cambia_inf && no_cambia_sup)
    empeora_inf = ynew_inf < yinf
    empeora_sup = ynew_sup > ysup
    empeoran_ambos = empeora_inf && empeora_sup
    if kmax == 0 || no_cambia_ninguno || empeoran_ambos
        return Interval(yinf, ysup)
    end
    yinf = max(yinf, ynew_inf) # mejoro al ysup
    ysup = min(ysup, ynew_sup)  # mejoro al ysup
    e1 = enclose_binary(f, x[1], kmax=kmax-1)
    e2 = enclose_binary(f, x[2], kmax=kmax-1)
    return Interval(min(inf(e1), inf(e2)), max(sup(e1), sup(e2)))
end
