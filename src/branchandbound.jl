using TaylorModels
#========#
#========#

# univariate
function enclose_BranchandBound(f::Function, dom::Interval, order=order, tol=tol)
    x0 = Interval(mid(dom))
    x = TaylorModel1(order, x0, dom)
    return _branchandbound(f(x), dom - x0)
end
# multivariate
function enclose_BranchandBound(f::Function, dom::IntervalBox{N}, order=order,tol=tol) where {N}
    x0 = mid(dom)
    set_variables(Float64, "x", order=2order, numvars=N)
    x = [TaylorModelN(i, order, IntervalBox(x0), dom) for i=1:N]
    return _branchandbound(f(x...), dom - x0)
end

function _branchandbound(p::Union{TaylorN{T},Taylor1{T}},
                       dom::Union{IntervalBox{N,T},Interval{T}},ϵ::Number) where {N,T}
    K = 1
    Rperv = evaluate(p,dom)
    D1,D2 = bisect(dom)
    D = [ D1 , D2 ]
    R = [evaluate(p, D[i]) for i = 1:length(D)]
    Rnext = Interval(minimum(R[i].lo for i = 1:length(R)),
                     maximum(R[i].hi for i = 1:length(R)))
    while  (Rperv.hi - Rnext.hi) <= ϵ*(Rnext.hi - Rnext.lo) &&
           (Rperv.lo - Rnext.lo) <= ϵ*(Rnext.hi - Rnext.lo) && (K <= 1000)
        Rperv = Interval(minimum(R[i].lo for i = 1:length(R)),
                         maximum(R[i].hi for i = 1:length(R)))
        R_x = [ R[i].hi for i = 1:length(R)]
        R_n = [ R[i].lo for i = 1:length(R)]
        max_range = maximum(R[i].hi for i = 1:length(R))
        max_index = findall(x->x == max_range, R_x)[1]
        min_range = minimum(R[i].lo for i = 1:length(R))
        min_index = findall(x->x == min_range, R_n)[1]
        l_D = length(D[1])
        K = K + 1
        if min_index == max_index
            D, R = devide_dom!(p,D,R,max_index)
            Rnext = Interval(minimum(R[i].lo for i=1:length(R)),
                             maximum(R[i].hi for i=1:length(R)))
        else
            D, R = devide_dom!(p,D,R,max_index)
            if max_index < min_index
                min_index = min_index + 1
            end
            D, R = devide_dom!(p,D,R,min_index)
            Rnext = Interval(minimum(R[i].lo for i=1:length(R)),
                             maximum(R[i].hi for i=1:length(R)))
        end
    end
    return Interval(minimum(R[i].lo for i=1:length(R)),
                    maximum(R[i].hi for i=1:length(R)))
end

function devide_dom!(p::Union{TaylorN{T},Taylor1{T}},
                     D::Union{Array{IntervalBox{N,T},M},Array{Interval{T},M}},
                     R::Array{Interval{T},M}, index::Number) where {N,T,M}
    BA = [ ((D[index][i]).hi - (D[index][i]).lo) for i = 1:length(D[1])]
    Beta1 = maximum(BA)
    β = findall(x->x==Beta1,BA)[1]
    D1,D2 = bisect(D[index],β)
    D[index] = D1
    DD = push!(D[1:index],D2)
    D = append!(DD, D[(index+1):length(D)])
    R[index] = evaluate(p,D[index])
    RR = append!(R[1:index], evaluate(p,D[index+1]))
    R = append!(RR, R[(index+1):length(R)])
    return D,R
end
