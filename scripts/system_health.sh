
#!/usr/bin/env bash

set -u

echo "===================================="
echo " Linux System Health Check"
echo "===================================="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo

echo "---- Operating System ----"
if [[ -r /etc/os-release ]]; then
    . /etc/os-release
    echo "OS: ${PRETTY_NAME:-Unknown}"
else
    echo "OS information unavailable"
fi
echo

echo "---- Uptime and Load ----"
uptime
echo

echo "---- Memory Usage ----"
free -h
echo

echo "---- Disk Usage ----"
df -h
echo

echo "---- Top Processes by CPU ----"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
echo

echo "---- Network Interfaces ----"
ip -brief address 2>/dev/null || hostname -I
echo

echo "Health check completed."
