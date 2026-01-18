#!/bin/bash
# Description: Monitors the number of running processes and checks for zombie processes.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

# 2. Configuration
# Process count threshold (warn if more than 300 - adjust for your environment)
MAX_PROCESSES=300

log_info "Starting Running Processes check..."

# 3. Data gathering
# Total processes
total_procs=$(ps aux | wc -l)
# Zombie processes (stat 'Z')
zombie_count=$(ps aux | awk '{print $8}' | grep -c "Z")

# 4. Logical check
# Check total count
if [ "$total_procs" -gt "$MAX_PROCESSES" ]; then
    log_warn "High number of processes detected: $total_procs (Threshold: $MAX_PROCESSES)"
fi

# Check for zombies
if [ "$zombie_count" -gt 0 ]; then
    log_warn "Zombie processes detected: $zombie_count"
    log_info "Run 'ps aux | grep Z' to identify them."
    # We might want to exit 1 if zombies are found
fi

# Final summary
if [ "$total_procs" -le "$MAX_PROCESSES" ] && [ "$zombie_count" -eq 0 ]; then
    log_info "Process count is normal: $total_procs. No zombie processes found."
    exit 0
else
    # Exit with 1 if any warning was triggered
    exit 1
fi
