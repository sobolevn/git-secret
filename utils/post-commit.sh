#!/usr/bin/env bash

set -e

BRANCH_NAME=$(git branch | grep '*' | sed 's/* //')

if [[ "$BRANCH_NAME" == 'master' ]]; then
  # Build new web documentation:
  make build-gh-pages

  # create new release:
  NEWEST_TAG=$(git describe --abbrev=0 --tags)
  SCRIPT_VERSION=$(git secret --version)
  if [[ "$NEWEST_TAG" != "$SCRIPT_VERSION" ]]; then
      git tag -a "$SCRIPT_VERSION" -m "version $SCRIPT_VERSION"
  fi
fi
