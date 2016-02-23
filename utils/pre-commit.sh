#!/bin/sh

set -e

unset GIT_WORK_TREE

# Run tests:
make test

# Build new manuals:
make build-man
