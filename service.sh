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

wait_until_login() {
  while [[ "$(getprop sys.boot_completed)" -ne 1 || ! -d "/sdcard" ]]; do
    sleep 2
  done
  local test_file="/sdcard/.PERMISSION_TEST"
  touch "$test_file"
  while [ ! -f "$test_file" ]; do
    touch "$test_file"
    sleep 2
  done
  rm "$test_file"
}

wait_until_login
sleep 2

SRC_WHITELIST="${0%/*}/whitelist.txt"
DST_WHITELIST="/sdcard/Android/VoidLung/whitelist.txt"

# Copy if not already existing
[ -f "$DST_WHITELIST" ] || {
  mkdir -p "$(dirname "$DST_WHITELIST")"
  cp "$SRC_WHITELIST" "$DST_WHITELIST"
}