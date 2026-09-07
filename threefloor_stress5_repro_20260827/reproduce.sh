#!/usr/bin/env bash
# 三层楼 RL 步态任务 — 源码复现（2026-08-26 压测版本）
# 用法:  bash reproduce.sh [round_name] [seed_offset]
#   round_name  默认 repro_r1
#   seed_offset 默认 1（1-5 = 压测五轮的原场景）
set -euo pipefail

PKG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROUND="${1:-repro_r1}"
SEED="${2:-1}"
WORK="$PKG/work"
OVERALL_RESULTS_ROOT="$(cd "$PKG/.." && pwd)/results"

IMG="simenv-exploration:threefloor"
CTR="threefloor-repro-${ROUND}"

# 0) 镜像必须已存在（本源码包不含镜像；镜像需自行准备，见 README 前置说明）
if ! docker image inspect "$IMG" >/dev/null 2>&1; then
  echo "缺少镜像 $IMG —— 本包只含源码。请先在目标机上准备该镜像" >&2
  echo "（压测所用镜像 ID: sha256:e752538b4f5f 开头），再重试。" >&2
  exit 1
fi

# 1) 解开源码到 work/（保持压测时的挂载布局）
echo "[1/3] 解开源码..."
mkdir -p "$WORK/mounts/SimEnv/src" "$WORK/mounts/SCAN-Planner" "$OVERALL_RESULTS_ROOT"
if [ ! -d "$WORK/mounts/SimEnv/src/simenv_bridge" ]; then
  tar -C "$WORK/mounts/SimEnv/src" -xzf "$PKG/src/simenv_bridge.tar.gz"
fi
if [ ! -d "$WORK/mounts/SCAN-Planner/src" ]; then
  tar -C "$WORK/mounts/SCAN-Planner" -xzf "$PKG/src/scan_planner_src.tar.gz"
fi

# 2) 起容器（与压测时完全一致的挂载/GPU/shm 配方；注意必须显式
#    传 tail -f /dev/null —— 镜像默认 Cmd 是裸 bash，-d 起来即退出）
echo "[2/3] 启动容器 $CTR ..."
docker rm -f "$CTR" >/dev/null 2>&1 || true
docker run -d --name "$CTR" \
  --gpus all --shm-size 2g \
  -v "$WORK/mounts/SimEnv/src/simenv_bridge":/workspace/SimEnv/src/simenv_bridge \
  -v "$WORK/mounts/SCAN-Planner/src":/workspace/SCAN-Planner/src \
  -v "$OVERALL_RESULTS_ROOT":/workspace/SimEnv/results \
  "$IMG" tail -f /dev/null

# 3) 跑一轮任务（runner 自带控制器重建/场景准备/验收）
echo "[3/3] 启动任务: RUN_NAME=$ROUND seed=$SEED (预计 35-45 分钟)"
docker exec -d "$CTR" bash -c \
  "cd /workspace/SimEnv/src/simenv_bridge/scripts && \
   THREE_FLOOR_SEED_OFFSET=$SEED MAX_WALL_SEC=3000 RUN_NAME=$ROUND \
   bash run_scanplanner_three_floor_rl.sh $ROUND > /tmp/${ROUND}.log 2>&1"
cat <<'EOF'

任务已后台启动。跟踪方式：
  docker exec threefloor-repro-XXX tail -f /tmp/<round>.log          # runner 输出
  docker exec threefloor-repro-XXX tail -30 \
    /workspace/SimEnv/results/<round>/roslaunch.log                  # 节点输出
终态判定：
  docker exec threefloor-repro-XXX python3 -c "
import json;d=json.load(open('/workspace/SimEnv/results/<round>/mission_stage_timing.json'))
print(d['status'], d.get('failure_reason'))"

场景随机化由 THREE_FLOOR_SEED_OFFSET 决定（1-5 复刻压测五轮场景）；
步态稳定性是策略级随机（同场景不同轮结果可能不同，见 README 预期表）。
EOF
