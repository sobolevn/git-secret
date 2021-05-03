#!/usr/bin/env bash

set -e

# Note that this file is created for test purposes:
# 1. It runs inside the Docker container
# 2. It does not use `sudo` or anything
# 3. If you would like to install `.apk` package on your system, see `Installation`

# shellcheck disable=SC1090,SC1091
source "${SECRET_PROJECT_ROOT}/utils/build-utils.sh"

# This folder should contain just one .apk file:
APK_FILE_LOCATION=$(locate_apk)


# Integration tests
function integration_tests {
  # Installing the package:
  apk add "$APK_FILE_LOCATION"

  # Configuring the dependencies:
  apk add --update-cache

  # Testing the installation:
  apk info | grep 'git-secret'
  # lint says to use 'command -v' and not 'which'
  command -v 'git-secret'

  # Test the manuals:
  man --where 'git-secret' # .7
  man --where 'git-secret-init' # .1
}

integration_tests

# Unit tests:
# shellcheck disable=SC1090,SC1091
source "${SECRET_PROJECT_ROOT}/utils/tests.sh"
