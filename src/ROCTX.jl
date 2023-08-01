module ROCTX

using Preferences

# TOO: support JLL
const libroctx = @load_preference("libroctx", "libroctx64")
const libroctracer = @load_preference("libroctracer", "libroctracer64")

function set_libroctx_path(libroctx)
    @set_preferences!("libroctx" => libroctx)
    @info("New library path set; please restart Julia to see this take effect", libroctx)
end

include("libroctx_api.jl")
include("libroctracer_api.jl")
include("macro.jl")

function versioninfo()
    println("rocTX: ", roctx_version())
    println("rocTracer: ", roctracer_version())
    return nothing
end

export mark

end # module ROCTX
