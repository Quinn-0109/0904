#!/usr/bin/env bash
# Native (non-Docker) entrypoint for the relocatable 0902overall bundle.
set -Eeuo pipefail

PKG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERALL_ROOT="$(cd "$PKG/.." && pwd)"
RUN_NAME="${1:-oblique_native_$(date +%Y%m%d_%H%M%S)}"
SEED_OFFSET="${2:-1}"

export SIMENV_ROOT="${SIMENV_ROOT:-$OVERALL_ROOT/SimEnv-master}"
export SIMENV_ASSET_ROOT="${SIMENV_ASSET_ROOT:-$OVERALL_ROOT/runtime_assets/SimEnv}"
export SCAN_WORKSPACE="${SCAN_WORKSPACE:-$PKG/work/mounts/SCAN-Planner}"
export RESULTS_ROOT="${RESULTS_ROOT:-$OVERALL_ROOT/results}"
export MISSION_CONFIG="${MISSION_CONFIG:-$PKG/work/mounts/SimEnv/src/simenv_bridge/config/three_floor_rl_mission.json}"
export SIMENV_TORCH_ROOT="${SIMENV_TORCH_ROOT:-$OVERALL_ROOT/third_party/libtorch}"
export SIMENV_VALIDATED_CONTROLLER="${SIMENV_VALIDATED_CONTROLLER:-$SIMENV_ASSET_ROOT/runtime_bin/junior_ctrl_validated}"
export SIMENV_NATIVE_BUILD_SPACE="${SIMENV_NATIVE_BUILD_SPACE:-$SIMENV_ROOT/.portable/build}"
export SIMENV_NATIVE_DEVEL_SPACE="${SIMENV_NATIVE_DEVEL_SPACE:-$SIMENV_ROOT/.portable/devel}"
export SCAN_BUILD_SPACE="${SCAN_BUILD_SPACE:-$OVERALL_ROOT/.portable_build/scanplanner_build_v2}"
export SCAN_DEVEL_SPACE="${SCAN_DEVEL_SPACE:-$OVERALL_ROOT/.portable_build/scanplanner_devel_v2}"
export THREE_FLOOR_SEED_OFFSET="$SEED_OFFSET"
export MAX_WALL_SEC="${MAX_WALL_SEC:-3000}"
# RGB-D camera topics remain enabled for online danger detection.  Only the
# optional MP4 encoder is disabled by default for the current acceptance run.
export RECORD_CAMERA_VIDEO="${RECORD_CAMERA_VIDEO:-false}"
export SIMENV_EXTRA_ROS_PACKAGE_PATH="$PKG/work/mounts/SimEnv/src:$SIMENV_ASSET_ROOT/src:$SIMENV_ROOT/src"
export ROS_PACKAGE_PATH="$SIMENV_EXTRA_ROS_PACKAGE_PATH${ROS_PACKAGE_PATH:+:$ROS_PACKAGE_PATH}"
export LD_LIBRARY_PATH="$SIMENV_TORCH_ROOT/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

bundle_root="$(realpath -e "$OVERALL_ROOT")"
assert_bundle_path() {
  local label="$1"
  local configured="$2"
  local resolved
  resolved="$(realpath -m "$configured")"
  case "$resolved" in
    "$bundle_root"|"$bundle_root"/*) ;;
    *)
      echo "ERROR: $label must remain inside the unpacked 0902overall bundle: $resolved" >&2
      exit 2
      ;;
  esac
}
assert_bundle_path SIMENV_ROOT "$SIMENV_ROOT"
assert_bundle_path SIMENV_ASSET_ROOT "$SIMENV_ASSET_ROOT"
assert_bundle_path SCAN_WORKSPACE "$SCAN_WORKSPACE"
assert_bundle_path RESULTS_ROOT "$RESULTS_ROOT"
assert_bundle_path MISSION_CONFIG "$MISSION_CONFIG"
assert_bundle_path SIMENV_TORCH_ROOT "$SIMENV_TORCH_ROOT"
assert_bundle_path SIMENV_VALIDATED_CONTROLLER "$SIMENV_VALIDATED_CONTROLLER"
assert_bundle_path SIMENV_NATIVE_BUILD_SPACE "$SIMENV_NATIVE_BUILD_SPACE"
assert_bundle_path SIMENV_NATIVE_DEVEL_SPACE "$SIMENV_NATIVE_DEVEL_SPACE"
assert_bundle_path SCAN_BUILD_SPACE "$SCAN_BUILD_SPACE"
assert_bundle_path SCAN_DEVEL_SPACE "$SCAN_DEVEL_SPACE"

mkdir -p "$RESULTS_ROOT" "$OVERALL_ROOT/.portable_build"

exec bash "$PKG/work/mounts/SimEnv/src/simenv_bridge/scripts/run_scanplanner_three_floor_rl.sh" "$RUN_NAME"
