#!/bin/bash
# Description: Checks the size of the shell history file.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting Shell History Size check..."

# 2. Determine history file (bash/zsh)
HIST_FILE=""
if [[ "$SHELL" == *"zsh"* ]]; then
    HIST_FILE="$HOME/.zsh_history"
else
    HIST_FILE="$HOME/.bash_history"
fi

# 3. Check if file exists
if [[ ! -f "$HIST_FILE" ]]; then
    log_warn "History file '$HIST_FILE' not found or empty."
    exit 0
fi

# 4. Data gathering
line_count=$(wc -l < "$HIST_FILE")
file_size_kb=$(du -k "$HIST_FILE" | awk '{print $1}')

log_info "History file: $HIST_FILE"
log_info "Lines: $line_count | Size: ${file_size_kb}KB"

# 5. Logical check
# Warn if history is very large (e.g., > 10,000 lines)
if [ "$line_count" -gt 10000 ]; then
    log_warn "History file is quite large ($line_count lines). This might slightly slow down shell startup."
fi

exit 0
