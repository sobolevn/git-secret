#!/usr/bin/env bash

set -e

# shellcheck source=./utils/build-utils.sh
# shellcheck disable=SC1091
source "${SECRET_PROJECT_ROOT}/utils/build-utils.sh"

preinstall_files

# Building .deb package:
cd "$SCRIPT_DEST_DIR" && build_package "deb"

# Cleaning up:
clean_up_files && cd "${SECRET_PROJECT_ROOT}"
