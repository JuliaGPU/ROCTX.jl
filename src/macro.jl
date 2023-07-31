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
        locinfo = true
    else
        locinfo = esc(locinfo)
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
