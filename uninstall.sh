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

ui_print "💀 Uninstalling VoidLung..."

# External data path
WL_DIR="/sdcard/Android/VoidLung"

# Remove whitelist directory and contents
if [ -d "$WL_DIR" ]; then
  rm -rf "$WL_DIR"
  ui_print "🧹 Removed: $WL_DIR"
else
  ui_print "⚠️ Whitelist directory not found: $WL_DIR"
fi

ui_print "✅ VoidLung fully uninstalled."