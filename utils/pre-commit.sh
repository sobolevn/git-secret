#!/usr/bin/env bash

set -e

unset GIT_WORK_TREE

# Run tests:
make test

# Build new manuals:
make build-man

# Add new files:
git add man/man1/*
