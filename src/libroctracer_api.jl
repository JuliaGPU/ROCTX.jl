function roctracer_version_major()
    ccall((:roctracer_version_major, libroctracer), Cint, ())
end

function roctracer_version_minor()
    ccall((:roctracer_version_minor, libroctracer), Cint, ())
end

roctracer_version() = VersionNumber(roctracer_version_major(), roctracer_version_minor())

function roctracer_start()
    ccall((:roctracer_start, libroctracer), Cvoid, ())
end

function roctracer_stop()
    ret = ccall((:roctracer_stop, libroctracer), Cint, ())
    ret == 0
end
