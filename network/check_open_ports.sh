#!/bin/bash
# Description: Lists all ports currently listening on the system.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting check for open (listening) ports..."

# 2. Check for tool availability
if command -v ss > /dev/null 2>&1; then
    # Use ss for modern systems
    OPEN_PORTS=$(ss -tunepl | grep LISTEN)
elif command -v netstat > /dev/null 2>&1; then
    # Fallback to netstat
    OPEN_PORTS=$(netstat -tunepl | grep LISTEN)
else
    log_error "Neither 'ss' nor 'netstat' found. Cannot check open ports."
    exit 1
fi

# 3. Display results
if [[ -z "$OPEN_PORTS" ]]; then
    log_warn "No listening ports found (highly unusual)."
else
    log_info "Current listening ports:"
    # Format the output to be cleaner
    echo "$OPEN_PORTS" | awk '{print "  -> Proto: "$1" Local Address: "$5" Process: "$7}' | sed 's/users:(("//g' | sed 's/",.*)//g'
fi

exit 0
