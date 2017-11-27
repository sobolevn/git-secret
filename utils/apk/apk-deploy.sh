#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090,SC1091
source "${SECRET_PROJECT_ROOT}/utils/build-utils.sh"

# Variables, which will be used in `bintray.json`:
SCRIPT_VERSION=$(bash "${PWD}/git-secret" --version)
RELEASE_DATE=$(date +%Y-%m-%d)

# add `\"override\": 1 \` into the `matrixParams`, if needed:
echo "{ \
  \"package\": { \
    \"name\": \"git-secret\", \
    \"repo\": \"apk\", \
    \"subject\": \"sobolevn\" \
  }, \
  \"version\": {
    \"name\": \"${SCRIPT_VERSION}\", \
    \"desc\": \"Version ${SCRIPT_VERSION}\", \
    \"released\": \"${RELEASE_DATE}\", \
    \"vcs_tag\": \"v${SCRIPT_VERSION}\", \
    \"gpgSign\": true \
  }, \
  \"files\": [{ \
    \"includePattern\": \"build/buildroot/(.*\\\\\\.apk)\", \
    \"uploadPattern\": \"/git-secret_${SCRIPT_VERSION}_all.apk\" \
  }], \
  \"publish\": true \
}" > "${SECRET_PROJECT_ROOT}/build/apk_descriptor.json"
