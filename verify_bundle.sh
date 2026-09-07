#!/usr/bin/env bash
set -Eeuo pipefail

BUNDLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$BUNDLE_ROOT/MANIFEST.sha256"

if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: missing checksum manifest: $MANIFEST" >&2
  exit 2
fi

cd "$BUNDLE_ROOT"
sha256sum --check --quiet --strict MANIFEST.sha256

for entry in run_native.sh preflight.sh verify_bundle.sh threefloor_stress5_repro_20260827/run_native.sh; do
  if [ ! -x "$entry" ]; then
    echo "ERROR: required entry is not executable: $entry" >&2
    exit 3
  fi
done

while IFS= read -r link; do
  resolved="$(readlink -f "$link" || true)"
  case "$resolved" in
    "$BUNDLE_ROOT"/*|/opt/ros/noetic/*) ;;
    *)
      echo "ERROR: broken or external symlink: $link -> $resolved" >&2
      exit 4
      ;;
  esac
done < <(find "$BUNDLE_ROOT" -type l -print)

python3 - "$BUNDLE_ROOT" <<'PY'
import json
import sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
results = root / "results"
expected_old = [f"oblique_final10_fixbend_seed{s}_b1" for s in range(22, 32)]
expected_new = [f"portable_accept_seed{s}" for s in range(32, 37)]
expected = expected_old + expected_new
actual = sorted(p.name for p in results.iterdir() if p.is_dir())
missing = sorted(set(expected) - set(actual))
if missing:
    raise SystemExit(f"ERROR: missing retained result directories: {missing}")

core_images = (
    "three_floor_topdown_trajectories.png",
    "two_view_all_floors.png",
    "danger_truth_evaluation_all_floors.png",
)
for seed in range(32, 37):
    run = results / f"portable_accept_seed{seed}"
    for required_json in (
        "three_floor_rl_acceptance.json",
        "three_floor_rl_mission_summary.json",
        "physical_two_view_room_evidence.json",
        "visualization/danger_truth_evaluation.json",
    ):
        if not (run / required_json).is_file():
            raise SystemExit(f"ERROR: seed {seed} missing {required_json}")
    acceptance = json.loads((run / "three_floor_rl_acceptance.json").read_text())
    mission = json.loads((run / "three_floor_rl_mission_summary.json").read_text())
    danger = json.loads((run / "visualization/danger_truth_evaluation.json").read_text())
    if acceptance.get("passed") is not True:
        raise SystemExit(f"ERROR: seed {seed} acceptance is not PASS")
    failed_checks = [k for k, value in acceptance.get("checks", {}).items() if value is not True]
    if failed_checks:
        raise SystemExit(f"ERROR: seed {seed} failed checks: {failed_checks}")
    if mission.get("exploration_time_basis") != "ros_simulation_time":
        raise SystemExit(f"ERROR: seed {seed} does not use ROS simulation time")
    if float(mission.get("exploration_duration_sec", 1e99)) > 600.0:
        raise SystemExit(f"ERROR: seed {seed} exceeds 600 simulation seconds")
    if danger.get("false_positive_count") != 0 or danger.get("false_negative_count") != 0:
        raise SystemExit(f"ERROR: seed {seed} danger evaluation is not FP=0/FN=0")
    if danger.get("true_positive_count") != danger.get("truth_count"):
        raise SystemExit(f"ERROR: seed {seed} does not detect every truth danger")
    for image in core_images:
        if not (run / "visualization" / image).is_file():
            raise SystemExit(f"ERROR: seed {seed} missing visualization/{image}")
    for floor in range(1, 4):
        for image in (
            f"two_view_floor_{floor}.png",
            f"danger_truth_evaluation_floor_{floor}.png",
        ):
            if not (run / "visualization" / image).is_file():
                raise SystemExit(f"ERROR: seed {seed} missing visualization/{image}")

    forbidden = (
        "/workspace/SimEnv",
        "/root/autodl-tmp/code/restore/0803b/SimEnv",
        "/root/autodl-tmp/deps/libtorch",
        "overall_l0829",
    )
    for json_path in run.rglob("*.json"):
        data = json_path.read_text(errors="replace")
        hit = next((item for item in forbidden if item in data), None)
        if hit:
            raise SystemExit(f"ERROR: seed {seed} evidence contains forbidden path {hit}: {json_path}")

print("Five-run acceptance evidence and retained result directories passed.")
PY

echo "Bundle checksum and structural verification passed: $BUNDLE_ROOT"
