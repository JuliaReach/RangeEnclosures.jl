using TaylorModels
# univariate
function enclose_BranchandBound(f::Function, dom::Interval{T}; order::Int = 10,
                                tol::Number = 0.6) where{T}
    x0 = Interval(mid(dom))
    x = TaylorModel1(order, x0, dom)
    return branchandbound(f(x-x0).pol, dom, tol)
end
# multivariate
function enclose_BranchandBound(f::Function, dom::IntervalBox{T,N}; order::Int = 10,
                                tol::Number = 0.6) where {T,N}
    n = length(dom)
    x0 = mid(dom)
    set_variables(Float64, "x", order=2order, numvars=n)
    x = [TaylorModelN(i, order, IntervalBox(x0), dom) for i=1:n]
    return branchandbound(f(x...).pol, dom - x0, tol)
end

function branchandbound(p::Taylor1{T}, dom::Interval{W}, ϵ::Number) where{T,W}
    return _branchandbound(p, dom, ϵ)
end

function branchandbound(p::TaylorN{T}, dom::IntervalBox{N,W}, ϵ::Number) where{T,N,W}
    return _branchandbound(p, dom, ϵ)
end

function _branchandbound(p::Union{TaylorN{T},Taylor1{T}},
                       dom::Union{IntervalBox{N,W},Interval{W}}, ϵ::Number) where {N,T,W}
    K = 1
    Rperv = evaluate(p, dom)
    D1, D2 = bisect(dom)
    D = [D1, D2]
    R = [evaluate(p, D[i]) for i = 1:length(D)]
    Rnext = _Rnext(R)
    while  (Rperv.hi - Rnext.hi) <= ϵ*diam(Rnext) &&
           (Rperv.lo - Rnext.lo) <= ϵ*diam(Rnext) && (K <= 1000)
        Rperv = _Rnext(R)
        R_x = [R[i].hi for i = 1:length(R)]
        R_n = [R[i].lo for i = 1:length(R)]
        max_range = maximum(R[i].hi for i = 1:length(R))
        max_index = findall(x->x == max_range, R_x)[1]
        min_range = minimum(R[i].lo for i = 1:length(R))
        min_index = findall(x->x == min_range, R_n)[1]
        l_D = length(D[1])
        K = K + 1
        if min_index == max_index
            D, R = divide_dom!(p, D, R, max_index)
            Rnext = _Rnext(R)
        else
            D, R = divide_dom!(p, D, R, max_index)
            if max_index < min_index
                min_index = min_index + 1
            end
            D, R = divide_dom!(p, D, R, min_index)
            Rnext = _Rnext(R)
        end
    end
    return  _Rnext(R)
end

function divide_dom!(p::Union{TaylorN{T},Taylor1{T}},
                     D::Union{Array{IntervalBox{N,W},M},Array{Interval{W},M}},
                     R::Array{Interval{W},M}, index::Number) where {N,T,M,W}
    BA = [ ((D[index][i]).hi - (D[index][i]).lo) for i = 1:length(D[1])]
    Beta1 = maximum(BA)
    β = findall(x->x == Beta1, BA)[1]
    D1,D2 = bisect(D[index], β)
    D[index] = D1
    DD = push!(D[1:index], D2)
    D = append!(DD, D[(index+1):length(D)])
    R[index] = evaluate(p, D[index])
    RR = append!(R[1:index], evaluate(p,D[index+1]))
    R = append!(RR, R[(index+1):length(R)])
    return D, R
end

function _Rnext(R::Array{Interval{T}}) where{T}
    I =  Interval(minimum(R[i].lo for i=1:length(R)),
                  maximum(R[i].hi for i=1:length(R)))
   return I
end
