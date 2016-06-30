#!/usr/bin/env bash

set -e

# Docker:
if [[ ! -z "$DOCKER_DIST" ]]; then
  TEMPLATE="sobolevn/git-secret-docker-$DOCKER_DIST"
  DOCKERFILE_PATH=".docker/${GITSECRET_DIST}/${DOCKER_DIST}"

  # Building the local image:
  docker build -t "$TEMPLATE" "$DOCKERFILE_PATH"
fi

# Mac:
if [[ "$GITSECRET_DIST" == "brew" ]]; then
  brew install "$GITSECRET_GPG_DEP"
fi

# Local linux (standart build):
if [[ "$GITSECRET_DIST" == "none" ]]; then
  if [[ "$GITSECRET_LINT" == 'lint' ]]; then
    sudo apt-get update

    # Installing linter:
    sudo apt-get install -y shellcheck
  fi

  if [[ "$GITSECRET_GPG_DEP" == "gnupg2" ]]; then
    # Installing custom GPG version:
    sudo apt-get install -y gnupg2
  fi
fi
