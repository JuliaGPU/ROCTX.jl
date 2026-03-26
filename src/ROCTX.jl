module ROCTX

using Preferences

# TOO: support JLL
const libroctx = @load_preference("libroctx", "libroctx64")

function set_libroctx_path(libroctx)
    @set_preferences!("libroctx" => libroctx)
    @info("New library path set; please restart Julia to see this take effect", libroctx)
end

include("libroctx_api.jl")

## Markers
mark(message) = roctxMarkA(message)

## Ranges
range_push(message) = roctxRangePushA(message)
range_pop() = roctxRangePop()

range_start(message) = roctxRangeStartA(message)
range_stop(id) = roctxRangeStop(id)

## Profiler Control
profiler_pause(tid=UInt64(0)) = roctxProfilerPause(tid)
profiler_resume(tid=UInt64(0)) = roctxProfilerResume(tid)

include("macro.jl")

function versioninfo()
    println("rocTX: ", roctx_version())
    return nothing
end

export mark

end # module ROCTX
