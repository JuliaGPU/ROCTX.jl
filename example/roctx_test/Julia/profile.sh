ENABLE_JITPROFILING=1 rocprof --roctx-trace julia --project -t 2 roctx_test.jl

# export HSA_TOOLS_REPORT_LOAD_FAILURE=1
# export ROCTRACER_DOMAIN="roctx"
# export LD_PRELOAD="/opt/rocm/lib/roctracer/libroctracer_tool.so"
# ENABLE_JITPROFILING=1 rocprof --roctx-trace julia --project profile_instrumented.jl