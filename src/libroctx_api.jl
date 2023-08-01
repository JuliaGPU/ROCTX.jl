# const ROCTX_VERSION_MAJOR = 4
# const ROCTX_VERSION_MINOR = 1

const roctx_range_id_t = UInt64

function roctxMarkA(message)
    ccall((:roctxMarkA, libroctx), Cvoid, (Ptr{Cchar},), message)
end

mark(message) = roctxMarkA(message)

function roctxRangePushA(message)
    ccall((:roctxRangePushA, libroctx), Cint, (Ptr{Cchar},), message)
end

function roctxRangeStartA(message)
    ccall((:roctxRangeStartA, libroctx), roctx_range_id_t, (Ptr{Cchar},), message)
end

# no prototype is found for this function at roctx.h:195:15, please use with caution
function roctxRangePop()
    ccall((:roctxRangePop, libroctx), Cint, ())
end

function roctxRangeStop(id)
    ccall((:roctxRangeStop, libroctx), Cvoid, (roctx_range_id_t,), id)
end

range_start(message) = roctxRangeStartA(message)
range_stop(id) = roctxRangeStop(id)

range_push(message) = roctxRangePushA(message)
range_pop() = roctxRangePop()

function roctx_version_major()
    ccall((:roctx_version_major, libroctx), Cint, ())
end

function roctx_version_minor()
    ccall((:roctx_version_minor, libroctx), Cint, ())
end

roctx_version() = VersionNumber(roctx_version_major(), roctx_version_minor())
