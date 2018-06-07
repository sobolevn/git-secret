#!/usr/bin/env bash

set -e

echo "£££ before deploy with GITSECRET_DIST=${GITSECRET_DIST}, GITSECRET_DIST=${GITSECRET_DIST}, KITCHEN_REGEXP=${KITCHEN_REGEXP}"

echo "£££ before deploy with GITSECRET_DIST=${GITSECRET_DIST}"

if [[ "$GITSECRET_DIST" == "rpm" ]]; then
  echo "£££ sudo apt-get install -y rpm;"
  # To deploy `rpm`-packages this utility is needed:
  sudo apt-get install -y rpm;
fi

if [[ ! -z "$GITSECRET_DIST" ]] && [[ -z "$KITCHEN_REGEXP" ]]; then
  echo "£££ sudo apt-get install -y rpm;"
  # When making a non-container build, this step will generate
  # proper manifest files:
  make "deploy-$GITSECRET_DIST";
fi
