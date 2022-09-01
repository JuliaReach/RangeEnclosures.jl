#=================================
Methods using Affine Arithmetic
=================================#

function load_affinearithmetic()
return quote

using .AffineArithmetic: Aff

end  # quote
end  # load_affinearithmetic()

# univariate
function _enclose(::AffineArithmeticEnclosure, f::Function, dom::Interval)
    require(@__MODULE__, :AffineArithmetic; fun_name="enclose")

    x = Aff(dom, 1, 1)
    return interval(f(x))
end

# multivariate
function _enclose(::AffineArithmeticEnclosure, f::Function, dom::IntervalBox{N}) where {N}
    require(@__MODULE__, :AffineArithmetic; fun_name="enclose")

    x = [Aff(dom[i], N, i) for i in 1:N]
    return interval(f(x))
end
