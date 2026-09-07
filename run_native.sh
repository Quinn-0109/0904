#!/usr/bin/env bash
# Relocatable top-level entrypoint. Usage: bash run_native.sh RUN_NAME SEED
set -Eeuo pipefail

BUNDLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$BUNDLE_ROOT/threefloor_stress5_repro_20260827/run_native.sh" "$@"
