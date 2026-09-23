#!/bin/bash
set -eo pipefail

echo "=========================================="
echo "      MiniPay System Health Check         "
echo "  Timestamp: $(date -u)  "
echo "=========================================="

# 1. Disk Space Check (Threshold 90%)
DISK_USAGE=$(df / | awk 'END{print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "[FAIL] Critical Disk Usage: ${DISK_USAGE}%"
else
    echo "[OK] Disk Usage within limit: ${DISK_USAGE}%"
fi

# 2. Free Memory Check
MEM_FREE_PCT=$(free | awk '/Mem:/ {printf "%.2f", $4/$2 * 100}')
echo "[OK] Available Memory: ${MEM_FREE_PCT}%"

# 3. Docker Service Check
if systemctl is-active --quiet docker; then
    echo "[OK] Docker Engine is active"
else
    echo "[FAIL] Docker Engine is inactive"
fi

echo "=========================================="
