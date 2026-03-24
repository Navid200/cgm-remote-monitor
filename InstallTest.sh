#!/bin/bash

LOG_DIR="/xDrip/Logs_Stress"
mkdir -p "$LOG_DIR"

run=1

while true
do
  echo "===== Run $run ====="

  cd /srv || exit 1
  rm -rf *

  LOG_FILE="$LOG_DIR/run_${run}.log"

  # Clone repo (same as bootstrap)
  git clone https://github.com/Navid200/cgm-remote-monitor.git >> "$LOG_FILE" 2>&1 || break

  REPO_DIR=$(ls /srv)
  cd "$REPO_DIR" || exit 1

  # Checkout same branch as bootstrap
  git checkout Phase1Troubleshoot >> "$LOG_FILE" 2>&1

  echo "Starting run $run" >> "$LOG_FILE"

  npm cache clean --force >> "$LOG_FILE" 2>&1
  # Install
  npm install >> "$LOG_FILE" 2>&1

  # Verify (same logic as Phase 1)
  if [ "$(ls -A node_modules | grep -v '^\.cache$' | wc -l)" -eq 0 ]
  then
    echo "FAILURE detected on run $run" | tee -a "$LOG_FILE"
    break
  fi

  echo "Run $run succeeded" >> "$LOG_FILE"

  run=$((run+1))
done

echo "Stopped after failure on run $run"  
