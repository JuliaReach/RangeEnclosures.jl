#=================================
Methods using Affine Arithmetic
=================================#

function load_affinearithmetic()
    return quote
        using .AffineArithmetic: Aff  # NOTE: this is an internal function
    end  # quote
end  # load_affinearithmetic()

# univariate
function enclose(f::Function, dom::Interval, ::AffineArithmeticEnclosure)
    require(@__MODULE__, :AffineArithmetic; fun_name="enclose")

    x = Aff(dom, 1, 1)
    return interval(f(x))
end

# multivariate
function _enclose(::AffineArithmeticEnclosure, f::Function, dom::IntervalVector_or_IntervalBox, N)
    require(@__MODULE__, :AffineArithmetic; fun_name="enclose")

    x = [Aff(dom[i], N, i) for i in 1:N]
    return interval(f(x))
end

function enclose(f::Function, dom::AbstractVector{<:Interval}, aae::AffineArithmeticEnclosure)
    return _enclose(aae, f, dom, length(dom))
end

function enclose(f::Function, dom::IntervalBox{N}, aae::AffineArithmeticEnclosure) where {N}
    return _enclose(aae, f, dom, N)
end
