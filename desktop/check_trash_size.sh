#!/bin/bash
# Description: Checks the size of the System Trash and warns if it exceeds a limit.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

# 2. Configuration
TRASH_DIR="$HOME/.local/share/Trash"
# Limit in megabytes (e.g., 1000 MB = 1 GB)
SIZE_LIMIT_MB=1000

log_info "Starting Trash size check..."

# 3. Validation
if [ ! -d "$TRASH_DIR" ]; then
    log_info "Trash directory does not exist or is empty. Skipping."
    exit 0
fi

# 4. Data gathering
# Get size in MB
current_size_mb=$(du -sm "$TRASH_DIR" | awk '{print $1}')
# Get human-readable size
human_size=$(du -sh "$TRASH_DIR" | awk '{print $1}')

# 5. Logical check
if [ "$current_size_mb" -gt "$SIZE_LIMIT_MB" ]; then
    log_warn "Trash is taking up too much space: $human_size (Limit: ${SIZE_LIMIT_MB}MB)"
    log_info "Recommendation: Empty your trash to regain disk space."
    exit 1
fi

log_info "Trash size is within limits: $human_size."
exit 0
