module ROCTX

using Preferences

# TOO: support JLL
const libroctx = @load_preference("libroctx", "libroctx64")

function set_libroctx_path(libroctx)
    @set_preferences!("libroctx" => libroctx)
    @info("New library path set; please restart Julia to see this take effect", libroctx)
end

include("libroctx_api.jl")
include("macro.jl")

export mark

end # module ROCTX
