#!/system/bin/sh
#
# VoidLung Magisk/KernelSU Module
# Copyright (c) 2025, edxlweiss
# All rights reserved.
#
# This file is part of the VoidLung module.
#
# SPDX-License-Identifier: BSD-3-Clause
#
# For the full license text, see the LICENSE.txt file in the module's root directory.
#

LOGFILE="/sdcard/Android/VoidLung/log.txt"
WL="/sdcard/Android/VoidLung/whitelist.txt"
[ -f "$WL" ] || WL="/dev/null"

# Function to extract available memory (in MB)
get_free_ram() {
    awk '/MemAvailable:/ { printf "%.0f\n", $2 / 1024 }' /proc/meminfo
}

# Record RAM before
RAM_BEFORE=$(get_free_ram)
echo "💾 RAM before purge: ${RAM_BEFORE} MB"

# Reset log
{
    echo "=== VoidLung Execution Log ==="
    date
    echo ""
    echo "💾 RAM before purge: ${RAM_BEFORE} MB"
    echo ""
} > "$LOGFILE"

# Get current foreground app
FG_APP=$(dumpsys activity activities | grep "mResumedActivity" | awk -F ' ' '{print $4}' | cut -d '/' -f1)
WHITELIST=$(cat "$WL")

echo "Foreground app: $FG_APP" | tee -a "$LOGFILE"
echo "Reading whitelist from: $WL" >> "$LOGFILE"
echo "$WHITELIST" >> "$LOGFILE"
echo "" >> "$LOGFILE"
echo "Commencing purge..." >> "$LOGFILE"

# Loop over user-installed apps
for pkg in $(pm list packages -3 | cut -f2 -d:); do
    if echo "$WHITELIST" | grep -qx "$pkg"; then
        echo "❎ Skipped (whitelisted): $pkg" | tee -a "$LOGFILE"
        continue
    fi
    if [ "$pkg" = "$FG_APP" ]; then
        echo "❎ Skipped (foreground): $pkg" | tee -a "$LOGFILE"
        continue
    fi
    am force-stop "$pkg"
    echo "💥 Killed: $pkg" | tee -a "$LOGFILE"
done

# Record RAM after
RAM_AFTER=$(get_free_ram)
RAM_DIFF=$((RAM_AFTER - RAM_BEFORE))

echo "" >> "$LOGFILE"
echo "💾 RAM after purge: ${RAM_AFTER} MB" | tee -a "$LOGFILE"
echo "📈 RAM freed: ${RAM_DIFF} MB" | tee -a "$LOGFILE"
echo "✅ VoidLung: Memory purge complete." | tee -a "$LOGFILE"

# Also print to terminal
echo "💾 RAM after purge: ${RAM_AFTER} MB"
echo "📈 RAM freed: ${RAM_DIFF} MB"
echo "✅ VoidLung: Memory purge complete."