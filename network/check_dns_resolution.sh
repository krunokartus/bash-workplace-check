#!/bin/bash
# Description: Verifies DNS resolution functionality using common domains.

# 1. Load the shared library
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/common.sh"

log_info "Starting DNS resolution check..."

# 2. Domains to test
TEST_DOMAINS=("google.com" "cloudflare.com" "github.com")
SUCCESS_COUNT=0

for domain in "${TEST_DOMAINS[@]}"; do
    if host "$domain" > /dev/null 2>&1 || nslookup "$domain" > /dev/null 2>&1; then
        log_info "Successfully resolved $domain"
        ((SUCCESS_COUNT++))
    else
        log_warn "Failed to resolve $domain"
    fi
done

# 3. Final verdict
if [ "$SUCCESS_COUNT" -eq 0 ]; then
    log_error "DNS resolution is completely non-functional."
    exit 1
elif [ "$SUCCESS_COUNT" -lt "${#TEST_DOMAINS[@]}" ]; then
    log_warn "DNS resolution is partially functional ($SUCCESS_COUNT/${#TEST_DOMAINS[@]} tests passed)."
    exit 0
else
    log_info "DNS resolution is working perfectly."
    exit 0
fi
