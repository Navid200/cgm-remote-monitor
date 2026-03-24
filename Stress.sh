#!/bin/bash

LOG_DIR="/xDrip/Logs/phase1_stress"
mkdir -p "$LOG_DIR"

run=1

while true
do
  echo "===== Run $run ====="

  # Clean state (important)
  cd /srv || exit 1
  cd "$(< repo)" || exit 1
  rm -rf node_modules

  LOG_FILE="$LOG_DIR/run_${run}.log"

  echo "Starting run $run" | tee "$LOG_FILE"

  # Run only the critical part (not full Phase 1)
  npm install >> "$LOG_FILE" 2>&1

  # Check result (same logic as your installer)
  if [ "$(ls -A node_modules | grep -v '^\.cache$' | wc -l)" -eq 0 ]
  then
    echo "FAILURE detected on run $run" | tee -a "$LOG_FILE"
    break
  fi

  echo "Run $run succeeded" | tee -a "$LOG_FILE"

  run=$((run+1))
done

echo "Stopped after failure on run $run"
