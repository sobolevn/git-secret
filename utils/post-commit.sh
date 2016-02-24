#!/usr/bin/env bash

set -e

if [[ $(git rev-parse --abbrev-ref HEAD) == "master" ]]; then
  # Build new web documentation:
  make build-gh-pages
fi
