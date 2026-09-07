# 三层探索原生仿真十轮重复实验报告

## 1. 结论

- 运行方式：本机原生运行（非 Docker）。
- 最终连续验收随机种子：22–31，共 10 轮。
- 验收结果：10/10 通过。
- 每轮均完成三层探索、12 个房间进入/退出、每房间 G3/G4 双视点扫描，共 24 次扫描，并返回第一层起点大厅。
- 每轮探索仿真时间均不超过 600 s；环境和算法启动准备时间不计入探索时间。
- 十轮危险源检测均为 `FP=0、FN=0`。
- 十轮结果均保存了三层轨迹图、逐层双视点图和危险源真值/检测图。
- 本次连续十轮验收关闭了可选 MP4 编码，因此这些验收目录中没有相机 MP4；RGB-D 在线检测仍然开启。

## 2. 最终修正

最终稳定性修正针对房内 A* 折点的实际到达偏差：规划路径本身满足净距，但旧的折点到达容差可能使机器人切弯并接近家具。

- 配置新增：`room_internal_path_bend_tolerance_m: 0.12`
- 房内 G3/G4 路径折点以及 RETURN/EXIT 内侧折点均使用 0.12 m 到达容差。
- 实时三维安全净距仍保持 0.42 m，没有降低碰撞验收标准。
- 平面速度上限保持 2.25 m/s，房门和楼梯速度未提高。

相关文件：

- `threefloor_stress5_repro_20260827/work/mounts/SimEnv/src/simenv_bridge/config/three_floor_rl_mission.json`
- `threefloor_stress5_repro_20260827/work/mounts/SimEnv/src/simenv_bridge/scripts/randomize_three_floor_scene.py`

## 3. 连续十轮结果

探索时间采用 ROS/Gazebo 仿真时间 `ros_simulation_time`，不包含环境准备阶段。

| 种子 | 结果目录 | 探索仿真时间 (s) | 房间 | 扫描点 | TP | FP | FN | 返回起点 | 结果 |
|---:|---|---:|---:|---:|---:|---:|---:|:---:|:---:|
| 22 | `oblique_final10_fixbend_seed22_b1` | 589.723 | 12 | 24 | 6 | 0 | 0 | 是 | 通过 |
| 23 | `oblique_final10_fixbend_seed23_b1` | 582.660 | 12 | 24 | 3 | 0 | 0 | 是 | 通过 |
| 24 | `oblique_final10_fixbend_seed24_b1` | 570.317 | 12 | 24 | 5 | 0 | 0 | 是 | 通过 |
| 25 | `oblique_final10_fixbend_seed25_b1` | 590.057 | 12 | 24 | 6 | 0 | 0 | 是 | 通过 |
| 26 | `oblique_final10_fixbend_seed26_b1` | 564.211 | 12 | 24 | 5 | 0 | 0 | 是 | 通过 |
| 27 | `oblique_final10_fixbend_seed27_b1` | 570.092 | 12 | 24 | 6 | 0 | 0 | 是 | 通过 |
| 28 | `oblique_final10_fixbend_seed28_b1` | 588.520 | 12 | 24 | 5 | 0 | 0 | 是 | 通过 |
| 29 | `oblique_final10_fixbend_seed29_b1` | 585.467 | 12 | 24 | 6 | 0 | 0 | 是 | 通过 |
| 30 | `oblique_final10_fixbend_seed30_b1` | 573.499 | 12 | 24 | 5 | 0 | 0 | 是 | 通过 |
| 31 | `oblique_final10_fixbend_seed31_b1` | 588.103 | 12 | 24 | 3 | 0 | 0 | 是 | 通过 |

汇总审计：

- 120/120 个房间合同通过。
- 120/120 个房间均按 `ENTRY → G3 deep → G4 near → RETURN → EXIT` 的时序完成。
- 房型分布：开放房 110、门前/浅障碍房 6、深处障碍房 4。
- 策略分布：`open_middle_deep_then_near_oblique` 110、`front_obstacle_side_bypass_oblique` 6、`deep_obstacle_front_oblique_pair` 4。
- 120 个房间全部使用首选几何合同，无放宽回退。
- 最小实际扫描角为 210.619°。
- 通过实时三维审计的最小净距为 0.482 m，高于 0.42 m 门槛。

## 4. 结果和可视化路径

统一结果根目录：

```text
/root/autodl-tmp/code/restore/0803b/overall_l0829/results
```

十轮结果目录：

```text
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed22_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed23_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed24_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed25_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed26_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed27_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed28_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed29_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed30_b1
/root/autodl-tmp/code/restore/0803b/overall_l0829/results/oblique_final10_fixbend_seed31_b1
```

每一轮的可视化目录均为：

```text
<该轮结果目录>/visualization
```

主要可视化文件：

- `three_floor_topdown_trajectories.png`：三层完整轨迹。
- `two_view_all_floors.png`：全部楼层双视点汇总。
- `danger_truth_evaluation_all_floors.png`：危险源真值、TP、FP、FN 汇总。
- `topdown_floor_1.png`、`topdown_floor_2.png`、`topdown_floor_3.png`：各楼层俯视轨迹（若目录中按楼层编号命名，以实际生成名称为准）。

主要 JSON 证据：

- `three_floor_rl_acceptance.json`：总体验收检查项。
- `three_floor_rl_mission_summary.json`：仿真计时、阶段事件、最终位置和任务状态。
- `physical_two_view_acceptance.json`：12 个房间的实际双视点合同。
- `scanplanner_route_summary.json`：路线执行摘要。

## 5. 手动运行命令

### 5.1 单轮运行

下面命令以种子偏移 32 为例。结果会写入 `overall_l0829/results/manual_native_seed32`：

```bash
cd /root/autodl-tmp/code/restore/0803b/overall_l0829/threefloor_stress5_repro_20260827
bash run_native.sh manual_native_seed32 32
```

参数含义：

```text
bash run_native.sh <唯一的运行名称> <随机种子偏移>
```

每次应使用新的运行名称，以免与已有结果目录混淆。

### 5.2 连续手动运行十轮

仿真会占用同一个 ROS master、Gazebo 和显示环境，因此应顺序执行，不建议并行启动十轮。

```bash
cd /root/autodl-tmp/code/restore/0803b/overall_l0829/threefloor_stress5_repro_20260827
for seed in $(seq 32 41); do
  run_name="manual_native_seed_${seed}"
  bash run_native.sh "$run_name" "$seed" || exit 1
done
```

### 5.3 可选：录制相机 MP4

默认 `RECORD_CAMERA_VIDEO=false`。如确实需要视频，可单轮启用：

```bash
cd /root/autodl-tmp/code/restore/0803b/overall_l0829/threefloor_stress5_repro_20260827
RECORD_CAMERA_VIDEO=true bash run_native.sh manual_video_seed32 32
```

启用编码后会增加机器负载；它不属于上表十轮验收时采用的配置，因此应单独记录结果。

## 6. 所需目录与外部依赖

### 6.1 位于 `overall_l0829` 内的项目内容

| 用途 | 当前路径 |
|---|---|
| 原生运行入口 | `/root/autodl-tmp/code/restore/0803b/overall_l0829/threefloor_stress5_repro_20260827/run_native.sh` |
| 任务桥接、随机场景和验收代码 | `/root/autodl-tmp/code/restore/0803b/overall_l0829/threefloor_stress5_repro_20260827/work/mounts/SimEnv` |
| SCAN-Planner 源码和已编译工作空间 | `/root/autodl-tmp/code/restore/0803b/overall_l0829/threefloor_stress5_repro_20260827/work/mounts/SCAN-Planner` |
| 原生 SimEnv/ROS 工作空间 | `/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master` |
| 输出目录 | `/root/autodl-tmp/code/restore/0803b/overall_l0829/results` |

### 6.2 位于 `overall_l0829` 外、当前默认运行会使用的目录

| 类型 | 当前路径 | 是否需要 | 说明 |
|---|---|:---:|---|
| 场景和运行资产 | `/root/autodl-tmp/code/restore/0803b/SimEnv` | 是 | 当前 `run_native.sh` 默认把 `SIMENV_ASSET_ROOT` 指向这里；三层 world、布局 metadata 和生成模型目前只在该目录完整存在。 |
| LibTorch 动态库 | `/root/autodl-tmp/deps/libtorch` | 是 | 当前 `run_native.sh` 默认把 `SIMENV_TORCH_ROOT` 指向这里，并将其 `lib` 加入 `LD_LIBRARY_PATH`。 |

外部场景目录中本次运行实际需要的关键资产包括：

```text
/root/autodl-tmp/code/restore/0803b/SimEnv/generated_building/elevator_three_floor_debug/competition_scene_with_dangers.world
/root/autodl-tmp/code/restore/0803b/SimEnv/generated_building/elevator_three_floor_debug/layout_metadata.json
/root/autodl-tmp/code/restore/0803b/SimEnv/generated_building/elevator_three_floor_debug/model.sdf
/root/autodl-tmp/code/restore/0803b/SimEnv/src/unitree_guide/logs/policy_act_inference_plane.pt
/root/autodl-tmp/code/restore/0803b/SimEnv/src/unitree_guide/logs/policy_act_inference_stair.pt
```

其中两个策略 `.pt` 在 `overall_l0829/SimEnv-master` 中也有副本，但所需三层生成场景文件在 `SimEnv-master` 和 `work/mounts/SimEnv` 中并不完整。因此，按当前目录布局运行时，不能只保留 `overall_l0829` 而删除 `/root/autodl-tmp/code/restore/0803b/SimEnv`。

### 6.3 机器级软件环境

这些不是本项目代码目录，但换机器运行时同样需要准备：

- ROS Noetic（通常在 `/opt/ros/noetic`）。
- Gazebo 及其 ROS 插件（本机 `gzserver` 位于 `/usr/bin/gzserver`）。
- NVIDIA 驱动/CUDA 运行环境，以及任务所需的 Python/ROS 包。
- 可用的图形或无头显示环境。

所以准确结论是：**修改后的项目代码都在 `overall_l0829` 内，但当前可运行环境不是只靠这一个目录；还依赖目录外的 `/0803b/SimEnv` 场景资产、`/root/autodl-tmp/deps/libtorch`，以及系统安装的 ROS/Gazebo/CUDA 环境。**

如需把项目迁移成一个自包含目录，应先复制上述场景资产和 LibTorch，再通过 `SIMENV_ASSET_ROOT`、`SIMENV_TORCH_ROOT` 覆盖默认路径；迁移后还需要重新验证 ROS/Gazebo 插件和动态库解析，不能只改路径后默认视为验收通过。
