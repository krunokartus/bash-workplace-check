#!/bin/bash
# Description: Checks if a default gateway is configured and reachable.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting Default Gateway check..."

# 2. Get the default gateway IP
gateway_ip=$(ip route | grep default | awk '{print $3}' | head -n 1)

if [[ -z "$gateway_ip" ]]; then
    log_warn "No default gateway found in the routing table."
    exit 1
fi

log_info "Found default gateway: $gateway_ip"

# 3. Ping the gateway to check connectivity
if ping -c 3 -W 2 "$gateway_ip" > /dev/null 2>&1; then
    log_info "Default gateway $gateway_ip is reachable."
else
    log_warn "Default gateway $gateway_ip is NOT reachable (Ping failed)."
    exit 1
fi

exit 0
