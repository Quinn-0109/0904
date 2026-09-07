# 0902overall 三层自主探索原生运行包

本目录是可复制、可在任意路径解压的原生运行包。它包含三层仿真场景、`simenv_competitor`、SCAN-Planner、平面/楼梯策略、LibTorch 2.1.2，以及已通过的十轮原验收结果和五轮便携包验收结果。

## 环境要求

已验证环境：

- Ubuntu 20.04 x86_64
- ROS Noetic
- Gazebo 11
- Python 3.8
- GCC 9、CMake 3.16、catkin
- NVIDIA 驱动及兼容 CUDA 11.8 的运行环境
- Python 模块：`numpy`、`opencv-python/cv2`、`PyYAML`、`matplotlib`

LibTorch 2.1.2 已内置于 `third_party/libtorch`，无需另行下载。接收方仍需安装 ROS、Gazebo、NVIDIA 驱动和兼容 CUDA；未验证其他 Ubuntu 发行版或 CPU-only 机器。

建议解压后至少预留 1 GiB 可用空间，用于首次构建和结果输出。首次运行会在包内重建 SimEnv controller 与 SCAN-Planner 的独立 build/devel 空间，因此准备阶段明显慢于后续运行；准备时间不计入 600 秒探索仿真时间。

## 解压与完整性校验

```bash
cd /path/to/0902overall
bash verify_bundle.sh
bash preflight.sh
```

`verify_bundle.sh` 会按照 `MANIFEST.sha256` 校验所有交付文件。`preflight.sh` 检查操作系统、ROS/Gazebo、编译工具、Python 模块、GPU/CUDA、磁盘空间、场景、策略和动态库。

## 单轮运行

运行名必须唯一，随机种子为整数：

```bash
cd /path/to/0902overall
bash run_native.sh manual_seed40 40
```

结果写入：

```text
results/manual_seed40/
```

主要结果包括：

- `three_floor_rl_acceptance.json`：总体验收结论
- `three_floor_rl_mission_summary.json`：仿真计时、阶段和返回状态
- `physical_two_view_room_evidence.json`：12 个房间的双视点与几何证据
- `visualization/three_floor_topdown_trajectories.png`：三层总轨迹
- `visualization/two_view_all_floors.png`：三层双视点图
- `visualization/danger_truth_evaluation_all_floors.png`：危险源真值、TP、FP、FN

## 连续多轮运行

以下命令遇到任一轮失败会立即停止：

```bash
set -Eeuo pipefail
cd /path/to/0902overall
for seed in 40 41 42 43 44; do
  bash run_native.sh "portable_seed${seed}" "$seed"
done
```

每轮合格条件为：仿真时间不超过 600 秒；完成三层、12 个房间、24 次不少于 210° 的扫描并返回第一层起点；所有实时三维净距和房间几何合同通过；危险源检测 FP=0、FN=0。

### 二十轮稳定性验收

固定种子 40–59 的连续验收入口为：

```bash
cd /path/to/0902overall
bash run_stable20_v2.sh
```

任一轮失败时脚本立即停止，修复后必须清理未完成的正式计数目录，再从 seed40 重新开始。正式结果名为 `stable20_v2_seed40` 至 `stable20_v2_seed59`。

当前稳定性合同为：开放房计划双视点间距至少 2.45 m（安全回退 2.30 m），实际至少 2.20 m（回退 2.10 m）；可靠区域双视差至少 30°；危险源必须对 G3/G4 都通过 ±0.12 m 到点误差、±8° 朝向误差、1.15–3.80 m 距离、0.35 m 视线净距和至少 10 px 投影半径检查。房内导航速度配置为 0.86，走廊纵向上限为 2.15 m/s、横向上限为 0.45 m/s；房门和楼梯速度未提高。

100 组静态随机化检查可单独运行：

```bash
python3 threefloor_stress5_repro_20260827/work/mounts/SimEnv/src/simenv_bridge/scripts/validate_stable20_static_randomization.py \
  --layout runtime_assets/SimEnv/generated_building/elevator_three_floor_debug/layout_metadata.json \
  --world runtime_assets/SimEnv/generated_building/elevator_three_floor_debug/competition_scene_with_dangers.world \
  --seed-first 40 --seed-last 139 \
  --output results/stable20_v2_static_seeds40_139.json
```

## 可选相机 MP4

便携包验收默认关闭 MP4 编码，但 RGB-D 在线危险源检测始终开启。需要保存相机视频时运行：

```bash
RECORD_CAMERA_VIDEO=true bash run_native.sh manual_video_seed40 40
```

视频保存在对应结果目录内。录像会增加磁盘和计算开销，建议运行前确认剩余空间。

## 已有验收结果

- 原连续十轮：`results/oblique_final10_fixbend_seed22_b1` 至 `seed31_b1`
- 便携包连续五轮：`results/portable_accept_seed32` 至 `portable_accept_seed36`
- 五轮明细见 `PORTABLE_FIVE_RUN_ACCEPTANCE_REPORT.md`

不要把运行名设为已有结果目录名，否则入口会因结果冲突或覆盖风险而失败。若首次构建失败，先依据 `preflight.sh` 的缺项提示补齐系统依赖，不要改用包外 SimEnv 或 LibTorch 路径。
