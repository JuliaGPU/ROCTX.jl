using AMDGPU
using ROCTX

function mycopy!(dst, src)
    i = workitemIdx().x + (workgroupIdx().x - 1) * workgroupDim().x
    if i ≤ length(dst)
        @inbounds dst[i] = src[i]
    end
    return
end

function main(N)
    src = ROCArray{Float64}(undef, N)
    dst = ROCArray{Float64}(undef, N)
    groupsize = 256               # nthreads
    gridsize = cld(N, groupsize)  # nblocks

    for i in 1:10
        ROCTX.@mark "before mycopy marker"
        ROCTX.@range "range mycopy" begin
            @roc groupsize=groupsize gridsize=gridsize mycopy!(dst, src)
        end
        ROCTX.@range_startstop "range_startstop mycopy" begin
            @roc groupsize=groupsize gridsize=gridsize mycopy!(dst, src)
        end
        ROCTX.@mark "after mycopy marker"
        AMDGPU.synchronize()
    end

    AMDGPU.unsafe_free!(dst)
    AMDGPU.unsafe_free!(src)
    AMDGPU.synchronize()
    return
end
main(2^24)
