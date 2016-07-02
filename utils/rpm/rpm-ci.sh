#!/usr/bin/env bash

set -e

# Note that this file is created for test purposes:
# 1. It runs inside the Docker container
# 2. It does not use `sudo` or anything
# 3. If you would like to install `.rpm` package on your system, see `Installation`

# shellcheck source=./utils/build-utils.sh
# shellcheck disable=SC1091
source "${SECRET_PROJECT_ROOT}/utils/build-utils.sh"

# This folder should contain just one .rpm file:
RPM_FILE_LOCATION=$(locate_rpm)


# Integration tests
function integration_tests {
  # Installing the package:
  dnf install -y "$RPM_FILE_LOCATION"

  # Testing the installation:
  dnf info "git-secret"
  which "git-secret"

  # Test the manuals:
  man --where "git-secret" # .7
  man --where "git-secret-init" # .1
}

integration_tests

# Unit tests:
# shellcheck source=./utils/tests.sh
# shellcheck disable=SC1091
source "${SECRET_PROJECT_ROOT}/utils/tests.sh"
