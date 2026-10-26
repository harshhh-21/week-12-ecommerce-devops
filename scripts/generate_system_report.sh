
#!/usr/bin/env bash

set -u

PROJECT_DIR="$HOME/week-12-ecommerce-devops"
REPORT_DIR="$PROJECT_DIR/docs/reports"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
REPORT_FILE="$REPORT_DIR/system_report_${TIMESTAMP}.txt"

mkdir -p "$REPORT_DIR" || {
    echo "ERROR: Could not create report directory."
    exit 1
}

if ! command -v free >/dev/null 2>&1; then
    echo "ERROR: The 'free' command is unavailable."
    exit 1
fi

{
    echo "Linux System Report"
    echo "Generated: $(date)"
    echo "Hostname: $(hostname)"
    echo

    echo "===== Operating System ====="
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        echo "${PRETTY_NAME:-Unknown}"
    fi
    echo

    echo "===== Uptime ====="
    uptime
    echo

    echo "===== Memory ====="
    free -h
    echo

    echo "===== Disk ====="
    df -h
    echo

    echo "===== CPU and Memory Processes ====="
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
    echo

    echo "===== IP Addresses ====="
    hostname -I
} > "$REPORT_FILE" || {
    echo "ERROR: Failed to write report."
    exit 1
}

echo "Report created: $REPORT_FILE"
