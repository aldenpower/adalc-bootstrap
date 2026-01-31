#!/usr/bin/env bash

# Disable colors if not a TTY or if NO_COLOR is set
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    COLOR_RESET="\033[0m"
    COLOR_RED="\033[31m"
    COLOR_GREEN="\033[32m"
    COLOR_YELLOW="\033[33m"
    COLOR_BLUE="\033[34m"
    COLOR_BOLD="\033[1m"
else
    COLOR_RESET=""
    COLOR_RED=""
    COLOR_GREEN=""
    COLOR_YELLOW=""
    COLOR_BLUE=""
    COLOR_BOLD=""
fi

_log() {
    local level="$1"
    local color="$2"
    shift 2
    printf "%b[%s]%b %s\n" \
        "$color" "$level" "$COLOR_RESET" "$*"
}

log_info() {
    _log "INFO" "$COLOR_BLUE" "$@"
}

log_warn() {
    _log "WARN" "$COLOR_YELLOW" "$@"
}

log_error() {
    _log "ERROR" "$COLOR_RED" "$@"
    exit 1
}

log_success() {
    _log "OK" "$COLOR_GREEN" "$@"
}
