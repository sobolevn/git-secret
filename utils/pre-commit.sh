#!/usr/bin/env bash

set -e

unset GIT_WORK_TREE

# Run tests:
make test

if [[ $(git rev-parse --abbrev-ref HEAD) == "master" ]]; then
  # Build new manuals:
  make build-man

  # Add new files:
  git add man/man1/*
fi
