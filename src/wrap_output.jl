# internal helper function to wrap a tuple output to IntervalBox
function _wrap_output(x::NTuple{N,Interval}) where {N}
    return IntervalBox(x)
end

function _wrap_output(x::Interval_or_IntervalBox)
    return x
end

function load_affinearithmetic_wrap_output()
    return quote
        function _wrap_output(x::NTuple{N,Aff}) where {N}
            return IntervalBox(interval.(x))
        end

        function _wrap_output(x::Aff)
            return interval(x)
        end
    end  # quote
end  # load_affinearithmetic_wrap_output()
