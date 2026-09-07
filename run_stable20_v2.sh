#!/usr/bin/env bash
# Continuous acceptance batch. Any failing seed stops the batch so the next
# attempt must restart at seed 40 after the root cause is corrected.
set -Eeuo pipefail

BUNDLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_ROOT="${RESULTS_ROOT:-$BUNDLE_ROOT/results}"

for seed in $(seq 40 59); do
  run_name="stable20_v2_seed${seed}"
  echo "[stable20] starting $run_name"
  if [ -e "$RESULTS_ROOT/$run_name" ]; then
    echo "ERROR: result already exists; continuous count must start clean: $RESULTS_ROOT/$run_name" >&2
    exit 2
  fi
  bash "$BUNDLE_ROOT/run_native.sh" "$run_name" "$seed"
  test -f "$RESULTS_ROOT/$run_name/three_floor_rl_mission_summary.json"
  echo "[stable20] passed $run_name"
  echo "[stable20] visualization: $RESULTS_ROOT/$run_name/visualization"
done

echo "[stable20] all seeds 40-59 passed continuously"
