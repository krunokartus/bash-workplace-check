#!/bin/bash
# Description: Checks the status of critical system services.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting Service Status check..."

# 2. Services to monitor (can be customized)
SERVICES=("ssh" "sshd" "docker" "nginx" "apache2" "cron")
FOUND_ANY=false

for service in "${SERVICES[@]}"; do
    # Check if the service unit exists
    if systemctl list-unit-files | grep -q "^$service.service"; then
        FOUND_ANY=true
        if systemctl is-active --quiet "$service"; then
            log_info "Service '$service' is running."
        else
            log_warn "Service '$service' is NOT running!"
        fi
    fi
done

if [ "$FOUND_ANY" = false ]; then
    log_warn "None of the predefined critical services were found on this system."
fi

exit 0
