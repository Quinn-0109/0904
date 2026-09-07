#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SIM_ROOT="$ROOT/SimEnv-master"
TORCH_LIB="$ROOT/third_party/libtorch/lib"
VALID_CTRL="$ROOT/runtime_assets/SimEnv/runtime_bin/junior_ctrl_validated"

test -x "$VALID_CTRL" || {
    echo "ERROR: missing validated controller: $VALID_CTRL" >&2
    exit 2
}

ln -sfn libcudart-d0da41ae.so.11.0 \
    "$TORCH_LIB/libcudart.so.11.0"
ln -sfn libnvToolsExt-847d78f2.so.1 \
    "$TORCH_LIB/libnvToolsExt.so.1"
ln -sfn libcublas-3b81d170.so.11 \
    "$TORCH_LIB/libcublas.so.11"

unset CONDA_PREFIX CONDA_DEFAULT_ENV
unset PYTHONPATH ROS_PACKAGE_PATH CMAKE_PREFIX_PATH CATKIN_PREFIX_PATH

export SIMENV_CPU_SIM_ROOT="$SIM_ROOT"
export PYTHONNOUSERSITE=1
export CUDA_VISIBLE_DEVICES=""
export LD_LIBRARY_PATH="$TORCH_LIB:/opt/ros/noetic/lib"
export LIBTORCH_LIBRARY_PATH="$TORCH_LIB"

# Bash函数的优先级高于PATH；source ROS setup后仍然有效
catkin_make()
{
    local args=" $* "

    if [[ "$args" == *" -C ${SIMENV_CPU_SIM_ROOT} "* ]] &&
       [[ "$args" == *" --pkg unitree_guide "* ]]; then
        echo "[CPU deploy] Unitree rebuild skipped; bundled validated controller selected"
        return 0
    fi

    /opt/ros/noetic/bin/catkin_make "$@"
}
export -f catkin_make

if ldd "$VALID_CTRL" | grep -F "not found"; then
    echo "ERROR: validated controller has unresolved libraries" >&2
    exit 2
fi

# 验证新的bash子进程确实继承了函数
bash -c '
type catkin_make | head -n 1
catkin_make -C "$SIMENV_CPU_SIM_ROOT" --pkg unitree_guide
'

exec bash "$ROOT/run_native.sh" "$@"
