# ======================================
# Methods using semidefinite programming
# ======================================

function _enclose(sose::SumOfSquaresEnclosure, p, dom::Interval_or_IntervalBox;
                  kwargs...)
    require(@__MODULE__, :SumOfSquares; fun_name="enclose")

    return _enclose_sos(sose, p, dom; kwargs...)
end
