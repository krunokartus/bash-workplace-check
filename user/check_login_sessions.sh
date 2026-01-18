#!/bin/bash
# Description: Monitors current active login sessions on the system.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting Login Sessions check..."

# 2. Data gathering
# Use 'who' to get active sessions
active_sessions=$(who)
session_count=$(who | wc -l)

# 3. Logical check/Display
if [ "$session_count" -eq 0 ]; then
    log_warn "No active login sessions found (unusual if running interactively)."
else
    log_info "Found $session_count active session(s):"
    echo "$active_sessions" | while read -r line; do
        echo "  -> $line"
    done
fi

# Check if current user is logged in multiple times
my_sessions=$(who | grep -c "^$USER ")
if [ "$my_sessions" -gt 2 ]; then
    log_warn "User '$USER' has $my_sessions active sessions. Possible forgotten logins?"
fi

exit 0
