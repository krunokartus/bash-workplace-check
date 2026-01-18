#!/bin/bash
# Description: Audits SSH configuration for basic security best practices.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting SSH Configuration audit..."

SSH_CONFIG="/etc/ssh/sshd_config"

if [[ ! -f "$SSH_CONFIG" ]]; then
    log_error "SSH configuration file not found at $SSH_CONFIG"
    exit 1
fi

# 2. Security checks
check_setting() {
    local setting=$1
    local expected=$2
    local description=$3
    
    # Get the actual value, ignoring comments
    local actual=$(grep "^$setting" "$SSH_CONFIG" | awk '{print $2}' | tr -d '\r')
    
    if [[ -z "$actual" ]]; then
        log_warn "$description ($setting): Not explicitly set (using default)."
    elif [[ "$actual" == "$expected" ]]; then
        log_info "$description ($setting): Matches recommended value ($expected)."
    else
        log_warn "$description ($setting): Current value '$actual' differs from recommended '$expected'."
    fi
}

# 3. Run audits
check_setting "PermitRootLogin" "no" "Root Login"
check_setting "PasswordAuthentication" "no" "Password Authentication"
check_setting "X11Forwarding" "no" "X11 Forwarding"
check_setting "MaxAuthTries" "3" "Max Auth Tries"

log_info "SSH audit complete. Review warnings for potential hardening."

exit 0
