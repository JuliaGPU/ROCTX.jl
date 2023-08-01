using AMDGPU
using ROCTX

kernel() = nothing

function main()

    # Not in a roctx range.
    @roc groupsize=1 gridsize=1 kernel()

    ret = ROCTX.range_push("NestedRangeA")

    # In a simple first level roctx range.
    @roc groupsize=1 gridsize=1 kernel()

    if ROCTX.range_pop() != ret
        error("ROCTX.range_pop() != ret")
    end

    ROCTX.range_push("NestedRangeB")
    ROCTX.range_push("NestedRangeC")
    id = ROCTX.range_start("StartStopRangeA")

    # In a nested roctx range.
    @roc groupsize=1 gridsize=1 kernel()

    ROCTX.range_pop()
    ROCTX.range_pop()

    @sync Threads.@spawn ROCTX.roctxRangeStop(id)

    ROCTX.range_push("NestedRangeD")
    ROCTX.range_push("NestedRangeE")
    ROCTX.range_pop()

    # In a first level roctx range, but after a nested range.
    @roc groupsize=1 gridsize=1 kernel()

    if ROCTX.range_pop() != 0
        error("ROCTX.range_pop() != 0")
    end

    AMDGPU.synchronize()
    return nothing
end

main()
