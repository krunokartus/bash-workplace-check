#!/bin/bash
# Description: Checks RAM and Swap usage to monitor system memory pressure.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

# 2. Configuration
# Warn if memory usage is above 85%
MEM_THRESHOLD=85
# Warn if swap is used more than 20% (swap usage often indicates memory pressure)
SWAP_THRESHOLD=20

log_info "Starting Memory Pressure check..."

# 3. Data gathering using 'free' and 'awk'
# Memory calculation: (used / total) * 100
mem_total=$(free | grep Mem | awk '{print $2}')
mem_used=$(free | grep Mem | awk '{print $3}')
mem_percent=$((mem_used * 100 / mem_total))

# Swap calculation
swap_total=$(free | grep Swap | awk '{print $2}')
swap_used=$(free | grep Swap | awk '{print $3}')

# Avoid division by zero if swap is disabled
if [ "$swap_total" -gt 0 ]; then
    swap_percent=$((swap_used * 100 / swap_total))
else
    swap_percent=0
fi

# 4. Logical check
warning_triggered=0

if [ "$mem_percent" -gt "$MEM_THRESHOLD" ]; then
    log_warn "Memory usage is high: ${mem_percent}% (Threshold: ${MEM_THRESHOLD}%)"
    warning_triggered=1
fi

if [ "$swap_percent" -gt "$SWAP_THRESHOLD" ]; then
    log_warn "Swap usage is high: ${swap_percent}% (Threshold: ${SWAP_THRESHOLD}%)"
    log_info "High swap usage might indicate your RAM is not enough for current tasks."
    warning_triggered=1
fi

# Final status
if [ "$warning_triggered" -eq 0 ]; then
    log_info "Memory and Swap usage are healthy."
    log_info "RAM Used: ${mem_percent}% | Swap Used: ${swap_percent}%"
    exit 0
else
    exit 1
fi
