#!/usr/bin/env bash
# Build a relocatable Linux deployment archive while preserving modes and symlinks.
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d_%H%M%S)"
RELEASE_NAME="${RELEASE_NAME:-0902overall_deploy_$STAMP}"
OUTPUT_DIR="${OUTPUT_DIR:-$(dirname "$ROOT")}"
ARCHIVE="$OUTPUT_DIR/$RELEASE_NAME.tar.gz"
CHECKSUM="$ARCHIVE.sha256"
TMP_DIR="$(mktemp -d)"
FILE_LIST="$TMP_DIR/files.list0"
MANIFEST_TMP="$TMP_DIR/MANIFEST.sha256"
trap 'rm -rf "$TMP_DIR"' EXIT

cd "$ROOT"
mkdir -p "$OUTPUT_DIR"

required_results=()
for seed in $(seq 22 31); do
  required_results+=("results/oblique_final10_fixbend_seed${seed}_b1")
done
for seed in $(seq 32 36); do
  required_results+=("results/portable_accept_seed${seed}")
done

for path in \
  run_native.sh preflight.sh verify_bundle.sh README_运行说明.md \
  threefloor_stress5_repro_20260827/run_native.sh \
  runtime_assets/SimEnv/runtime_bin/junior_ctrl_validated \
  runtime_assets/SimEnv/src/unitree_guide/logs/policy_act_inference_plane.pt \
  runtime_assets/SimEnv/src/unitree_guide/logs/policy_act_inference_stair.pt \
  third_party/libtorch/lib/libtorch.so; do
  if [[ ! -e "$path" ]]; then
    echo "ERROR: required deployment file missing: $ROOT/$path" >&2
    exit 2
  fi
done

for result_dir in "${required_results[@]}"; do
  if [[ ! -d "$result_dir" ]]; then
    echo "ERROR: required retained acceptance result missing: $result_dir" >&2
    exit 2
  fi
done

# Select stable deliverables only. Generated caches/build spaces are rebuilt on
# the destination machine and are intentionally excluded.
find . -mindepth 1 \
  \( -type d \( \
       -name .git -o -name __pycache__ -o -name .pytest_cache -o \
       -name .ipynb_checkpoints -o -name .catkin_tools -o \
       -name build -o -name devel -o -name install -o \
       -path './.portable_build' -o -path './SimEnv-master/.portable' -o \
       -path './results' \
     \) -prune \) -o \
  \( \( -type f -o -type l \) \
     ! -name '*.pyc' \
     ! -path './MANIFEST.sha256' \
     ! -path './SimEnv-master.zip' \
     ! -path './threefloor_stress5_repro_20260827.zip' \
     -print0 \) > "$FILE_LIST"

for result_dir in "${required_results[@]}"; do
  find "./$result_dir" \( -type f -o -type l \) -print0 >> "$FILE_LIST"
done

sort -zu "$FILE_LIST" -o "$FILE_LIST"

while IFS= read -r -d '' path; do
  if [[ -f "$path" && ! -L "$path" ]]; then
    sha256sum "$path"
  fi
done < "$FILE_LIST" > "$MANIFEST_TMP"

# Replace the stale manifest with one matching exactly the stable release files.
mv "$MANIFEST_TMP" MANIFEST.sha256
printf './MANIFEST.sha256\0' >> "$FILE_LIST"
sort -zu "$FILE_LIST" -o "$FILE_LIST"

selected_bytes="$(
  while IFS= read -r -d '' path; do
    if [[ -f "$path" && ! -L "$path" ]]; then
      stat -c '%s' "$path"
    fi
  done < "$FILE_LIST" | awk '{total += $1} END {printf "%.0f", total}'
)"
free_kb="$(df -Pk "$OUTPUT_DIR" | awk 'NR == 2 {print $4}')"
need_kb="$((selected_bytes / 1024 + 262144))"
printf '[bundle] selected uncompressed size: %.2f GiB\n' "$(awk -v b="$selected_bytes" 'BEGIN {print b/1073741824}')"
printf '[bundle] output filesystem free: %.2f GiB\n' "$(awk -v k="$free_kb" 'BEGIN {print k/1048576}')"
if (( free_kb < need_kb )); then
  echo "ERROR: insufficient space to create the archive safely." >&2
  echo "Set OUTPUT_DIR to another mounted disk with at least $((need_kb / 1048576 + 1)) GiB free." >&2
  exit 3
fi

rm -f "$ARCHIVE" "$CHECKSUM"
tar --create --gzip --file="$ARCHIVE" \
  --no-recursion \
  --transform="s#^\\./#$RELEASE_NAME/#" \
  --null --files-from="$FILE_LIST"

tar -tzf "$ARCHIVE" >/dev/null
sha256sum "$ARCHIVE" > "$CHECKSUM"

echo "DEPLOYMENT ARCHIVE OK"
echo "archive:  $ARCHIVE"
echo "checksum: $CHECKSUM"
echo
echo "Destination verification:"
echo "  sha256sum -c $(basename "$CHECKSUM")"
echo "  tar -xzf $(basename "$ARCHIVE")"
echo "  cd $RELEASE_NAME"
echo "  bash verify_bundle.sh && bash preflight.sh"
echo "  bash run_native.sh manual_seed40 40"
