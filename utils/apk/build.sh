#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/build-utils.sh"
# We need this export for `config.yml` to expand the version properly.
export SCRIPT_VERSION

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/apk/meta.sh"

# Create dest dir:
mkdir -p "$SCRIPT_DEST_DIR"

for architecture in "${ALPINE_ARCHITECTURES[@]}"; do
  ALPINE_ARCHITECTURE="$architecture"
  export ALPINE_ARCHITECTURE

  config_file="$SCRIPT_BUILD_DIR/${architecture}.yml"
  envsubst < "$SECRETS_PROJECT_ROOT/utils/apk/nfpm.yml" > "$config_file"

  # Here's the deal. We use a custom builder here,
  # because `fpm` produces a broken package.
  # It is possible to install it locally,
  # but it used to fail when installed from our Artifactory.
  # So, we switched to `nfpm` instead.
  # But, we only switched one repo for now,
  # because we are not sure that other affected packages will be fine.
  # And also `fpm` supports more tools: like pacman.
  nfpm package \
    --config "$config_file" \
    --packager 'apk' \
    --target "$SCRIPT_DEST_DIR"
done

# Cleaning up:
clean_up_files
