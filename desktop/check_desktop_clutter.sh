#!/bin/bash
# Description: Checks Desktop for file count and size to prevent clutter.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

# 2. Configuration
DESKTOP="$HOME/Desktop"
MAX_FILES=30
log_info "Starting Desktop health check..."

# 3. Validation
if [ ! -d "$DESKTOP" ]; then
    log_info "Desktop directory does not exist. Skipping."
    exit 0
fi

# 4. Data gathering
count=$(find "$DESKTOP" -maxdepth 1 -mindepth 1 -print | wc -l)
size=$(du -sh "$DESKTOP" | awk '{print $1}')

# 5. Logical check
if [ "$count" -gt "$MAX_FILES" ]; then
    log_warn "Clutter detected! Items: $count (Limit: $MAX_FILES)"
    log_info "Total size: $size"
    exit 1
fi

log_info "Desktop is clean. Items: $count"
log_info "Total size: $size"
