#!/bin/bash
# Description: Checks Downloads folder size and warns if it exceeds a limit.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

# 2. Configuration
DOWNLOADS_DIR="$HOME/Downloads"
# Limit in megabytes (e.g., 5000 MB = ~5 GB)
SIZE_LIMIT_MB=5000

log_info "Starting Downloads folder size check..."

# 3. Validation
if [ ! -d "$DOWNLOADS_DIR" ]; then
    log_info "Downloads directory does not exist. Skipping."
    exit 0
fi

# 4. Data gathering
# Get size in MB (using du -sm)
current_size_mb=$(du -sm "$DOWNLOADS_DIR" | awk '{print $1}')
# Get human-readable size for logging
human_size=$(du -sh "$DOWNLOADS_DIR" | awk '{print $1}')

# 5. Logical check
if [ "$current_size_mb" -gt "$SIZE_LIMIT_MB" ]; then
    log_warn "Downloads folder is too large: $human_size (Limit: ${SIZE_LIMIT_MB}MB)"
    log_info "Recommendation: Clean up old ISO files or large installers."
    exit 1
fi

log_info "Downloads folder size is within limits: $human_size."
exit 0
