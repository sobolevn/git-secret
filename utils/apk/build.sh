#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090,SC1091
source "$SECRET_PROJECT_ROOT/utils/build-utils.sh"

preinstall_files '-c'

# Building .deb package:
cd "$SCRIPT_DEST_DIR" && build_package 'apk'

# Cleaning up:
clean_up_files && cd "$SECRET_PROJECT_ROOT"
