#!/usr/bin/env bash

# ERR Trap inherited by functions, exit on error, error on undefined vars, and pipe fails if any stage does
set -Eeuo pipefail
# Ensure IFS does not split on spaces (reduces code injection issues from whitespace in file names)
IFS=$'\n\t'

# sh has no syntax for arrays which are required for this
# Each of these is used as a prefix to a string for printing messages in specific colors
## Errors will display in red
export ERR="\e[31m"
## Successes will display in green
export SUC="\e[32m"
# Warnings will display in yellow
export WARN="\e[33m"
# Information will display in cyan
export INFO="\e[36m"
# This is used to end the use of a specific color
export EC="\e[0m"
# The -j number CPU makes the make command not use just 1 thread to build OAR's code
# Since function, first define then set to global
NUM_CPU="-j$(lscpu | grep "CPU(s):" | head -n1 | awk '{print $2}')"
export NUM_CPU

# Logging functions
log_error() {
        echo -e "${ERR}[ERROR]${EC} $1"
        exit 1
}

log_error_no_exit() {
        echo -e "${ERR}[ERROR]${EC} $1"
}

log_success() {
        echo -e "${SUC}[SUCCESS]${EC} $1"
}

log_warning() {
        echo -e "${WARN}[WARN]${EC} $1"
}

log_info() {
        echo -e "${INFO}[INFO]${EC} $1"
}

check_connect()  {
    # I check multiple sites just in case one of them is down
    local endpoints=(
        "https://www.google.com"
        "https://cloudflare.com"
        "https://www.debian.org"
    )
    local curl_opts=(--silent --show-error --location --max-time 5 \
                     --output /dev/null --fail)

    # Make sure curl exists
    if ! command -v curl &>/dev/null; then
        log_error "curl is not installed. Please install it so I can check for an internet connection"
    fi

    # Check connectivity to the end points
    # Use curl's EXIT CODE as the source of truth (--fail makes HTTP >=400
    # a failure too). Try each endpoint; succeed on the first that works.
    local ep
    for ep in "${endpoints[@]}"; do
        if curl "${curl_opts[@]}" "$ep"; then
            log_success "Connection Confirmed"
            return 0
        fi
    done

    # All endpoints failed.
    log_error_no_exit "No Internet connection (all test endpoints unreachable)."
    log_error_no_exit "Please ensure your NAT connection is set up for DHCP."
    log_error_no_exit "If the NAT connection does not appear in gnome-control-center but does"
    log_error "show with "ip a", set the interface to DHCP, e.g.:  sudo dhclient <iface>"
}
