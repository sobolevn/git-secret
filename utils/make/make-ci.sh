#!/usr/bin/env bash

set -e

# Note that this file is created for test purposes:
# 1. It runs inside the Docker container
# 2. It does not use `sudo` or anything
# 3. If you would like to install a package with `make` on your system,
#    see `Installation`


# Integration tests
function integration_tests {
  # Building the package:
  make build

  # Installing the package:
  make install

  # Testing the installation:
  which "git-secret"

  # Test the manuals:
  man --where "git-secret" # .7
  man --where "git-secret-init" # .1
}

integration_tests

# Unit tests:
# shellcheck disable=SC1090,SC1091
source "${SECRET_PROJECT_ROOT}/utils/tests.sh"
