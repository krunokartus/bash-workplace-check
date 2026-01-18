#!/bin/bash
# Description: Checks system uptime and warns if it has been running too long without a reboot.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

# 2. Configuration
# Max days before warning (default: 30 days)
MAX_UPTIME_DAYS=30

log_info "Starting Uptime check..."

# 3. Data gathering
# Get uptime in days (using /proc/uptime for precision or 'uptime -p')
# uptime -p output looks like: "up 1 week, 2 days, 3 hours, 4 minutes"
# We'll use the seconds from /proc/uptime and convert to days
uptime_seconds=$(cat /proc/uptime | awk '{print $1}' | cut -d. -f1)
uptime_days=$((uptime_seconds / 60 / 60 / 24))
human_uptime=$(uptime -p)

# 4. Logical check
if [ "$uptime_days" -ge "$MAX_UPTIME_DAYS" ]; then
    log_warn "System has been up for a long time: $uptime_days days."
    log_info "Recommendation: Consider rebooting to apply pending kernel updates."
    exit 1
fi

log_info "Current system uptime: $human_uptime ($uptime_days days)."
exit 0
