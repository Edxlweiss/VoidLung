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

# Reset log
{
    echo "=== VoidLung Execution Log ==="
    date
    echo ""
} > "$LOGFILE"

# Get foreground app package
FG_APP=$(dumpsys activity activities | grep "mResumedActivity" | awk -F ' ' '{print $4}' | cut -d '/' -f1)
WHITELIST=$(cat "$WL")

echo "Foreground app: $FG_APP" | tee -a "$LOGFILE"
echo "Reading whitelist from: $WL" >> "$LOGFILE"
echo "$WHITELIST" >> "$LOGFILE"
echo "" >> "$LOGFILE"
echo "Commencing purge..." >> "$LOGFILE"

# Loop through installed user apps (non-system)
for pkg in $(pm list packages -3 | cut -f2 -d:); do
    # Skip if whitelisted
    if echo "$WHITELIST" | grep -qx "$pkg"; then
        echo "❎ Skipped (whitelisted): $pkg" | tee -a "$LOGFILE"
        continue
    fi

    # Skip foreground app
    if [ "$pkg" = "$FG_APP" ]; then
        echo "❎ Skipped (foreground): $pkg" | tee -a "$LOGFILE"
        continue
    fi

    # Kill background app
    am force-stop "$pkg"
    echo "💥 Killed: $pkg" | tee -a "$LOGFILE"
done

echo "" >> "$LOGFILE"
echo "✅ VoidLung: Memory purge complete." | tee -a "$LOGFILE"