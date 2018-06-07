#!/usr/bin/env bash

set -e

echo "£££ before deploy with GITSECRET_DIST=${GITSECRET_DIST}, KITCHEN_REGEXP=${KITCHEN_REGEXP}"

if [[ "$GITSECRET_DIST" == "rpm" ]]; then
  echo "£££ sudo apt-get install -y rpm;"
  # To deploy `rpm`-packages this utility is needed:
  sudo apt-get install -y rpm;
else
  echo "£££ not rpm"
fi

# if not null GITSECRET_DIST and null KITCHEN_REGEXP
if [[ ! -z "$GITSECRET_DIST" ]] && [[ -z "$KITCHEN_REGEXP" ]]; then
  echo "£££ make deploy-$GITSECRET_DIST"
  # When making a non-container build, this step will generate
  # proper manifest files:
  make "deploy-$GITSECRET_DIST";
else
  echo "£££ not make deploy-$GITSECRET_DIST"
fi
