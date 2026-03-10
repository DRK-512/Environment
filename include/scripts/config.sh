#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Exit on error, undefined vars, and pipe failures
#set -euo pipefail

readonly ERR="\e[31m"
readonly SUC="\e[32m"
readonly WARN="\e[33m"
readonly INFO="\e[36m"
readonly NC="\e[0m"

# Logging functions
log_error() {
    echo -e "${ERR}[ERROR]${NC} $1"
    exit 1
}

log_error_no_exit() {
    echo -e "${ERR}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${SUC}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${WARN}[WARN]${NC} $1"
}

log_info() {
    echo -e "${INFO}[INFO]${NC} $1"
}

