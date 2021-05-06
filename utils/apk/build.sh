#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/build-utils.sh"
# We need this export for `config.yml` to expand the version properly.
export SCRIPT_VERSION

# Create dest dir:
mkdir -p "$SCRIPT_DEST_DIR"

# Here's the deal. We use a custom builder here,
# because `fpm` produces a broken package.
# It is possible to install it locally,
# but it fails to be installed from our Artifactory.
# So, we switched.
# But, we only switched one repo for now,
# because we are not sure that other affected packages will be fine.
# And also `fpm` supports more tools: like pacman.
nfpm package \
  -f "$SECRETS_PROJECT_ROOT/utils/apk/config.yml" \
  --packager 'apk' \
  --target "$SCRIPT_DEST_DIR"
