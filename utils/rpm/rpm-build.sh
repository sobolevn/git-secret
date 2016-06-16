#!/usr/bin/env bash

set -e

source "${SECRET_PROJECT_ROOT}/utils/build-utils.sh"

# Copying all the required files to the build directory:
preinstall_files

# Building .rpm package:
cd "$SCRIPT_DEST_DIR" && build_package "rpm"

# Cleaning up:
clean_up_files && cd "${SECRET_PROJECT_ROOT}"
