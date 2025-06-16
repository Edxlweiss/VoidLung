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

SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

ui_print "Installing VoidLung components..."

# Extract core scripts
ui_print "- Extracting action.sh"
unzip -o "$ZIPFILE" 'action.sh' -d $MODPATH >&2

ui_print "- Extracting uninstall.sh"
unzip -o "$ZIPFILE" 'uninstall.sh' -d $MODPATH >&2

ui_print "- Extracting verify.sh"
unzip -o "$ZIPFILE" 'verify.sh' -d $MODPATH >&2

ui_print "- Extracting whitelist.txt"
unzip -o "$ZIPFILE" 'whitelist.txt' -d $MODPATH >&2

# Extract Web UI
ui_print "- Extracting Web UI (webroot/)"
unzip -o "$ZIPFILE" 'webroot/*' -d $MODPATH >&2

# Prepare persistent data directory
ui_print "- Creating /sdcard/Android/VoidLung"
mkdir -p /sdcard/Android/VoidLung

# Deploy default whitelist if not present
if [ ! -f /sdcard/Android/VoidLung/whitelist.txt ]; then
  ui_print "- Copying default whitelist.txt to /sdcard/Android/VoidLung/"
  cp "$MODPATH/whitelist.txt" /sdcard/Android/VoidLung/
else
  ui_print "- Preserving existing whitelist.txt"
fi

# Permissions
ui_print "- Setting permissions"
set_perm_recursive "$MODPATH" 0 0 0755 0644
chmod +x "$MODPATH/action.sh"
chmod +x "$MODPATH/uninstall.sh"
chmod +x "$MODPATH/verify.sh"

ui_print "VoidLung installation complete."

# Easter egg time!
EASTER_EGGS=$(cat <<'EOF'
🌌 You have fed the Void. It is pleased.
🛸 Beware... the VoidLung hungers again soon.
💀 Purge complete. Your RAM is now free... for now.
📦 One more package to the shadow realm.
👁 The apps screamed. But only once.
🌫️ Welcome to the digital blackhole.
🧼 Cleanliness is next to Voidliness.
📉 RAM usage: reduced. Sanity: questionable.
💻 Apps stopped responding. That's the point.
🕳️ The Void thanks you for your offering.
EOF
)

RANDOM_EGG=$(echo "$EASTER_EGGS" | shuf -n 1)
ui_print "$RANDOM_EGG"