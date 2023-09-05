#!/usr/bin/env bash

N=50000 # Number of times to run.
K=24    # Number of jobs to run in parallel.

# K=12 : replicates what bazel does on my machine (b/c it has 12 cores).
# K=1  : I still see errors (at roughly the same rate) but it takes longer.
# K=50 : Again, roughly the same error rate, but faster to run.

exe=./code/mkTrivial.exe

# Make sure the executable exists.
if [[ ! -x $exe ]]; then
  ./compile.sh || exit 1
  if [[ ! -x $exe ]]; then
    echo "Failed to compile $exe"
    exit 1
  fi
fi

# Stats to keep
started=0
finished=0
failures=0

# Run a single job, test its exit code, and print its output if it fails.
# This function is called in the background.
job() {
  log=$(printf ./runtime_flake_%06d.log $1)
  ${exe} >${log} 2>&1
  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    # clear the line:
    echo -ne "\r\033[K"
    echo "============================================================"
    echo "Job $1 Failed with exit code $exit_code.  Output in ${log}:"
    cat ${log}
    return 1
  fi
  rm ${log}
  return 0
}

# Print the current status of the jobs.
update_status() {
  echo -ne \
    "\r\033[K$started started," \
    "$finished finished, " \
    "$(($started - $finished)) running, " \
    "$failures failures.\r"
}

# Run a single job in the background.
run_one() {
  ((started += 1))
  job $started &
}

# Wait for one job to finish.
wait_one() {
  exit_code=1000
  while [[ $exit_code -gt 128 ]]; do # >128 means wait was interrupted.
    update_status
    wait -n
    exit_code=$?
  done
  [[ $exit_code -ne 0 ]] && ((failures += 1))
  ((finished += 1))
}

# Handle SIGINT to cancel.
interrupted=0
interrupt() {
  echo -ne "\r\033[K"
  echo "============================================================"
  echo "Interrupted.  Waiting for running jobs to finish."
  interrupted=1
}
trap interrupt SIGINT
set -m # Prevent child processes from receiving SIGINT.

if [[ $K -gt 1 ]]; then
  # First start K jobs in parallel
  for i in $(seq 1 $K); do
    run_one
    if [[ $interrupted -eq 1 ]]; then
      break
    fi
  done

  # Then wait for one job to finish at a time, and start a new one.
  while [[ $started -lt $N ]]; do
    wait_one
    run_one
    if [[ $interrupted -eq 1 ]]; then
      break
    fi
  done

  # Wait for all remaining jobs to finish.
  while [[ $finished -lt $started ]]; do
    wait_one
  done
else # If K == 1, then we don't need to do anything fancy.
  # Run all jobs serially.
  while [[ $started -lt $N ]]; do
    ((started += 1))
    job $started
    update_status
    if [[ $interrupted -eq 1 ]]; then
      break
    fi
  done
fi

# Print final stats.
echo -ne "\r\033[K"
echo "============================================================"
echo Ran $started jobs.
fail_rate=$(echo "scale=3; $failures * 100 / $started" | bc)
echo "Failed $failures times out of $started.  (${fail_rate}%) failure rate."
