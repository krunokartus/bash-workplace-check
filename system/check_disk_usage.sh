#!/bin/bash
# Description: Checks disk usage on the root partition and warns if it exceeds a threshold.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

# 2. Configuration
# Threshold in percentage
THRESHOLD=80
PARTITION="/"

log_info "Starting Disk Usage check on partition: $PARTITION"

# 3. Data gathering
# Use df to get usage percentage, NR==2 gets the second row (data row)
current_usage=$(df -h "$PARTITION" | awk 'NR==2 {print $5}' | sed 's/%//')
available_space=$(df -h "$PARTITION" | awk 'NR==2 {print $4}')

# 4. Logical check
if [ "$current_usage" -gt "$THRESHOLD" ]; then
    log_warn "Disk usage is high: ${current_usage}% (Threshold: ${THRESHOLD}%)"
    log_info "Available space on $PARTITION: $available_space"
    exit 1
fi

log_info "Disk usage is healthy: ${current_usage}% (Available: $available_space)"
exit 0
