#!/bin/sh

set -e

# Run tests:
make test

# Build new manuals:
make build-man
