#!/usr/bin/env bash

set -e

if [[ "$GITSECRET_DIST" == "rpm" ]]; then
  # To deploy `rpm`-packages this utility is needed:
  sudo apt-get install -y rpm;
fi

# if not null GITSECRET_DIST
if [[ -n "$GITSECRET_DIST" ]]; then
  # When making a non-container build, this step will generate
  # proper manifest files:
  make "deploy-$GITSECRET_DIST";
fi
