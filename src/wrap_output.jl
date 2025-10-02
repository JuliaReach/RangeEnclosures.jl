# internal helper function to wrap a tuple output
function _wrap_output(x::NTuple{N,Interval}) where {N}
    return collect(x)
end

function _wrap_output(x::Interval_or_IntervalVector)
    return x
end

function load_affinearithmetic_wrap_output()
    return quote
        function _wrap_output(x::NTuple{N,Aff}) where {N}
            return collect(interval.(x))
        end

        function _wrap_output(x::Aff)
            return interval(x)
        end
    end  # quote
end  # load_affinearithmetic_wrap_output()
