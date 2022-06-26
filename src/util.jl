function require(package::Symbol; fun_name::String="", explanation::String="")
    check = isdefined(@__MODULE__, package)
    @assert check "package '$package' not loaded" *
        (fun_name == "" ? "" :
            " (it is required for executing `$fun_name`" *
            (explanation == "" ? "" : " " * explanation) * ")")
end
