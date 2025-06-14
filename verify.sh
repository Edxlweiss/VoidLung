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

ui_print "🔍 Verifying module integrity with SHA256..."

CHECKSUM_FILE="$MODPATH/checksum.sha256"

if [ -f "$CHECKSUM_FILE" ]; then
  cd "$MODPATH" || abort "❌ Cannot access module directory."

  # Perform verification on all listed files
  sha256sum -c checksum.sha256 2>/dev/null

  if [ $? -ne 0 ]; then
    ui_print "❌ SHA256 verification failed! One or more files are corrupted or tampered with."
    abort "Installation aborted due to integrity failure."
  else
    ui_print "✅ All files passed SHA256 verification."
  fi
else
  ui_print "⚠️ checksum.sha256 not found. Skipping file integrity check."
fi