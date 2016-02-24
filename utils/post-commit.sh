#!/usr/bin/env bash

set -e

BRANCH_NAME=$(git branch | grep '*' | sed 's/* //')

if [[ $BRANCH_NAME == 'master' ]]; then
  # Build new web documentation:
  make build-gh-pages
fi
