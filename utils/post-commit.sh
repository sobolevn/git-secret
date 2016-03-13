#!/usr/bin/env bash

set -e

BRANCH_NAME=$(git branch | grep '*' | sed 's/* //')

if [[ "$BRANCH_NAME" == 'master' ]]; then
  # Build new web documentation:
  make build-gh-pages
fi

if [[ "$BRANCH_NAME" == 'develop' ]]; then
  # create new release:
  NEWEST_TAG=$(git describe --abbrev=0 --tags)
  SCRIPT_VERSION=$(bash ${PWD}/git-secret --version)
  if [[ "$NEWEST_TAG" != "v${SCRIPT_VERSION}" ]]; then
      git tag -a "v${SCRIPT_VERSION}" -m "version $SCRIPT_VERSION"
fi
