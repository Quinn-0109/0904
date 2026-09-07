#!/usr/bin/env bash
# 三层楼 RL 任务 5 轮压测 harness（2026-08-29 重跑，与 2026-08-26 压测同源码同 seed）
# 用法: bash harness.sh   （顺序跑 r1..r5 = seed 1..5，逐轮采集）
set -u
CTR=scanplanner-threefloor-three_floor_600_20260826a
OUT=/mnt/d/Code/SimEnv/scanplanner_rl_stress_20260829
RES=/mnt/d/Code/SimEnv/scanplanner_precomputed_goals_20260715_162206/workspace/simenv_reproduce/SimEnv/results
LOG=$OUT/harness.log

echo "==== STRESS6 begin $(date +%s) $(date)" >> $LOG

for i in 1 2 3 4 5; do
  RUN=stress6_r${i}
  # 结果目录必须为空
  rm -rf "$RES/$RUN"; mkdir -p "$RES/$RUN"
  echo "==== ROUND $i (seed $i) start $(date +%s) $(date)" >> $LOG
  timeout 3600 docker exec $CTR bash -c \
    "cd /workspace/SimEnv/src/simenv_bridge/scripts && \
     THREE_FLOOR_SEED_OFFSET=$i MAX_WALL_SEC=3000 RUN_NAME=$RUN \
     bash run_scanplanner_three_floor_rl.sh $RUN" \
    > $OUT/r${i}_runner.log 2>&1
  RC=$?
  echo "==== ROUND $i done rc=$RC $(date +%s) $(date)" >> $LOG

  # 采集
  D=$OUT/r${i}; mkdir -p $D
  for f in mission_stage_timing.json three_floor_rl_mission_summary.json \
           red_ball_detections.json scene_randomization.json; do
    cp "$RES/$RUN/$f" $D/ 2>/dev/null
  done
  if [ -f "$RES/$RUN/roslaunch.log" ]; then
    grep -nE 'ERROR|FATAL|Fata|error|crash|terminate|lock_error|wrapexcept|recovery reason|attitude_lost|died|process has died|exiting' \
      "$RES/$RUN/roslaunch.log" | grep -vE 'no errors|error_level' > $D/log_errors.txt
    echo "---- last 100 lines ----" >> $D/log_errors.txt
    tail -100 "$RES/$RUN/roslaunch.log" >> $D/log_errors.txt
  fi
  # 快照终态
  python3 - "$RES/$RUN/mission_stage_timing.json" >> $LOG 2>/dev/null <<'EOF'
import json,sys
try:
  d=json.load(open(sys.argv[1]))
  print(f"  status={d.get('status')} reason={d.get('failure_reason')} total={d.get('total_mission_sec')} balls={d.get('balls_detected')}")
except Exception as e: print("  (no timing json:",e,")")
EOF
done

# 汇总 json
python3 - > $OUT/stress6_report.json <<'EOF'
import json,glob,os
out={"date":"2026-08-29","rounds":[]}
for i in range(1,6):
  d=f"/mnt/d/Code/SimEnv/scanplanner_rl_stress_20260829/r{i}"
  t=json.load(open(f"{d}/mission_stage_timing.json")) if os.path.exists(f"{d}/mission_stage_timing.json") else {}
  s=json.load(open(f"{d}/three_floor_rl_mission_summary.json")) if os.path.exists(f"{d}/three_floor_rl_mission_summary.json") else {}
  b=json.load(open(f"{d}/red_ball_detections.json")) if os.path.exists(f"{d}/red_ball_detections.json") else {}
  det=b.get("detections",b) if isinstance(b,dict) else b
  out["rounds"].append({"round":i,"seed":i,
    "status":t.get("status"),"failure_reason":t.get("failure_reason"),
    "total_mission_sec":t.get("total_mission_sec"),
    "stages":t.get("stages",t.get("stage_timings")),
    "balls_total":len(det) if isinstance(det,list) else None,
    "end_pose":s.get("end_pose"),"events_tail":(s.get("events") or [])[-3:]})
print(json.dumps(out,indent=1,ensure_ascii=False))
EOF
echo "==== ALL DONE $(date +%s) $(date)" >> $LOG
