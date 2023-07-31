file_lineno(__source__) = "$(__source__.file):$(__source__.line)"

function process_args(args)
    locinfo = nothing
    # if not a keyword, first arg is the message
    if length(args) >= 1
        arg = args[1]
        if !(arg isa Expr && arg.head == :(=))
            message = args[1]
            args = args[2:end]
        end
    end
    for arg in args
        if !(arg isa Expr && arg.head == :(=))
            error("$arg is not a keyword")
        end
        kw, val = arg.args
        if kw == :locinfo && isnothing(locinfo)
            locinfo = val
        else
            if kw in [:locinfo]
                error("$kw already defined")
            else
                error("invalid keyword $kw")
            end
        end
    end

    if isnothing(locinfo)
        locinfo = false
    end

    message = esc(message)
    return message, locinfo
end

macro mark(args...)
    message, locinfo = process_args(args)
    locinfo_expr = locinfo ? esc(" ($(__module__):$(file_lineno(__source__)))") : esc("")
    quote
        mark($message * $(locinfo_expr))
    end
end

macro range(args...)
    @assert length(args) >= 1
    expr = args[end]
    args = args[1:end-1]
    message, locinfo = process_args(args)
    locinfo_expr = locinfo ? esc(" ($(__module__):$(file_lineno(__source__)))") : esc("")
    quote
        range_push($message * $(locinfo_expr))
        # Use Expr(:tryfinally, ...) so we don't introduce a new soft scope (https://github.com/JuliaGPU/NVTX.jl/issues/28)
        # TODO: switch to solution once https://github.com/JuliaLang/julia/pull/39217 is resolved
        $(Expr(:tryfinally, esc(expr), :(range_pop())))
    end
end

macro range_startstop(args...)
    @assert length(args) >= 1
    expr = args[end]
    args = args[1:end-1]
    message, locinfo = process_args(args)
    locinfo_expr = locinfo ? esc(" ($(__module__):$(file_lineno(__source__)))") : esc("")
    quote
        rangeid = range_start($message * $(locinfo_expr))
        # Use Expr(:tryfinally, ...) so we don't introduce a new soft scope (https://github.com/JuliaGPU/NVTX.jl/issues/28)
        # TODO: switch to solution once https://github.com/JuliaLang/julia/pull/39217 is resolved
        $(Expr(:tryfinally, esc(expr), :(range_stop(rangeid))))
    end
end
