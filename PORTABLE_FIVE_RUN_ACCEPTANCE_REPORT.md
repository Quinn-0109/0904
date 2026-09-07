# 0902overall 便携包连续五轮验收报告

## 结论

从 `0902overall/run_native.sh` 顺序运行随机种子 32–36，五轮连续通过。每轮均以 ROS/Gazebo 仿真时间计时，环境和算法准备时间不计入 600 秒；完成三层、12 个房间、24 个双视点扫描并返回第一层起点；每个扫描点不少于 210°；实时三维净距、房间几何合同和危险源检测全部通过。

运行证据中的项目路径均位于 `0902overall`，五轮核心 JSON 未引用 `/workspace/SimEnv`、原 `/0803b/SimEnv`、`/root/autodl-tmp/deps/libtorch` 或 `overall_l0829`。

## 五轮结果

| 运行名 | 种子 | 仿真时间（秒） | 真值数 | TP | FP | FN | 验收 |
|---|---:|---:|---:|---:|---:|---:|---|
| `portable_accept_seed32` | 32 | 598.989 | 5 | 5 | 0 | 0 | PASS |
| `portable_accept_seed33` | 33 | 575.570 | 6 | 6 | 0 | 0 | PASS |
| `portable_accept_seed34` | 34 | 597.702 | 5 | 5 | 0 | 0 | PASS |
| `portable_accept_seed35` | 35 | 597.764 | 4 | 4 | 0 | 0 | PASS |
| `portable_accept_seed36` | 36 | 588.880 | 3 | 3 | 0 | 0 | PASS |

## 结果路径

每轮结果根目录为 `results/portable_accept_seed<种子>/`，可视化目录为：

- `/root/autodl-tmp/code/restore/0803b/0902overall/results/portable_accept_seed32/visualization`
- `/root/autodl-tmp/code/restore/0803b/0902overall/results/portable_accept_seed33/visualization`
- `/root/autodl-tmp/code/restore/0803b/0902overall/results/portable_accept_seed34/visualization`
- `/root/autodl-tmp/code/restore/0803b/0902overall/results/portable_accept_seed35/visualization`
- `/root/autodl-tmp/code/restore/0803b/0902overall/results/portable_accept_seed36/visualization`

解压到其他路径后，应使用对应的相对路径，例如 `results/portable_accept_seed32/visualization/`。

每轮均包含以下核心图片：

- `three_floor_topdown_trajectories.png`
- `two_view_floor_1.png`、`two_view_floor_2.png`、`two_view_floor_3.png`
- `two_view_all_floors.png`
- `danger_truth_evaluation_floor_1.png`、`floor_2.png`、`floor_3.png`
- `danger_truth_evaluation_all_floors.png`

## 验收配置说明

- 房间顺序：`ENTRY → G3 deep → G4 near → RETURN → EXIT`
- 平面房间导航/转运速度系数：0.825；全局平面速度上限仍为 2.25 m/s
- 房门与楼梯前进速度未提高，碰撞净距未降低
- 门前障碍房仅在原 24 个候选无解时扩展搜索到 96 个候选；扩展候选仍需通过相同 A*、净距、前后关系、横向差和覆盖率合同
- `RECORD_CAMERA_VIDEO=false`；RGB-D 在线危险源检测保持开启
