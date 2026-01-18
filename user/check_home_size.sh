#!/bin/bash
# Description: Checks the disk usage of the current user's home directory.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting Home Directory size check for user: $USER"

# 2. Configuration
# Threshold in Megabytes (e.g., 5000 MB = 5 GB)
THRESHOLD_MB=5000

# 3. Data gathering
# du -sm: s for summary, m for megabytes
home_size_mb=$(du -sm "$HOME" | awk '{print $1}')
human_size=$(du -sh "$HOME" | awk '{print $1}')

log_info "Current home directory size: $human_size ($home_size_mb MB)"

# 4. Logical check
if [ "$home_size_mb" -gt "$THRESHOLD_MB" ]; then
    log_warn "Home directory size exceeds threshold ($THRESHOLD_MB MB)!"
    log_info "Consider cleaning up large files or downloads."
    exit 1
fi

log_info "Home directory size is within healthy limits."
exit 0
