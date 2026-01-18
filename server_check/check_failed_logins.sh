#!/bin/bash
# Description: Checks for failed login attempts in the authentication logs.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting Failed Logins check..."

# 2. Check for log file or use journalctl
LOG_FILE="/var/log/auth.log"
FAILED_ATTEMPTS=""

if [[ -f "$LOG_FILE" ]]; then
    # For Debian/Ubuntu systems
    FAILED_ATTEMPTS=$(grep "Failed password" "$LOG_FILE" | tail -n 5)
else
    # Fallback to journalctl
    FAILED_ATTEMPTS=$(journalctl _SYSTEMD_UNIT=ssh.service | grep "Failed password" | tail -n 5)
fi

# 3. Analyze results
if [[ -z "$FAILED_ATTEMPTS" ]]; then
    log_info "No recent failed login attempts found. Everything looks good."
else
    log_warn "Recent failed login attempts detected:"
    echo "$FAILED_ATTEMPTS" | while read -r line; do
        echo "  -> $line"
    done
    
    # Count failed attempts
    COUNT=$(echo "$FAILED_ATTEMPTS" | wc -l)
    log_info "Total recent failures shown: $COUNT"
fi

exit 0
