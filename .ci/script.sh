#!/usr/bin/env bash

set -e

function run_kitchen_tests {
  ansible --version
  ruby --version
  python --version
  pip --version
  bundler --version
  bundle show
  bundle exec kitchen test --test-base-path="$PWD/.ci/integration" $KITCHEN_REGEXP
}

# Local builds:
if [[ "$GITSECRET_DIST" == "brew" ]]; then
  # Only running `make test` on standard (non-docker) build,
  # since it is called inside the docker container anyway.
  make test
fi

# Linux:
if [[ "$TRAVIS_OS_NAME" == "linux" ]] && [[ -n "$KITCHEN_REGEXP" ]]; then
  run_kitchen_tests
fi
