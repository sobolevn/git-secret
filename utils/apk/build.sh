#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/build-utils.sh"

preinstall_files '-c'

# Building .apk package:
cd "$SCRIPT_DEST_DIR" && build_package 'apk'

# Cleaning up:
clean_up_files && cd "$SECRETS_PROJECT_ROOT"
